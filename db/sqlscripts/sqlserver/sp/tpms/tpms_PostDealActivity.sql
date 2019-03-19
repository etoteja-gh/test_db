CREATE PROCEDURE [dbo].[tpms_PostDealActivity] AS

/*********************************
 * sp_TPMS_PostDealActivity    
 * Post Deal Activity
 * B. Sullivan
 *********************************/

/* Modified  6/4/03  Rewrite                                    */
/* Modified  6/4/03  Comment out direct post to funds           */
/* Modified  6/4/03  Spread amounts of records with no ProdID   */
/* Modified  6/25/03 Fix double posting problem                 */
/* Modified  1/5/04  Fix accrual posting problem                */
/* Modified  1/7/04  Fix Posting to Closed OI Deal error        */
/* Modified  5/27/04 Documentation                              */
/* Modified  7/19/04 Elim fully qualified db names              */
/* Modified  7/19/04 Make Temp tables #Temp                     */
/* Modified  7/21/04 Modify Temp tables Drop                    */
/* Modified  7/30/04 Calc extended 8.0 fields                   */
/* Modified  8/11/04 Fix Calc extended 8.0 fields               */

/***************************************************************
 * Reset Posting for testing
 ***************************************************************/
/*
Update Deals set Accrual = 0, Payments = 0, ActVol = 0
Update DealProducts set Accrual = 0, Payments = 0, ActVol = 0
Update DealActivity SET Posted = 0, PostDate = NULL
truncate table BatchErrors
*/

/******************************************
 * Update Batch Monitor Table
 ******************************************/
/* Set OID values for Batch Monitor  */
DECLARE @BatchOID int
DECLARE @OID int
DECLARE @BatchStart smalldatetime
DECLARE @StepEnd smalldatetime

/*Set OID Value */
IF (SELECT Max(OID) from BatchMonitor) is null
  BEGIN
    SET @BatchOID = 0
  END
 ELSE
  BEGIN
    SELECT @BatchOID = Max(OID) from BatchMonitor
  END

SET @BatchOID = @BatchOID + 1
SET @BatchStart = (SELECT Max(BatchStart) FROM BatchMonitor)
IF @BatchStart IS NULL
BEGIN
  SET @BatchStart = GetDate()
END 

INSERT INTO BatchMonitor (OID, BatchStart, BatchStep, StepStart, Status)
VALUES (@BatchOID, @BatchStart, 'Post DealActivity', GetDate(), 'Running')
 

/************************************************
 * Update Parameter Table entries for Col Widths
 ************************************************/
DECLARE @ColWidth int

SET @ColWidth = 10

SELECT @ColWidth = Max(Len(Name)) FROM Orgs 
               WHERE Orgs.Name IS NOT NULL
UPDATE Parameters SET Value = @ColWidth 
WHERE Parameters.Variable = 'MAX_CUST_NAME'

SELECT @ColWidth = Max(Len(Name)) FROM Products 
               WHERE Products.Name IS NOT NULL
UPDATE Parameters SET Value = @ColWidth 
WHERE Parameters.Variable = 'MAX_PROD_NAME' 

SELECT @ColWidth = Max(Len(Name)) FROM FundMaster 
               WHERE FundMaster.Name IS NOT NULL
UPDATE Parameters SET Value = @ColWidth 
WHERE Parameters.Variable = 'MAX_FUND_NAME' 

SELECT @ColWidth = Max(Len(Name)) FROM DealTypes 
               WHERE DealTypes.Name IS NOT NULL
UPDATE Parameters SET Value = @ColWidth 
WHERE Parameters.Variable = 'MAX_DT_NAME' 


/******************************************
 * Sum records by DealID from DealActivity
 ******************************************/

IF OBJECT_ID('tempdb..#TempPostDealActivity') IS NOT NULL BEGIN
  DROP TABLE #TempPostDealActivity
END
CREATE TABLE #TempPostDealActivity
 (
  DealActID int, 
  DealID int,
  DealTypeID int,
  FundDetID int,
  ProdID int,
  ActVol numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,
  Accrual numeric (18,2) DEFAULT 0,
  ARDocsID int DEFAULT 0,
  DocType char (2),
  DocDate smalldatetime,
  RefNum varchar (25),
  Posted bit
)

INSERT INTO #TempPostDealActivity (DealActID, DealID, DealTypeID, FundDetID, ProdID, 
                                              ActVol, Payments, ARDocsID, DocType, DocDate, RefNum, Posted) 
SELECT DealActivity.OID, DealID, DealTypeID, FundDetID, ProdID, Volume, 
       DealActivity.Amount, ARDocsID, DocType, DocDate, RefNum, 1
FROM DealActivity
LEFT JOIN Deals ON Deals.OID = DealActivity.DealID
WHERE DealActivity.Posted = 0


/***************************************************************************
 * Find Errored Postings and load to Batch Errors table
 *	Posting to Paid deal 
 *	Posting to Closed OI deal 
 *	Posting Non-invoice to OI deal
 *	Posting to Inactive fund
 *	Posting to Cancelled or Deleted deal	(Don't post)
 *	Posting to Unapproved Deal
 *	Posting to a Deal that doesn't exist	(Don't post)
 *	Posting to a non-existent fund		(Don't post)
 *	
 * The initial load of TempPostDealActivity sets the Posted value to 1
 * If the record is errored and in the "Don't Post" category, the 
 * Posted value is set to zero.
 ***************************************************************************/
IF OBJECT_ID('tempdb..#TempErrors') IS NOT NULL BEGIN
  DROP TABLE #TempErrors
END

CREATE TABLE #TempErrors
(TempErrorsOID int IDENTITY(1,1), OID int, BatchStart smalldatetime, BatchStep varchar (50), DealID int,
 FundDetID int, DealActID int, ErrorID int, ErrorDetail varchar (100), Amount numeric (18,2),
 ARDocsID int, RefNum varchar(25), DocType Char(2), DocDate smalldatetime)


INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, DealID, 17, 'Posting to PAID Deal', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals Deals
WHERE TempPostDealActivity.DealID = Deals.OID
  AND Deals.SettleStatus = 'PAID'

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, DealID, 18, 'Posting to Closed OI Deal', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals Deals, 
     DealTypes DealTypes, 
     SysDealTypes SysDealTypes
WHERE TempPostDealActivity.DealID = Deals.OID
  AND Deals.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND SysDealTypes.Name in ('OI', 'PctOI')
  AND TempPostDealActivity.DocDate > Deals.DealEndDate  -- New code 1/7/04
  -- Old code changed 1/7/04        AND Deals.SysStatus = 'CL'

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, DealID, 19, 'Posting Non-Invoice to OI Deal', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals Deals, 
     DealTypes DealTypes, 
     SysDealTypes SysDealTypes
WHERE TempPostDealActivity.DealID = Deals.OID
  AND Deals.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND SysDealTypes.Name in ('OI', 'PctOI')
  AND DocType <> 'IN'
  AND Deals.SysStatus not in ('CA','DE')

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, FundDetID, 20, 'Posting to Inactive Fund', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     FundMaster FundMaster, 
     Funds Funds
WHERE TempPostDealActivity.FundDetID = Funds.OID
  AND Funds.FundID = FundMaster.OID
  AND FundMaster.Inactive = 1

/*********************************************************
 * Do not post against cancelled or deleted deals
 *********************************************************/
UPDATE #TempPostDealActivity SET Posted = 0
FROM Deals Deals
WHERE #TempPostDealActivity.DealID = Deals.OID
  AND Deals.SysStatus in ('CA','DE')

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, DealID, 21, 'Posting to Cancelled or Deleted Deal', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals Deals
WHERE TempPostDealActivity.DealID = Deals.OID
  AND Deals.SysStatus in ('CA','DE')

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DealActID, DealID, 22, 'Posting to Unapproved Deal', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals Deals
WHERE TempPostDealActivity.DealID = Deals.OID
  AND Deals.ApprovalStatus <> 'Approved'

/*********************************************************
 * Do not post if Deals do not exist
 *********************************************************/
UPDATE #TempPostDealActivity SET Posted = 0
FROM Deals
WHERE #TempPostDealActivity.DealID NOT IN (SELECT OID FROM Deals)
  AND DealID is not null
  AND DealID <> 0

INSERT INTO #TempErrors (DealActID, DealID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DISTINCT DealActID, DealID, 23, 'Deal does not exist', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity, 
     Deals
WHERE TempPostDealActivity.DealID NOT IN (SELECT OID FROM Deals)
  AND DealID is not null
  AND DealID <> 0

/*********************************************************
 * Do not post if Funds do not exist
 *********************************************************/
UPDATE #TempPostDealActivity SET Posted = 0
FROM Funds
WHERE #TempPostDealActivity.FundDetID NOT IN (SELECT OID FROM Funds)
  AND FundDetID is not null 
  AND FundDetID <> 0   

INSERT INTO #TempErrors (DealActID, FundDetID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT DISTINCT DealActID, FundDetID, 24, 'Fund does not exist', TempPostDealActivity.Payments, ARDocsID, RefNum, DocType, DocDate
FROM #TempPostDealActivity TempPostDealActivity,
     Funds Funds
WHERE TempPostDealActivity.FundDetID NOT IN (SELECT OID FROM Funds)
  AND FundDetID is not null 
  AND FundDetID <> 0   

/*Set OID Value */
IF (SELECT Max(OID) from BatchErrors) is null
  BEGIN
    SET @OID = 0
  END
 ELSE
  BEGIN
    SELECT @OID = Max(OID) from BatchErrors
  END

SET @OID = @OID + 1

UPDATE #TempErrors SET OID = TempErrorsOID + @OID,
		      BatchStart = @BatchStart, 
		      BatchStep = 'Post Deal Activity'

INSERT INTO BatchErrors (OID, BatchMonitorID, BatchStart, BatchStep, DealActID, DealID,  
                                     FundDetID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate)
SELECT OID, @BatchOID, BatchStart, BatchStep, DealActID, DealID, 
       FundDetID, ErrorID, ErrorDetail, Amount, ARDocsID, RefNum, DocType, DocDate
FROM #TempErrors
ORDER BY DealID, DealActID

/***************************************************************
 * Set Accrual Amount for BillBack Deals
 ***************************************************************/
UPDATE #TempPostDealActivity SET Accrual = #TempPostDealActivity.Payments
FROM Deals Deals,
     DealTypes DealTypes,
     SysDealTypes SysDealTypes
WHERE #TempPostDealActivity.DealID = Deals.OID
  AND Deals.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND SysDealTypes.Name in ('BB', 'PctBB')
--  AND Deals.SysStatus = 'ACT'
  AND #TempPostDealActivity.DocType = 'IN'
  AND #TempPostDealActivity.Posted = 1

UPDATE #TempPostDealActivity SET Payments = 0
FROM Deals Deals,
     DealTypes DealTypes,
     SysDealTypes SysDealTypes
WHERE  #TempPostDealActivity.DealID = Deals.OID
  AND Deals.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND SysDealTypes.Name in ('BB', 'PctBB')
--  AND Deals.SysStatus = 'ACT'
  AND #TempPostDealActivity.DocType = 'IN'
  AND #TempPostDealActivity.Posted = 1

/**********************************************************************************
 * Post Deal Activity to DealProducts
 **********************************************************************************/
/**********************************************************************************
 * Activity records for Deals that have more than one product
 * and are not 'IN' activity records, spread the amount evenly
 * across the Products
 * Get Product Count
 * Divide Payments and Accruals by the Product Count
 * Update by DealID will match multiple times
 **********************************************************************************/
IF OBJECT_ID('tempdb..#DealCustProdCount') IS NOT NULL BEGIN
  DROP TABLE #DealCustProdCount
END

CREATE TABLE #DealCustProdCount
(DealID int Default 0,
 CustID int Default 0, 
 ProdID int Default 0,
 CustCount int default 0,
 ProdCount int default 0)

INSERT INTO #DealCustProdCount (DealID, CustID, CustCount)
SELECT DealID, CustID, 1 FROM DealCustomers

INSERT INTO #DealCustProdCount (DealID, ProdID, ProdCount)
SELECT DealID, ProdID, 1 FROM DealProducts

INSERT INTO #DealCustProdCount (DealID, CustCount, ProdCount)
SELECT DealID, SUM(CustCount), SUM(ProdCount)
FROM #DealCustProdCount
GROUP BY DealID

DELETE FROM #DealCustProdCount
WHERE (CustID + ProdID) <> 0


IF OBJECT_ID('tempdb..#TempPostDPActivity') IS NOT NULL BEGIN
  DROP TABLE #TempPostDPActivity
END

CREATE TABLE #TempPostDPActivity
 (
  DealID int,
  FundDetID int,
  ProdID int DEFAULT 0, 
  ActVol numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,
  Accrual numeric (18,2) DEFAULT 0,
  DealProdCount int DEFAULT 0
)

INSERT INTO #TempPostDPActivity (DealID, FundDetID, ProdID, ActVol, Payments, Accrual)
SELECT DealID, FundDetID, ProdID, SUM(TempPostDealActivity.ActVol), 
       SUM(TempPostDealActivity.Payments), SUM(TempPostDealActivity.Accrual)
FROM #TempPostDealActivity TempPostDealActivity,
     Deals Deals
WHERE Deals.OID = TempPostDealActivity.DealID
AND TempPostDealActivity.Posted = 1
GROUP BY DealID, FundDetID, ProdID

UPDATE #TempPostDPActivity SET DealProdCount = #DealCustProdCount.ProdCount
FROM #DealCustProdCount
WHERE #TempPostDPActivity.DealID = #DealCustProdCount.DealID
  AND #TempPostDPActivity.ProdID = 0 

UPDATE #TempPostDPActivity SET ActVol = ActVol/DealProdCount, Payments = Payments/DealProdCount, Accrual = Accrual/DealProdCount
WHERE  #TempPostDPActivity.ProdID = 0 

UPDATE DealProducts
SET ActVol = DealProducts.ActVol + TempPostDPActivity.ActVol,
    Payments = DealProducts.Payments + TempPostDPActivity.Payments,
    Accrual = DealProducts.Accrual + TempPostDPActivity.Accrual
FROM #TempPostDPActivity TempPostDPActivity
WHERE TempPostDPActivity.DealID = DealProducts.DealID
  AND TempPostDPActivity.ProdID = DealProducts.ProdID

/* Post where ProdID = 0 */
UPDATE DealProducts
SET ActVol = DealProducts.ActVol + TempPostDPActivity.ActVol,
    Payments = DealProducts.Payments + TempPostDPActivity.Payments,
    Accrual = DealProducts.Accrual + TempPostDPActivity.Accrual
FROM #TempPostDPActivity TempPostDPActivity
WHERE TempPostDPActivity.DealID = DealProducts.DealID
  AND TempPostDPActivity.ProdID = 0

/*********************************************************
 * Post Deal Activity to Deals and Funds
 *********************************************************/
IF OBJECT_ID('tempdb..#TempPostActivity') IS NOT NULL BEGIN
  DROP TABLE #TempPostActivity
END
CREATE TABLE #TempPostActivity
 (
  DealID int,
  FundDetID int,
  ActVol numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,
  Accrual numeric (18,2) DEFAULT 0
)

INSERT INTO #TempPostActivity (DealID, FundDetID, ActVol, Payments, Accrual)
SELECT DealID, FundDetID, SUM(TempPostDealActivity.ActVol), 
       SUM(TempPostDealActivity.Payments), SUM(TempPostDealActivity.Accrual)
FROM #TempPostDealActivity TempPostDealActivity,
     Deals Deals
WHERE Deals.OID = TempPostDealActivity.DealID
AND TempPostDealActivity.Posted = 1
GROUP BY DealID, FundDetID

UPDATE Deals
SET ActVol = Deals.ActVol + TempPostActivity.ActVol,
    Payments = Deals.Payments + TempPostActivity.Payments,
    Accrual = Deals.Accrual + TempPostActivity.Accrual
FROM #TempPostActivity TempPostActivity
WHERE TempPostActivity.DealID = Deals.OID

/*********************************************************
 * 7/30/04 Modified to calc extended 8.0 fields
 *********************************************************/


/*********************************************************
 * Update Promotions with actuals
 *********************************************************/
IF OBJECT_ID('tempdb..#TempDealSum') IS NOT NULL BEGIN
  DROP TABLE #TempDealSum
END

CREATE TABLE #TempDealSum
 (PromoID int,
  ActVol numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,
  Accrual numeric (18,2) DEFAULT 0)

INSERT INTO #TempDealSum (PromoID, ActVol, Payments, Accrual)
SELECT Deals.PromoID, 
SUM(Deals.ActVol),SUM(Deals.Payments),SUM(Deals.Accrual)
FROM Deals
GROUP BY PromoID

UPDATE Promotions
SET ActVol = #TempDealSum.ActVol,
    Payments = #TempDealSum.Payments,
    Accrual = #TempDealSum.Accrual
FROM #TempDealSum
WHERE #TempDealSum.PromoID = Promotions.OID

/*********************************************************
 * Calc Actual Margins
 *********************************************************/
IF OBJECT_ID('tempdb..#TempActPromo') IS NOT NULL BEGIN
  DROP TABLE #TempActPromo
END

create table  #TempActPromo
  (PromoID int, DealID int, DealTypeID int, SysDealTypeID int, SysDealTypeName varchar (20),
   SysDealTypeBasis varchar (10),   ProdID int, ListPrice numeric(18,6) DEFAULT 0, 
   DetailActVol numeric(18,6) DEFAULT 0, DetailAmount numeric(18,6) DEFAULT 0, DetailPctList numeric(18,6) DEFAULT 0, SlsComm numeric(18,6) DEFAULT 0,
   DetailExtension numeric(18,6) DEFAULT 0, ListPriceExtension numeric(18,6) DEFAULT 0, PromoListPriceExtension  numeric(18,6) DEFAULT 0, 
   PromoTotAmount  numeric(18,6) DEFAULT 0, PromoActVol numeric(18,6) DEFAULT 0,
   StdCost numeric(18,6) DEFAULT 0, 
   DealMargin numeric(18,6) DEFAULT 0,  
   PromoActMargin numeric(18,6) DEFAULT 0, PromoActMarginRate numeric(18,6) DEFAULT 0, PromoActMarginPercent numeric(18,6) DEFAULT 0 )

INSERT INTO  #TempActPromo
(PromoID, DealID, DealTypeID, SysDealTypeID, SysDealTypeName,
   SysDealTypeBasis, ProdID, ListPrice,  SlsComm,
   DetailActVol, DetailAmount, DetailPctList,
   PromoTotAmount, StdCost)
SELECT Promotions.OID, Deals.OID, Deals.DealTypeID, SysDealTypes.OID, SysDealTypes.Name, 
  SysDealTypes.DealBasis,
  DealProducts.ProdID, Products.RetailList, Products.SlsComm, DealProducts.ActVol, DealProducts.Amount,  
  DealProducts.PctList, Deals.TotAmount, Products.StdCost
FROM Promotions, Deals, DealProducts, Products, DealTypes, SysDealTypes
WHERE Promotions.OID = Deals.PromoID
  AND DealProducts.DealID = Deals.OID
  AND DealProducts.ProdID = Products.OID
  AND Deals.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID

/*** 8/11/04 Fix PCT calc ******/
UPDATE  #TempActPromo SET DetailExtension =
CASE
WHEN SysDealTypeBasis = 'RATE' THEN (DetailAmount * DetailActVol)
WHEN SysDealTypeBasis = 'PCT' THEN ((DetailPctList/100) * ListPrice * DetailActVol) 
WHEN SysDealTypeBasis = 'DOL' THEN DetailAmount END,
ListPriceExtension = DetailActVol * ListPrice

/*** 8/11/04 set margin by SysDealTypeBasis so DOL deals have negative margin   ****/
UPDATE  #TempActPromo SET DealMargin =
CASE
WHEN SysDealTypeBasis = 'RATE' THEN ((ListPrice * DetailActVol) - (StdCost * DetailActVol) - (SlsComm * DetailActVol) - DetailExtension) 
WHEN SysDealTypeBasis = 'PCT' THEN ((ListPrice * DetailActVol) - (StdCost * DetailActVol) - (SlsComm * DetailActVol) - DetailExtension) 
WHEN SysDealTypeBasis = 'DOL' THEN (0 - DetailExtension) END

IF OBJECT_ID('tempdb..#TempActPromoSum') IS NOT NULL BEGIN
  DROP TABLE #TempActPromoSum
END
  CREATE TABLE  #TempActPromoSum
  (PromoID int, PromoActVol numeric(18,6) DEFAULT 0,     ListPriceExtension numeric(18,6) DEFAULT 0, DetailExtension numeric (18,6) DEFAULT 0,
   PromoActMargin numeric(18,6) DEFAULT 0, PromoActMarginRate numeric(18,6) DEFAULT 0, PromoActMarginPercent numeric(18,6) DEFAULT 0 )

INSERT INTO #TempActPromoSum 
(PromoID, PromoActVol, ListPriceExtension, DetailExtension, PromoActMargin) 
SELECT PromoID, SUM(DetailActVol), SUM(ListPriceExtension), SUM(DetailExtension), SUM(DealMargin)
FROM #TempActPromo
GROUP BY PromoID
--select * from #TempActPromo   -- select * from Products where RetailList is null  -- Update Products set RetailList = 0 where RetailList is null
UPDATE #TempActPromo
SET PromoActMargin = #TempActPromoSum.PromoActMargin, 
    PromoActVol = #TempActPromoSum.PromoActVol,
    PromoListPriceExtension = #TempActPromoSum.ListPriceExtension,
    PromoTotAmount = #TempActPromoSum.DetailExtension
FROM #TempActPromoSum
WHERE #TempActPromoSum.PromoID = #TempActPromo.PromoID

UPDATE #TempActPromo SET 
PromoActMarginRate = 
CASE WHEN PromoActVol <> 0 THEN PromoActMargin/PromoActVol ELSE 0 END,
PromoActMarginPercent = 
CASE WHEN PromoListPriceExtension <> 0 THEN (PromoActMargin/ PromoListPriceExtension) * 100 ELSE 0 END


/**********************************************************************************************
 * Update Promotions with Promo Margin values, Plan Spend Rate CPIC, Base and Lift Volumes
 **********************************************************************************************/
UPDATE Promotions SET 
ActMgn = #TempActPromo.PromoActMargin,
ActMgnRate = #TempActPromo.PromoActMarginRate,
ActMgnPct = #TempActPromo.PromoActMarginPercent 
FROM #TempActPromo
WHERE Promotions.OID = #TempActPromo.PromoID

/**** 8/11/04 Calc ActSpendRate  ***/
UPDATE Deals SET 
ActSpendRate = CASE WHEN ActVol <> 0 THEN Payments/ActVol ELSE 0 END

UPDATE Promotions SET 
ActSpendRate = CASE WHEN ActVol <> 0 THEN Payments/ActVol ELSE 0 END

/******************** End new extended 8.0 field calcs **************************/

/*  Comment out Direct Post to Funds   6/4/03  */
/*UPDATE Funds
SET Amount = Funds.Amount + TempPostActivity.Payments
FROM #TempPostActivity TempPostActivity
WHERE TempPostActivity.FundDetID = Funds.OID*/


/*********************************************************
 * Update Deal Activity for Posted Records
 *********************************************************/

SET @StepEnd = GetDate()

UPDATE DealActivity 
SET Posted = 1, PostDate = @StepEnd
FROM #TempPostDealActivity TempPostDealActivity
WHERE TempPostDealActivity.DealActID = DealActivity.OID
  AND TempPostDealActivity.Posted = 1


/*********************************************************
 * Update BatchMonitor
 *********************************************************/
IF (SELECT COUNT(*) FROM #TempErrors) > 0
    BEGIN
	UPDATE BatchMonitor SET  Status = 'Errors', StepEnd = @StepEnd
	WHERE BatchMonitor.OID = @BatchOID
    END
  ELSE
    BEGIN
	UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
	WHERE BatchMonitor.OID = @BatchOID
    END
;
