SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_Liability] AS

/*********************************
 * sp_TPMS_Liability   
 * Load Liability table
 * B. Sullivan   7/21/04
 *********************************/

/* Modified  7/21/04 Initial load as SP                         */


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
VALUES (@BatchOID, @BatchStart, 'Liability', GetDate(), 'Running')
 

/************************************************
 * Load Liability table
 ************************************************/
TRUNCATE TABLE Liability

ALTER TABLE Liability DROP CONSTRAINT PK_Liability 

ALTER TABLE Liability DROP COLUMN OID

EXEC ('ALTER TABLE Liability ADD OID INT IDENTITY(1,1) NOT NULL')


INSERT INTO Liability
(Version, DealID, DealTypeID, SysDealTypeID,
 AmountType, Amount, YTDAmount, 
 P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,
 DealBegDate, DealEndDate, PTPName, 
 Half, Trimester, Quarter, Period,
 FinYear, DisplayOrder,
 CreatedBy, CreatedDate, EditedBy, EditedDate)
SELECT 0, Deals.OID, DealTypeID, SysDealTypeID, 'Commit', TotAmount, 0,
       0,0,0,0,0,0,0,0,0,0,0,0,0,
       DealBegDate, DealEndDate, 
       PeriodToPost.Name, PeriodToPost.Half, PeriodToPost.Trimester, PeriodToPost.Quarter, PeriodToPost.Period,
       PeriodtoPost.FinYear, 1, 
       1, GetDate(),1,GetDate()
FROM Deals, PeriodToPost, SysDealTypes, DealTypes
WHERE Deals.DealTypeID = DealTypes.SysDealTypeID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
--  AND SysDealTypes.Name in ('OI', 'BB', 'LS')
  AND (DealBegDate >= PeriodToPost.BegDate
       AND DealBegDate <= PeriodToPost.EndDate)
AND Deals.SysStatus not in ('INV', 'EDIT', 'DE')

INSERT INTO Liability
(Version, DealID, DealTypeID, SysDealTypeID,
 AmountType, Amount, YTDAmount, 
 P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,
 DealBegDate, DealEndDate, PTPName, 
 Half, Trimester, Quarter, Period,
 FinYear, DisplayOrder,
 CreatedBy, CreatedDate, EditedBy, EditedDate)
SELECT 0, Deals.OID, DealTypeID, SysDealTypeID, 'Accrual', Accrual, 0,
       0,0,0,0,0,0,0,0,0,0,0,0,0,
       DealBegDate, DealEndDate, 
       PeriodToPost.Name, PeriodToPost.Half, PeriodToPost.Trimester, PeriodToPost.Quarter, PeriodToPost.Period,
       PeriodtoPost.FinYear, 2, 
       1, GetDate(),1,GetDate()
FROM Deals, PeriodToPost, SysDealTypes, DealTypes
WHERE Deals.DealTypeID = DealTypes.SysDealTypeID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND (DealBegDate >= PeriodToPost.BegDate
       AND DealBegDate <= PeriodToPost.EndDate)
  AND Accrual <> 0
AND Deals.SysStatus not in ('INV', 'EDIT', 'DE')

INSERT INTO Liability
(Version, DealID, DealTypeID, SysDealTypeID,
 AmountType, Amount, YTDAmount, 
 P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,
 DealBegDate, DealEndDate, PTPName, 
 Half, Trimester, Quarter, Period,
 FinYear, DisplayOrder,
 CreatedBy, CreatedDate, EditedBy, EditedDate)
SELECT 0, Deals.OID, DealTypeID, SysDealTypeID, 'Payments', Payments, 0,
       0,0,0,0,0,0,0,0,0,0,0,0,0,
       DealBegDate, DealEndDate, 
       PeriodToPost.Name, PeriodToPost.Half, PeriodToPost.Trimester, PeriodToPost.Quarter, PeriodToPost.Period,
       PeriodtoPost.FinYear, 3, 
       1, GetDate(),1,GetDate()
FROM Deals, PeriodToPost, SysDealTypes, DealTypes
WHERE Deals.DealTypeID = DealTypes.SysDealTypeID
  AND DealTypes.SysDealTypeID = SysDealTypes.OID
  AND (DealBegDate >= PeriodToPost.BegDate
       AND DealBegDate <= PeriodToPost.EndDate)
  AND Payments <> 0 
AND Deals.SysStatus not in ('INV', 'EDIT', 'DE')

ALTER TABLE Liability ALTER COLUMN OID INT NOT NULL

ALTER TABLE dbo.Liability ADD CONSTRAINT PK_Liability 
   PRIMARY KEY CLUSTERED (OID) ON [PRIMARY]

UPDATE Liability SET P1 = Amount WHERE Period = '1' 
UPDATE Liability SET P2 = Amount WHERE Period = '2' 
UPDATE Liability SET P3 = Amount WHERE Period = '3' 
UPDATE Liability SET P4 = Amount WHERE Period = '4' 
UPDATE Liability SET P5 = Amount WHERE Period = '5' 
UPDATE Liability SET P6 = Amount WHERE Period = '6' 
UPDATE Liability SET P7 = Amount WHERE Period = '7' 
UPDATE Liability SET P8 = Amount WHERE Period = '8' 
UPDATE Liability SET P9 = Amount WHERE Period = '9' 
UPDATE Liability SET P10 = Amount WHERE Period = '10' 
UPDATE Liability SET P11 = Amount WHERE Period = '11' 
UPDATE Liability SET P12 = Amount WHERE Period = '12' 
UPDATE Liability SET P13 = Amount WHERE Period = '13' 


--Select * from Liability Order by DealID, DisplayOrder

/***SELECT DealTypeID, AmountType, SUM(Amount), SUM(YTDAmount), 
SUM(P1), SUM(P2), SUM(P3), SUM(P4), SUM(P5), SUM(P6), SUM(P7), 
SUM(P8), SUM(P9), SUM(P10), SUM(P11), SUM(P12), SUM(P13)
FROM Liability 
GROUP BY DealTypeID, AmountType
ORDER BY DealTypeID***/

/*********************************************************
 * Update BatchMonitor
 *********************************************************/
SET @StepEnd = GetDate()

UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
WHERE BatchMonitor.OID = @BatchOID
 

;
SET QUOTED_IDENTIFIER OFF 
;
SET ANSI_NULLS ON 
;

