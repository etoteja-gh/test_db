SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_DDtoDealActivity] AS

/* sp_TPMS_DDtoDealActivity.sql   7/21/04   
   B. Sullivan 7/24/03                          */

/* Modified  1/9/04  Set TM_OffsetDetail.Posted = 1 for items moved to APIDealActivity */
/* Modified  7/19/04 Eliminate fully qualified db names      */
/* Modified  7/19/04 Make Temp tables #Temp                  */
/* Modified  7/21/04 Modify Temp tables DROP methods         */
/* Modified  8/1/04  Make #TempDealActivity numeric fields default zero  */


/***********************************************************************
* Update Batch Monitor Table
* Load New items from TM_OffsetDetail table
* Load items from ARDocs that were not in TM_OffsetDetail
* Check Reclasses (Hain only)
* Load to APIDealActivity
* Update Batch Monitor Table
***********************************************************************/

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
VALUES (@BatchOID, @BatchStart, 'TPMS-Load DD to DealActivity', GetDate(), 'Running')


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
	Amount numeric(18, 2) DEFAULT (0),
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
  

/**************************************************************************************
 * Load Data from TM_OffsetDetail
 **************************************************************************************/
INSERT INTO #TempDealActivity 
       (DealID,
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
	FundID,
	Amount,
	OrigAmount,
	ReasonCode,
	ReasonID,
	SourceCreatedDate,
	CreatedDate
)
SELECT 
	TM_OffsetDetail.DealID,
	'DD',
	ARDocs.DocDate,
	ARDocs.RefNum,
	TM_OffsetDetail.LinkedID, 
	Orgs.Name, 
	Orgs.SourceID, 
	ARDocs.CustID,   -- Orgs.OID
	TM_OffsetDetail.CustID,          -- Customers.OID
	Products.Name,
	Products.SourceCode,
	TM_OffsetDetail.ProdID,
	TM_OffsetDetail.FundID,
	TM_OffsetDetail.Amount,
	ARDocs.OrigAmount,
	ReasonCodes.Name,
	ARDocs.ReasonID,
	ARDocs.CreatedDate,
	@BatchStart
FROM TM_OffsetDetail TM_OffsetDetail, 
     ARdocs ARDocs,
     ReasonCodes ReasonCodes,
     Orgs Orgs,
     Products Products
WHERE TM_OffsetDetail.Posted = 0
  AND TM_OffsetDetail.LinkedID = ARDocs.OID
  AND ARDocs.CustID = Orgs.OID
  AND ARDocs.ReasonID = ReasonCodes.OID
  AND TM_OffsetDetail.ProdID = Products.OID

/***********************************************************************
 * Set TM_OffsetDetail.Posted to 1 from all items loaded
 ***********************************************************************/
Update TM_OffsetDetail SET Posted = 1
FROM TM_OffsetDetail TM_OffsetDetail, 
     ARdocs ARDocs,
     ReasonCodes ReasonCodes,
     Orgs Orgs,
     Products Products
WHERE TM_OffsetDetail.Posted = 0
  AND TM_OffsetDetail.LinkedID = ARDocs.OID
  AND ARDocs.CustID = Orgs.OID
  AND ARDocs.ReasonID = ReasonCodes.OID
  AND TM_OffsetDetail.ProdID = Products.OID

/*******************************************************************************************
 * Load records from ARDocs that are not in TM_OffsetDetail
 * Where ReasonCode in a Trade ReasonCode Group
 *   and Closed = 1 and Rlsed = 1 and Reconciled = 1
 * The Reconciled check is not used as it is not implemented yet
 * Note: At this time there is no Product code in ARDocs
 *       There is a ProdID field in ARDocDetail
 ********************************************************************************************/
DECLARE @TradeReasonGroup VARCHAR (20)
SELECT @TradeReasonGroup = Value FROM Parameters WHERE Variable = 'TRADE_REASON_GROUP'

INSERT INTO #TempDealActivity 
       (DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	OrgsID,
	Amount,
	OrigAmount,
	ReasonCode,
	ReasonID,
	SourceCreatedDate,
	CreatedDate)
SELECT 
	'DD',
	ARDocs.DocDate,
	ARDocs.RefNum,
	ARDocs.OID, 
	Orgs.Name, 
	Orgs.SourceID, 
	ARDocs.CustID,                -- Orgs.OID
	ARDocs.Amount,
	ARDocs.OrigAmount,
	ReasonCodes.Name,
	ARDocs.ReasonID,
	ARDocs.CreatedDate,
	@BatchStart
FROM ARdocs ARDocs,
     ReasonCodes ReasonCodes,
     ReasonCodeGroups ReasonCodeGroups, 
     Orgs Orgs
WHERE ARDocs.Closed = 1
  AND ARDocs.Rlsed = 1
--  AND ARDocs.Reconciled = 1
  AND ARDocs.DocType = 'DD'
  AND ARDocs.CustID = Orgs.OID
  AND ARDocs.ReasonID = ReasonCodes.OID
  AND ReasonCodeGroups.Name = @TradeReasonGroup
  AND ReasonCodes.GroupID = ReasonCodeGroups.OID
  AND ARDocs.OID not in (SELECT LinkedID FROM TM_OffsetDetail)


/*******************************************************************************************
 * Check for Reclassed Trade reason codes
 * Create a reversing transaction if one is reclassed. 
 * Note: At this time, this will only work for items in TM_OffsetDetail
 * Note: DealActivity.EPIOrderNum is temporarily used to indicate that and
 *       item has been sourced from the Reclass table.
 ********************************************************************************************/
/** Following code used at Hain  **/
/*********************************************************************
INSERT INTO #TempDealActivity 
       (DocType,
	DocDate,
	RefNum,
	ARDocsID, 
	CustomerName,
	CustSourceCode,
	DealID,
	Amount,
	OrigAmount,
	ReasonID,
	CreatedDate)
SELECT 'DD', Reclasses.CreatedDate, Reclasses.Reference, Reclasses.ARDocsID,
       Reclasses.Name, Reclasses.CustSourceID,  
       TM_OffsetDetail.DealID, ITVAmount * -1, ITVOrigAmount,
       Reclasses.OrigReasonID, @BatchStart
FROM ITV_LOAD.dbo.JDEReclassesHistory Reclasses,
     TM_OffsetDetail OffSetDetail,
     DealActivity DealActivity
WHERE Reclasses.ARDocsID = TM_OffsetDetail.LinkedID
  AND DealActivity.ARDocsID = Reclasses.ARDocsID
  AND DealActivity.EPIOrderNum <> 'Reclass'
  AND DealActivity.ReasonID <> DealActivity.ReasonID

******************************************************************************/

/************************************************************************************ 
 * Load Data to APIDealActivity table
 ************************************************************************************/
SET @StepEnd = GetDate()

INSERT INTO APIDealActivity
(	DealID,	
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
	BatchNum)
SELECT 
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
	BatchNum
 FROM #TempDealActivity 
WHERE Errored IS NULL


/*********************************************************
 * Update BatchMonitor
 *********************************************************/
	UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
	WHERE BatchMonitor.OID = @BatchOID

;
SET QUOTED_IDENTIFIER OFF 
;
SET ANSI_NULLS ON 
;

