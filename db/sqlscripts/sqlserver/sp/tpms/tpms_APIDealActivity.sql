CREATE PROCEDURE [dbo].[tpms_APIDealActivity] AS

/******************************************************
 * sp_TPMS_APIDealActivity
 * TPMS Batch Step 4  - ITV  7/21/04
 * B. Sullivan
 * Move Data from APIDealActivity to DealActivity
 ******************************************************/

/* Modified   6/3/03 Change how Loaded set                                 */
/* Modified   6/3/03 @StepEnd                                              */
/* Modified   7/1/03 Comments                                              */
/* Modified  7/24/03 Set ReasonID                                          */
/* Modified  7/28/03 Fix ObjectID.Next setting                             */
/* Modified  7/19/04 Eliminate fully qualified db reference                */  
/* Modified  7/19/04 Temp tables to #Temp                                  */  
/* Modified  7/19/04 Fix Temp tables DROP method                           */               
/* Modified   8/1/04 Make numeric fields in #TempDealActivity Default zero */               
          
/******************************************************
 * Update Batch Monitor Table
 * Delete APIDealActivity records that have been loaded previously
 * Find Activity Records that do not have required data and mark as errored
 * Find Activity Records that do not have DealCodes matching Deals and mark as errored
 * Write Errored records to APIDealActivityErrors
 * Load Data to DealActivity table
 * Update APIDealActivity records to record loading
 * Update Batch Monitor Table
 ******************************************************/

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
VALUES (@BatchOID, @BatchStart, 'Load DealActivity table', GetDate(), 'Running')
 

/*******************************************************************
 * Delete APIDealActivity records that have been loaded previously
 *******************************************************************/
 
DELETE FROM APIDealActivity
WHERE LOADED = 1


/****************************************************************************
 * Find Activity Records that do not have required data and mark as errored
 ****************************************************************************/

IF OBJECT_ID('tempdb..#TempDealActivity') IS NOT NULL BEGIN
  DROP TABLE #TempDealActivity
END

CREATE TABLE #TempDealActivity
 (
	TDAOID int IDENTITY, 	
	OID int DEFAULT 0,
	Version int ,
	EventCode char (10),
	EventID int, 
	DealCode char (10),
	DealID int  ,
	DocType varchar (2),
	DocDate smalldatetime,
	RefNum varchar (25),
	ARDocsID int, 
	CustomerName varchar (50),
	CustSourceCode varchar (50),
	OrgsID int,
	CustID int,
	ProductName varchar (50),
	ProdSourceCode varchar (50),
	ProdID int,
	Fund varchar (30),
	FundYear varchar (4),
	FundPeriod varchar (3),
	FundID int,
	Amount numeric(18, 2)DEFAULT (0),
	Volume numeric(18, 2) DEFAULT (0),
	UnitMsr varchar (10),
	NumInvLineItems int DEFAULT (0),
	OrigAmount numeric(18, 0) DEFAULT (0),
	ReasonCode varchar (20),
	ReasonID int,
	OrderNum varchar (25),
	EPIOrderNum varchar (25),
	BatchNum varchar (25),
	SourceCreatedDate smalldatetime,
	SourceCreatedBatchCount int,
	LoadedDate smalldatetime,
	Posted bit,
	PostDate smalldatetime,
	CreatedBy int,
	CreatedDate smalldatetime,
	EditedBy int,
	EditedDate int,
	Errored bit
)  
  

INSERT INTO #TempDealActivity 
       (EventCode,
	EventID, 
	DealCode,
	DealID,
	DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	OrgsID,
	CustID,
	ProductName,
	ProdSourceCode,
	ProdID,
	Fund,
	FundYear,
	FundPeriod,
	FundID,
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	ReasonCode,
	ReasonID,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	SourceCreatedDate,
	SourceCreatedBatchCount,
	LoadedDate,
	CreatedDate
)
SELECT 
	EventCode,
	EventID, 
	DealCode,
	DealID,
	DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	OrgsID,
	CustID,
	ProductName,
	ProdSourceCode,
	ProdID,
	Fund,
	FundYear,
	FundPeriod,
	FundID,
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	ReasonCode,
	ReasonID,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	SourceCreatedDate,
	SourceCreatedBatchCount,
	LoadedDate,
	CreatedDate
FROM APIDealActivity
WHERE Loaded = 0

UPDATE #TempDealActivity
SET Errored = 1
WHERE DealID = 0 
   OR DealID IS NULL
   OR DocDate IS NULL
   OR RefNum IS NULL
   OR Amount = 0 or Amount IS NULL

/**************************************************************************************
 * Find or set EventID
 **************************************************************************************/
UPDATE #TempDealActivity
SET EventID = Convert(int,EventCode)
WHERE (EventID = 0 or EventID is null)
  AND EventCode is not null

/**************************************************************************************
 * Find or set DealCode
 **************************************************************************************/
UPDATE #TempDealActivity
SET DealID = Convert(int,DealCode)
WHERE (DealID = 0 or DealID is null)
  AND DealCode is not null

/**************************************************************************************
 * Find Activity Records that do not have DealCodes matching Deals and mark as errored
 **************************************************************************************/
UPDATE #TempDealActivity
SET Errored = 1
WHERE DealID NOT IN (SELECT OID FROM Deals)

/************************************************************************************
 * Find TPMS Orgs OID (where CustSourceCode = Orgs.SourceID
 ************************************************************************************/
UPDATE #TempDealActivity
SET OrgsID = Orgs.OID
FROM Orgs Orgs
WHERE #TempDealActivity.CustSourceCode = Orgs.SourceID
  AND (#TempDealActivity.OrgsID = 0 OR #TempDealActivity.OrgsID is null)

/************************************************************************************
 * Find TPMS Customer OID (where CustSourceCode = Orgs.SourceID
 ************************************************************************************/
UPDATE #TempDealActivity
SET CustID = Customers.OID
FROM Customers Customers, Orgs Orgs
WHERE #TempDealActivity.CustSourceCode = Orgs.SourceID
  AND Orgs.OID = Customers.OrgsID
  AND (#TempDealActivity.CustID = 0 OR #TempDealActivity.CustID is null)

/************************************************************************************
 * Find TPMS Product OID (where ProdSourceCode = Products.SourceCode
 ************************************************************************************/
UPDATE #TempDealActivity
SET ProdID = Products.OID
FROM Products Products
WHERE #TempDealActivity.ProdSourceCode = Products.SourceCode
  AND (#TempDealActivity.ProdID = 0 OR #TempDealActivity.ProdID is null)


/************************************************************************************
 * Find TPMS Fund OID 
 ************************************************************************************/
UPDATE #TempDealActivity
SET FundID = FundMaster.OID
FROM FundMaster FundMaster
WHERE #TempDealActivity.Fund = FundMaster.Name
  AND #TempDealActivity.FundYear = FundMaster.FundYear
  AND #TempDealActivity.FundPeriod = FundMaster.FundPeriod
  AND (#TempDealActivity.FundID = 0 OR #TempDealActivity.FundID is null)

/************************************************************************************
 * Set ReasonID 
 ************************************************************************************/
Update #TempDealActivity Set ReasonID = DealTypes.ReasonID
from Deals Deals, DealTypes DealTypes
where  Deals.DealTypeID = DealTypes.OID
  and #TempDealActivity.DealID = Deals.OID

/************************************************************************************ 
 * Write Errored records to APIDealActivityErrors
 ************************************************************************************/
INSERT INTO APIDealActivityErrors
       (EventCode ,
	EventID, 
	DealCode,
	DealID,
	DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	OrgsID,
	CustID,
	ProductName,
	ProdSourceCode,
	ProdID,
	Fund,
	FundYear,
	FundPeriod,
	FundID,
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	ReasonCode,
	ReasonID,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	SourceCreatedDate,
	SourceCreatedBatchCount,
	LoadedDate,
	CreatedDate)
SELECT 
	EventCode ,
	EventID, 
	DealCode,
	DealID,
	DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	OrgsID,
	CustID,
	ProductName,
	ProdSourceCode,
	ProdID,
	Fund,
	FundYear,
	FundPeriod,
	FundID,
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	ReasonCode,
	ReasonID,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	SourceCreatedDate,
	SourceCreatedBatchCount,
	LoadedDate,
	CreatedDate
 FROM #TempDealActivity WHERE Errored = 1

DELETE FROM #TempDealActivity WHERE Errored = 1

/************************************************************************************ 
 * Set OID values in TempDealActivity
 ************************************************************************************/

IF (SELECT Max(Next) from ObjectID) IS NULL
  BEGIN
   SET @OID = 1
  END
 ELSE
  BEGIN
   SELECT @OID = Max(Next) from ObjectID 
  END
 
SET @OID = @OID + 1
UPDATE #TempDealActivity SET OID = TDAOID + @OID

/************************************************************************************ 
 * Load Data to DealActivity table
 ************************************************************************************/
SET @StepEnd = GetDate()

INSERT INTO DealActivity
(	OID,
	DealID,	
	DocType,
	DocDate,
	RefNum,
	ReasonCode,
	ReasonID,
	CustID,	
	ProdID,
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	CreatedBy,
	CreatedDate)
SELECT 
	OID,
	DealID,	
	DocType,
	DocDate,
	RefNum,
	ReasonCode,
	ReasonID,
	CustID,	
	ProdID, 
	Amount,
	Volume,
	UnitMsr,
	NumInvLineItems,
	OrigAmount,
	OrderNum,
	EPIOrderNum,
	BatchNum,
	1,
	@StepEnd
 FROM #TempDealActivity WHERE Errored IS NULL


/****************************************************
 * Update APIDealActivity records to record loading
 ****************************************************/

UPDATE APIDealActivity set Loaded = 1, LoadedDate = @StepEnd
WHERE Loaded = 0 
  AND DealID IN (SELECT OID FROM Deals)
  AND DocDate IS NOT NULL
  AND RefNUm IS NOT NULL
  AND (Amount <> 0 OR Amount IS NOT NULL)


/*********************************************************
 * Update ObjectID
 *********************************************************/
SELECT @OID = MAX(OID) FROM DealActivity
SET @OID = @OID + 1
UPDATE OBJECTID SET Next = @OID
WHERE Next < @OID

/*********************************************************
 * Update BatchMonitor
 *********************************************************/
	UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
	WHERE BatchMonitor.OID = @BatchOID

;
