SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_UpdateDeals] AS

/*********************************
 * sp_TPMS_UpdateDeals.sql
 * Update Deals and Funds 7/16/03
 *********************************/

/* 7/15/03  Force TotAmount values on AD Deals                   */
/* 7/21/04  Load as production SP                                */
/* 7/21/04  Make Temp tables #Temp                               */
/* 7/21/04  Elim fully qualified db names                        */
/* 7/21/04  Fix #Temp table drop method                          */
/* 7/21/04  Fix Null values in aggregate                         */


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
VALUES (@BatchOID, @BatchStart, 'Update Deals & Funds', GetDate(), 'Running')
 
/******************************************
 * Force TotAmount values on AD Deals
 ******************************************/
UPDATE Deals SET TotAmount = Amount 
WHERE DealTypeID = 3 
  and SysStatus not in  ('DE','INV','EDIT')

/*************************************************
 * Force zero values on numeric fields with nulls
 *************************************************/
--Products
UPDATE Products SET SlsComm = 0 WHERE SlsComm IS NULL
UPDATE Products SET StdCost = 0 WHERE StdCost IS NULL
UPDATE Products SET RetailList = 0 WHERE RetailList IS NULL


--Promotions
UPDATE Promotions SET StdEventID = 0 WHERE StdEventID IS NULL
UPDATE Promotions SET PlanVol = 0 WHERE PlanVol IS NULL
UPDATE Promotions SET ActVol = 0 WHERE ActVol IS NULL
UPDATE Promotions SET TotAmount = 0 WHERE TotAmount IS NULL
UPDATE Promotions SET Payments = 0 WHERE Payments IS NULL
UPDATE Promotions SET Accrual = 0 WHERE Accrual IS NULL
UPDATE Promotions SET BaseVol = 0 WHERE BaseVol IS NULL
UPDATE Promotions SET LiftVol = 0 WHERE LiftVol IS NULL
UPDATE Promotions SET CPIC = 0 WHERE CPIC IS NULL
UPDATE Promotions SET PlanSpendRate = 0 WHERE PlanSpendRate IS NULL
UPDATE Promotions SET ActSpendRate = 0 WHERE ActSpendRate IS NULL
UPDATE Promotions SET PlanMgn = 0 WHERE PlanMgn IS NULL
UPDATE Promotions SET PlanMgnRate = 0 WHERE PlanMgnRate IS NULL
UPDATE Promotions SET PlanMgnPct = 0 WHERE PlanMgnPct IS NULL
UPDATE Promotions SET ActMgn = 0 WHERE ActMgn IS NULL
UPDATE Promotions SET ActMgnRate = 0 WHERE ActMgnRate IS NULL
UPDATE Promotions SET ActMgnPct = 0 WHERE ActMgnPct IS NULL

--Deals
UPDATE Deals SET PlanVol = 0 WHERE PlanVol IS NULL
UPDATE Deals SET ActVol = 0 WHERE ActVol IS NULL
UPDATE Deals SET TotAmount = 0 WHERE TotAmount IS NULL
UPDATE Deals SET Payments = 0 WHERE Payments IS NULL
UPDATE Deals SET Accrual = 0 WHERE Accrual IS NULL
UPDATE Deals SET BaseVol = 0 WHERE BaseVol IS NULL
UPDATE Deals SET LiftVol = 0 WHERE LiftVol IS NULL
UPDATE Deals SET CPIC = 0 WHERE CPIC IS NULL
UPDATE Deals SET PlanSpendRate = 0 WHERE PlanSpendRate IS NULL
UPDATE Deals SET ActSpendRate = 0 WHERE ActSpendRate IS NULL
UPDATE Deals SET OrderLimit = 0 WHERE OrderLimit IS NULL
UPDATE Deals SET OrderMin = 0 WHERE OrderMin IS NULL
UPDATE Deals SET PricePoint = 0 WHERE PricePoint IS NULL
UPDATE Deals SET ScanPct = 0 WHERE ScanPct IS NULL
UPDATE Deals SET ScanCases = 0 WHERE ScanCases IS NULL
UPDATE Deals SET ScanRate = 0 WHERE ScanRate IS NULL
UPDATE Deals SET FrghtAllow = 0 WHERE FrghtAllow IS NULL
UPDATE Deals SET Stores = 0 WHERE Stores IS NULL
UPDATE Deals SET CompPxPt = 0 WHERE CompPxPt IS NULL
UPDATE Deals SET Competitors = 0 WHERE Competitors IS NULL
UPDATE Deals SET WarnLeadDays = 0 WHERE WarnLeadDays IS NULL



--DealProducts
UPDATE DealProducts SET EquivCases =0 WHERE EquivCases IS NULL
UPDATE DealProducts SET ActVol =0 WHERE ActVol IS NULL
UPDATE DealProducts SET Amount =0 WHERE Amount IS NULL
UPDATE DealProducts SET EstBuyout =0 WHERE EstBuyout IS NULL
UPDATE DealProducts SET ListPrice =0 WHERE ListPrice IS NULL
UPDATE DealProducts SET OrderMax =0 WHERE OrderMax IS NULL
UPDATE DealProducts SET OrderMin =0 WHERE OrderMin IS NULL
UPDATE DealProducts SET Payments =0 WHERE Payments IS NULL
UPDATE DealProducts SET PctList =0 WHERE PctList IS NULL
UPDATE DealProducts SET PlanVol =0 WHERE PlanVol IS NULL
UPDATE DealProducts SET PricePoint =0 WHERE PricePoint IS NULL
UPDATE DealProducts SET ScanPct =0 WHERE ScanPct IS NULL
UPDATE DealProducts SET TotAmount =0 WHERE TotAmount IS NULL

/******************************************
 * Change Deal System Status Values
 ******************************************/

UPDATE Deals SET SysStatus = 'ACT'
WHERE DealBegDate <= GetDate()
  AND DealEndDate > GetDate()
  AND SysStatus NOT IN ('INV','CL','CA','DE','EDIT')
  AND ApprovalStatus NOT IN ('NotApproved','Disapproved','NA-Warning')

UPDATE Deals SET SysStatus = 'CL'
WHERE DealEndDate < GetDate()
  AND SysStatus NOT IN ('INV','CA','DE','EDIT')

/* SettleStatus = 'PAID' ? Reverse Accrual and post actual? */


IF OBJECT_ID('tempdb..#PostFunds') IS NOT NULL BEGIN
  DROP TABLE #PostFunds
END

CREATE TABLE #PostFunds
 (
  DealID int DEFAULT 0,
  CustID int DEFAULT 0,
  ProdID int DEFAULT 0,
  FundID int DEFAULT 0,
  FundCustID int DEFAULT 0,
  FundProdID int DEFAULT 0,
  FundDetID int DEFAULT 0,
  FundDataTypeID int DEFAULT 0,
  Period varchar (3),
  ActAccrFlag int DEFAULT 0,
  FundAmount numeric (18,2) DEFAULT 0,
  TotAmount numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,  
  Accrual numeric (18,2) DEFAULT 0,
  DealCustCount int,
  SysDealTypeID int DEFAULT 0,
  SysStatus varchar (4),
  ApprovalStatus varchar (20),
  SettleStatus varchar (4)
)

IF OBJECT_ID('tempdb..#PostFundsDealSum') IS NOT NULL BEGIN
  DROP TABLE #PostFundsDealSum
END

CREATE TABLE #PostFundsDealSum
 (
  DealID int DEFAULT 0,
  ActAccrFlag int DEFAULT 0,
  TotAmount numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,  
  Accrual numeric (18,2) DEFAULT 0,
  SysDealTypeID int DEFAULT 0,
  SysStatus varchar (4),
  ApprovalStatus varchar (20),
  SettleStatus varchar (4) DEFAULT 'Open'
)


/*********************************************************************
 * TotAmounts are Planned Spend
 * Payments are actuals
 * Accruals are treated as actuals
 *********************************************************************/
/***************************************************************
 * Select records for posting to Funds
 ***************************************************************/
TRUNCATE TABLE #PostFunds

INSERT INTO #PostFunds
(DealID, SysDealTypeID, CustID, ProdID, FundID, 
 TotAmount, Payments, Accrual, SysStatus, ApprovalStatus)
SELECT Deals.OID, DealTypes.SysDealTypeID, DealCustomers.CustID, DealProducts.ProdID, DealFunds.FundID, 
       DealProducts.TotAmount, DealProducts.Payments, DealProducts.Accrual,
       Deals.SysStatus, Deals.ApprovalStatus
FROM Deals Deals,
     DealCustomers DealCustomers,
     DealProducts DealProducts,
     DealFunds DealFunds,
     DealTypes DealTypes
WHERE Deals.OID = DealProducts.DealID
  AND Deals.OID = DealCustomers.DealID
  AND Deals.OID = DealFunds.DealID
  AND Deals.SysStatus NOT IN ('INV','DE','CA','EDIT')
  AND Deals.DealTypeID = DealTypes.OID
ORDER BY CustID

/********************************************************************************
 * Modified 7/21/04 SettleStatus is often null, it is creating warnings
 *                  Set to OPEN as default
 ********************************************************************************/
UPDATE #PostFunds SET SettleStatus = 'OPEN' WHERE SettleStatus is null

/*******************************************************************************
 * Get DealCustomer Count and update PostFunds to adjust for multiple customers
 *******************************************************************************/
IF OBJECT_ID('tempdb..#DealCustProdCount') IS NOT NULL BEGIN
  DROP TABLE #DealCustProdCount
END
CREATE TABLE #DealCustProdCount (
	DealID int DEFAULT (0) ,
	CustID int DEFAULT (0),
	ProdID int DEFAULT (0) ,
	CustCount int DEFAULT (0),
	ProdCount int DEFAULT (0) )
 
TRUNCATE TABLE #DealCustProdCount

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

UPDATE #PostFunds SET DealCustCount = DealCustProdCount.CustCount
FROM #DealCustProdCount DealCustProdCount
WHERE #PostFunds.DealID = DealCustProdCount.DealID


/*********************************************************************
 * Adjust amounts to reflect multiple customers
 *********************************************************************/

UPDATE #PostFunds 
SET TotAmount = TotAmount/DealCustCount,
    Payments = Payments/DealCustCount,
    Accrual = Accrual/DealCustCount
Where #PostFunds.DealCustCount <> 0

/*********************************************************************
 * Find FundCustID and FundProdID
 * FundDataTypeIDs
 *  1 - PLN
 *  4 - PGL
 *  5 - EGL
 *  6 - REBATE
 *  7 - ACT
 *  8 - PND
 *  9 - APP
 * 12 - ADJ
 * 16 - PLNSPND
 *********************************************************************/

UPDATE #PostFunds SET FundCustID = Funds.CustID, FundProdID = Funds.ProdID
FROM Funds Funds
WHERE
EXISTS (SELECT CustTreeStruct.AncestorID
        FROM CustTreeStruct CustTreeStruct
	WHERE CustTreeStruct.CustID = #PostFunds.CustID
          AND CustTreeStruct.AncestorID = Funds.CustID)
AND
EXISTS (SELECT ProdTreeStruct.AncestorID
        FROM ProdTreeStruct ProdTreeStruct
	WHERE ProdTreeStruct.ProdID = #PostFunds.ProdID
          AND ProdTreeStruct.AncestorID = Funds.ProdID)
AND #PostFunds.FundID = Funds.FundID
AND Funds.FundDataTypeID IN (1,4,5,6,12)

/*********************************************************************
 * Find FundDetID and set Period 
 * Note: Period set by any match to a record in the fund
 *********************************************************************/
UPDATE #PostFunds SET FundDetID = Funds.OID, Period = Funds.Period
FROM Funds Funds
WHERE #PostFunds.FundID = Funds.FundID
  AND #PostFunds.FundCustID = Funds.CustID
  AND #PostFunds.FundProdID = Funds.ProdID
  AND Funds.FundDataTypeID IN (1,4,5,6,12) 

/*********************************************************************
 * Sum into PostFundsSummary -- This will indicate which deals have 
 * Actual/Accruals that are greater than TotAmount.
 *********************************************************************/
TRUNCATE TABLE #PostFundsDealSum 

INSERT INTO #PostFundsDealSum 
 (DealID,
  TotAmount,
  Payments,  
  Accrual,
  SysDealTypeID,
  SysStatus,
  ApprovalStatus,
  SettleStatus)
SELECT DealID, Sum(TotAmount), Sum(Payments), Sum(Accrual), Max(SysDealTypeID), Max(SysStatus), Max(ApprovalStatus), Max(SettleStatus)
FROM #PostFunds
Group by DealID

/*********************************************************************
 * Calculate ActAccrFlag for Actuals/Accruals
 * 0 - TotAmount 
 * 1 - Payments
 * 2 - Accrual
 *********************************************************************/
UPDATE #PostFundsDealSum 
SET ActAccrFlag =
  CASE
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus = 'CL' THEN 1
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus NOT IN ('CL') AND Payments >= TotAmount THEN 1
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus NOT IN ('CL') AND Payments < TotAmount THEN 0
	WHEN SysDealTypeID in (2,8) AND Payments >= TotAmount AND Payments >= Accrual THEN 1
	WHEN SysDealTypeID in (2,8) AND Payments >= TotAmount AND Payments < Accrual THEN 2
	WHEN SysDealTypeID in (2,8) AND Accrual >= TotAmount THEN 2
	WHEN SysDealTypeID in (2,8) AND SettleStatus = 'PAID' THEN 1
	WHEN SysDealTypeID in (2,8) AND SettleStatus <> 'PAID' AND Payments < TotAmount AND Accrual < TotAmount THEN 0
	WHEN SysDealTypeID = 3 AND SysStatus = 'CL' THEN 1
	WHEN SysDealTypeID = 3 AND SysStatus NOT IN ('CL') AND Payments >= TotAmount THEN 1
	WHEN SysDealTypeID = 3 AND SettleStatus = 'PAID' THEN 1
	WHEN SysDealTypeID = 3 AND SettleStatus <> 'PAID' AND Payments < TotAmount THEN 0
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND Payments >= TotAmount THEN 1
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND SettleStatus = 'PAID' THEN 1
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND SettleStatus <> 'PAID' AND Payments < TotAmount THEN 0
	END
/*FROM DealTypes DealTypes,
     SysDealTypes SysDealTypes
WHERE #PostFundsDealSum.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID*/

/*********************************************************************
 * Update PostFunds for ActAccrFlag
 *********************************************************************/
UPDATE #PostFunds SET ActAccrFlag = #PostFundsDealSum.ActAccrFlag
FROM #PostFundsDealSum
WHERE #PostFunds.DealID = #PostFundsDealSum.DealID

/*********************************************************************
 * Set FundAmount for PostFunds 
 *********************************************************************/
UPDATE #PostFunds SET FundAmount = 
  CASE
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus = 'CL' THEN Payments
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus NOT IN ('CL') AND Payments >= TotAmount THEN Payments
	WHEN SysDealTypeID in (1,5,6,7) AND SysStatus NOT IN ('CL') AND Payments < TotAmount THEN TotAmount
	WHEN SysDealTypeID in (2,8) AND Payments >= TotAmount AND Payments >= Accrual THEN Payments
	WHEN SysDealTypeID in (2,8) AND Payments >= TotAmount AND Payments < Accrual THEN Accrual
	WHEN SysDealTypeID in (2,8) AND Accrual >= TotAmount THEN Accrual
	WHEN SysDealTypeID in (2,8) AND SettleStatus = 'PAID' THEN Payments
	WHEN SysDealTypeID in (2,8) AND SettleStatus <> 'PAID' AND Payments < TotAmount AND Accrual < TotAmount THEN TotAmount
	WHEN SysDealTypeID = 3 AND SysStatus = 'CL' THEN Payments
	WHEN SysDealTypeID = 3 AND SysStatus NOT IN ('CL') AND Payments >= TotAmount THEN Payments
	WHEN SysDealTypeID = 3 AND SettleStatus = 'PAID' THEN Payments
	WHEN SysDealTypeID = 3 AND SettleStatus <> 'PAID' AND Payments < TotAmount THEN TotAmount
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND Payments >= TotAmount THEN Payments
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND SettleStatus = 'PAID' THEN Payments
	WHEN SysDealTypeID in (4,9,10,11,12,13) AND SettleStatus <> 'PAID' AND Payments < TotAmount THEN TotAmount
	END

/*FROM DealTypes DealTypes,
     SysDealTypes SysDealTypes
WHERE #PostFunds.DealTypeID = DealTypes.OID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID*/

/*********************************************************************
 * Prepare insert table
 *********************************************************************/

IF exists (SELECT table_name FROM information_schema.tables WHERE table_name = '#InsertFunds')
  BEGIN
   DROP TABLE #InsertFunds
  END

CREATE TABLE #InsertFunds
 (
  FundOID int IDENTITY, 
  OID int DEFAULT 0,
  FundID int DEFAULT 0,
  CustID int DEFAULT 0,
  ProdID int DEFAULT 0,
  FundDataTypeID int DEFAULT 0,
  Period varchar (3),
  Amount numeric (18,2) DEFAULT 0
)

/*************************************/

TRUNCATE TABLE #InsertFunds

/*********************************************************************
 * Load Actuals
 *********************************************************************/
INSERT INTO #InsertFunds
(FundID, CustID, ProdID, FundDataTypeID, Period, Amount)
SELECT FundID, FundCustID, FundProdID, 7, Period, 
  SUM(FundAmount) as Amount
FROM #PostFunds
WHERE ActAccrFlag IN (1,2)
  AND FundCustID <> 0 and FundProdID <> 0 and Period IS NOT NULL
GROUP BY FundID, FundCustID, FundProdID, FundDataTypeID, Period
 
/*********************************************************************
 * Load Pending
 *********************************************************************/
INSERT INTO #InsertFunds
(FundID, CustID, ProdID, FundDataTypeID, Period, Amount)
SELECT FundID, FundCustID, FundProdID, 8, Period, 
  Sum(TotAmount) as Amount
FROM #PostFunds
WHERE ActAccrFlag = 0
  AND ApprovalStatus IN ('NotApproved','Disapproved','NA-Warning')
  AND FundCustID <> 0 and FundProdID <> 0 and Period IS NOT NULL
GROUP BY FundID, FundCustID, FundProdID, FundDataTypeID, Period

/*********************************************************************
 * Load Approved
 *********************************************************************/
INSERT INTO #InsertFunds
(FundID, CustID, ProdID, FundDataTypeID, Period, Amount)
SELECT FundID, FundCustID, FundProdID, 9, Period, 
  Sum(TotAmount) as Amount
FROM #PostFunds
WHERE ActAccrFlag = 0
  AND ApprovalStatus = 'Approved'
  AND FundCustID <> 0 and FundProdID <> 0 and Period IS NOT NULL
GROUP BY FundID, FundCustID, FundProdID, FundDataTypeID, Period

/*********************************************************************
 * Load Planned Spend
 *********************************************************************/
INSERT INTO #InsertFunds
(FundID, CustID, ProdID, FundDataTypeID, Period, Amount)
SELECT FundID, FundCustID, FundProdID, 16, Period, 
  Sum(TotAmount) as Amount
FROM #PostFunds
GROUP BY FundID, FundCustID, FundProdID, FundDataTypeID, Period

/*********************************************************************
 * Set OID Values for new records
 *********************************************************************/
/*Set OID Value */
IF (SELECT Max(Next) FROM ObjectID) IS NULL
   BEGIN
     SET @OID = 0
   END
 ELSE
  BEGIN
    SELECT @OID = Max(Next) FROM ObjectID
  END

UPDATE #InsertFunds SET OID = FundOID + @OID

/**************************************
 * Reset ObjectID.Next
 **************************************/
SELECT @OID = Count(*) FROM #InsertFunds

IF @OID is not null
  BEGIN
    UPDATE ObjectID SET Next = Next + @OID
  END

/*********************************************************************
 * Delete Funds table records that will be replaced
 * All Actuals, Pending and Approved records will be replaced
 *********************************************************************/
DELETE FROM Funds
WHERE Funds.FundDataTypeID IN (7,8,9,16)

/*********************************************************************
 * Load InsertFunds into Funds table
 *********************************************************************/
INSERT INTO Funds
(OID, FundID, CustID, ProdID, FundDataTypeID, Period, Amount, CreatedBy, CreatedDate, EditedBy, EditedDate)
SELECT OID, FundID, CustID, ProdID, FundDataTypeID, Period, Amount, 355, @BatchStart, 355, @BatchStart
FROM #InsertFunds
WHERE Amount <> 0


/*********************************************************
 * Update BatchMonitor
 *********************************************************/
SET @StepEnd = GetDate()

UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
WHERE BatchMonitor.OID = @BatchOID


/*IF OBJECT_ID('tempdb..#PostFunds') IS NOT NULL BEGIN
  DROP TABLE #PostFunds
END*/



/*IF exists (SELECT table_name FROM information_schema.tables WHERE table_name = 'PostFundsSummary')
   DROP TABLE #PostFundsSummary

CREATE TABLE #PostFundsSummary
 (
  FundID int DEFAULT 0,
  FundCustID int DEFAULT 0,
  FundProdID int DEFAULT 0,
  FundDetID int DEFAULT 0,
  FundDataTypeID int DEFAULT 0,
  Period varchar (3),
  ActAccrFlag int DEFAULT 0,
  FundAmount numeric (18,2) DEFAULT 0,
  TotAmount numeric (18,2) DEFAULT 0,
  Payments numeric (18,2) DEFAULT 0,  
  Accrual numeric (18,2) DEFAULT 0
)*/

/*********************************************************************
 * Sum records for posting
 *********************************************************************/
/*
TRUNCATE TABLE #PostFundsSummary

INSERT INTO #PostFundsSummary
(FundID, FundCustID, FundProdID, Period, FundAmount, TotAmount, Payments, Accrual)
SELECT FundID, FundCustID, FundProdID, Period, 
      (CASE ActAccrFlag WHEN 0 THEN SUM(TotAmount)
                        WHEN 1 THEN SUM(Payments)
                        WHEN 2 THEN SUM(Accrual) END) AS FundAmount,
     SUM(TotAmount), SUM(Payments), SUM(Accrual)
FROM #PostFunds
GROUP BY FundID, FundCustID, FundProdID, Period, ActAccrFlag
*/

;
SET QUOTED_IDENTIFIER OFF 
;
SET ANSI_NULLS ON 
;

