SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_DealActivityFacts] AS

/*********************************
 * sp_TPMS_DealActivityFacts   
 * Load DealActivityFacts table
 * B. Sullivan   7/21/04
 *********************************/

/* Modified  7/21/04 Initial load as SP                         */


/******************************************
 * UPDATE Batch Monitor Table
 ******************************************/
/* Set OID values for Batch Monitor  */
DECLARE @BatchOID int
DECLARE @OID int
DECLARE @BatchStart smalldatetime
DECLARE @StepEnd smalldatetime

/*Set OID Value */
IF (SELECT Max(OID) FROM BatchMonitor) is null
  BEGIN
    SET @BatchOID = 0
  END
 ELSE
  BEGIN
    SELECT @BatchOID = Max(OID) FROM BatchMonitor
  END

SET @BatchOID = @BatchOID + 1
SET @BatchStart = (SELECT Max(BatchStart) FROM BatchMonitor)
IF @BatchStart IS NULL
BEGIN
  SET @BatchStart = GetDate()
END 

INSERT INTO BatchMonitor (OID, BatchStart, BatchStep, StepStart, Status)
VALUES (@BatchOID, @BatchStart, 'DealActivityFacts', GetDate(), 'Running')
 

/************************************************
 * Load DealActivityFacts table
 ************************************************/

TRUNCATE TABLE DealActivityFacts

INSERT INTO DealActivityFacts
	(DealID,DocType,DocDate,RefNum,
	ARDocsID,OffsetDetailID,CustID,ProdID,
	FundDetID,Amount,Volume,UnitMsr,
	NumInvLineItems,OrigAmount,ReasonCode,ReasonID,
	OrderNum,EPIOrderNum,BatchNum,Posted,PostDate,
	CreatedBy,CreatedDate,EditedBy,EditedDate)
SELECT
	DealID,DocType,DocDate,RefNum,
	ARDocsID,OffsetDetailID,CustID,ProdID,
	FundDetID,Amount,Volume,UnitMsr,
	NumInvLineItems,OrigAmount,ReasonCode,ReasonID,
	OrderNum,EPIOrderNum,BatchNum,Posted,PostDate,
	355,GetDate(),EditedBy,EditedDate
FROM DealActivity

UPDATE DealActivityFacts
SET PromoID = Deals.PromoID, 
    PromoName = Promotions.Name,
    DealName = Deals.Name,
    DealSource = Deals.Source,
    DealSourceID = Deals.SourceID,
    DealTypeID = Deals.DealTypeID
FROM Deals, Promotions
WHERE DealActivityFacts.DealID = Deals.OID
  AND Deals.PromoID = Promotions.OID

UPDATE DealActivityFacts
SET DealType = DealTypes.Name
FROM DealTypes
WHERE DealTypeID = DealTypes.OID

/*******************************************************
 * Set customer AND product values
 *******************************************************/
UPDATE DealActivityFacts SET
DealActivityFacts.CustTypeName = CustStruct2.CustTypeName,
DealActivityFacts.CustHierName = CustStruct2.CustHierName,
DealActivityFacts.ProdHierName = ProdStruct2.ProdHierName
FROM CustStruct2, ProdStruct2
WHERE CustStruct2.CustID = DealActivityFacts.CustID
  AND ProdStruct2.ProdID = DealActivityFacts.ProdID

UPDATE DealActivityFacts SET
DealActivityFacts.CustID = CustStruct2.CustID,
DealActivityFacts.CustName = CustStruct2.CustName,
DealActivityFacts.OrgsID = CustStruct2.OrgsID,
DealActivityFacts.CustSourceID = CustStruct2.CustSourceID,
DealActivityFacts.CustFROMTop = CustStruct2.CustFROMTop,
DealActivityFacts.CustFROMBottom = CustStruct2.CustFROMBottom,
DealActivityFacts.CustLevelDesc = CustStruct2.CustLevelDesc,
DealActivityFacts.CustLevel1 = CustStruct2.CustLevel1,
DealActivityFacts.CustLevel2 = CustStruct2.CustLevel2,
DealActivityFacts.CustLevel3 = CustStruct2.CustLevel3,
DealActivityFacts.CustLevel4 = CustStruct2.CustLevel4,
DealActivityFacts.CustLevel5 = CustStruct2.CustLevel5,
DealActivityFacts.CustLevel6 = CustStruct2.CustLevel6,
DealActivityFacts.CustLevel7 = CustStruct2.CustLevel7,
DealActivityFacts.CustLevel8 = CustStruct2.CustLevel8,
DealActivityFacts.CustLevel9 = CustStruct2.CustLevel9,
DealActivityFacts.CustNameLevel1 = CustStruct2.CustNameLevel1,
DealActivityFacts.CustNameLevel2 = CustStruct2.CustNameLevel2,
DealActivityFacts.CustNameLevel3 = CustStruct2.CustNameLevel3,
DealActivityFacts.CustNameLevel4 = CustStruct2.CustNameLevel4,
DealActivityFacts.CustNameLevel5 = CustStruct2.CustNameLevel5,
DealActivityFacts.CustNameLevel6 = CustStruct2.CustNameLevel6,
DealActivityFacts.CustNameLevel7 = CustStruct2.CustNameLevel7,
DealActivityFacts.CustNameLevel8 = CustStruct2.CustNameLevel8,
DealActivityFacts.CustNameLevel9 = CustStruct2.CustNameLevel9,
DealActivityFacts.OrgsIDLevel1 = CustStruct2.OrgsIDLevel1,
DealActivityFacts.OrgsIDLevel2 = CustStruct2.OrgsIDLevel2,
DealActivityFacts.OrgsIDLevel3 = CustStruct2.OrgsIDLevel3,
DealActivityFacts.OrgsIDLevel4 = CustStruct2.OrgsIDLevel4,
DealActivityFacts.OrgsIDLevel5 = CustStruct2.OrgsIDLevel5,
DealActivityFacts.OrgsIDLevel6 = CustStruct2.OrgsIDLevel6,
DealActivityFacts.OrgsIDLevel7 = CustStruct2.OrgsIDLevel7,
DealActivityFacts.OrgsIDLevel8 = CustStruct2.OrgsIDLevel8,
DealActivityFacts.OrgsIDLevel9 = CustStruct2.OrgsIDLevel9,
DealActivityFacts.CustSourceIDLevel1 = CustStruct2.CustSourceIDLevel1,
DealActivityFacts.CustSourceIDLevel2 = CustStruct2.CustSourceIDLevel2,
DealActivityFacts.CustSourceIDLevel3 = CustStruct2.CustSourceIDLevel3,
DealActivityFacts.CustSourceIDLevel4 = CustStruct2.CustSourceIDLevel4,
DealActivityFacts.CustSourceIDLevel5 = CustStruct2.CustSourceIDLevel5,
DealActivityFacts.CustSourceIDLevel6 = CustStruct2.CustSourceIDLevel6,
DealActivityFacts.CustSourceIDLevel7 = CustStruct2.CustSourceIDLevel7,
DealActivityFacts.CustSourceIDLevel8 = CustStruct2.CustSourceIDLevel8,
DealActivityFacts.CustSourceIDLevel9 = CustStruct2.CustSourceIDLevel9,
DealActivityFacts.CustTypeID = CustStruct2.CustTypeID,
DealActivityFacts.CustHierID = CustStruct2.CustHierID,
DealActivityFacts.CustParentID = CustStruct2.CustParentID,
DealActivityFacts.ProdID = ProdStruct2.ProdID,
DealActivityFacts.ProdName = ProdStruct2.ProdName, 
DealActivityFacts.ProdFROMTop = ProdStruct2.ProdFROMTop,
DealActivityFacts.ProdFROMBottom = ProdStruct2.ProdFROMBottom,
DealActivityFacts.ProdLevelDesc = ProdStruct2.ProdLevelDesc,
DealActivityFacts.ProdLevel1 = ProdStruct2.ProdLevel1,
DealActivityFacts.ProdLevel2 = ProdStruct2.ProdLevel2,
DealActivityFacts.ProdLevel3 = ProdStruct2.ProdLevel3,
DealActivityFacts.ProdLevel4 = ProdStruct2.ProdLevel4,
DealActivityFacts.ProdLevel5 = ProdStruct2.ProdLevel5,
DealActivityFacts.ProdLevel6 = ProdStruct2.ProdLevel6,
DealActivityFacts.ProdLevel7 = ProdStruct2.ProdLevel7,
DealActivityFacts.ProdLevel8 = ProdStruct2.ProdLevel8,
DealActivityFacts.ProdLevel9 = ProdStruct2.ProdLevel9,
DealActivityFacts.ProdNameLevel1 = ProdStruct2.ProdNameLevel1,
DealActivityFacts.ProdNameLevel2 = ProdStruct2.ProdNameLevel2,
DealActivityFacts.ProdNameLevel3 = ProdStruct2.ProdNameLevel3,
DealActivityFacts.ProdNameLevel4 = ProdStruct2.ProdNameLevel4,
DealActivityFacts.ProdNameLevel5 = ProdStruct2.ProdNameLevel5,
DealActivityFacts.ProdNameLevel6 = ProdStruct2.ProdNameLevel6,
DealActivityFacts.ProdNameLevel7 = ProdStruct2.ProdNameLevel7,
DealActivityFacts.ProdNameLevel8 = ProdStruct2.ProdNameLevel8,
DealActivityFacts.ProdNameLevel9 = ProdStruct2.ProdNameLevel9,
DealActivityFacts.SourceCodeLevel1 = ProdStruct2.SourceCodeLevel1,
DealActivityFacts.SourceCodeLevel2 = ProdStruct2.SourceCodeLevel2,
DealActivityFacts.SourceCodeLevel3 = ProdStruct2.SourceCodeLevel3,
DealActivityFacts.SourceCodeLevel4 = ProdStruct2.SourceCodeLevel4,
DealActivityFacts.SourceCodeLevel5 = ProdStruct2.SourceCodeLevel5,
DealActivityFacts.SourceCodeLevel6 = ProdStruct2.SourceCodeLevel6,
DealActivityFacts.SourceCodeLevel7 = ProdStruct2.SourceCodeLevel7,
DealActivityFacts.SourceCodeLevel8 = ProdStruct2.SourceCodeLevel8,
DealActivityFacts.SourceCodeLevel9 = ProdStruct2.SourceCodeLevel9,
DealActivityFacts.SourceCode = ProdStruct2.SourceCode,
DealActivityFacts.ProdHierID = ProdStruct2.ProdHierID,
DealActivityFacts.ProdParentID = ProdStruct2.ProdParentID
FROM CustStruct2, ProdStruct2
WHERE CustStruct2.CustID = DealActivityFacts.CustID
  AND ProdStruct2.ProdID = DealActivityFacts.ProdID


/***************************************************************************
 * Set Period values based on DocDate
 ***************************************************************************/
UPDATE DealActivityFacts SET
TransYear = PeriodToPost.FinYear,
TransPeriod = PeriodToPost.Name
FROM PeriodToPost
WHERE DealActivityFacts.DocDate >= PeriodToPost.BegDate
  AND DealActivityFacts.DocDate <= PeriodToPost.EndDate

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

