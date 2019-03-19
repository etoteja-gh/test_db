SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_ProdStruct_Load] AS

/******************************************************************************
 * sp_TPMS_ProdStruct_Load.sql 7/28/03  
 * B. Sullivan
 * Build Product Hierarchy Table (ProdStruct)
 * Update Products.SortField
 * Build ProdTreeStruct
 ******************************************************************************/

/* Modified 7/28/03  Eliminate deleted records from display    */
/* Modified 7/28/03  Standardize code                          */
/* Modified 7/19/04  Eliminate fully qualified DB name         */

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
VALUES (@BatchOID, @BatchStart, 'ProdStruct_Load', GetDate(), 'Running')

/******************************************************************************
 * Build Product Hierarchy Table (ProdStruct) 
 ******************************************************************************/

TRUNCATE TABLE ProdStruct

ALTER TABLE ProdStruct DROP CONSTRAINT PK_ProdStruct 

ALTER TABLE ProdStruct DROP COLUMN OID

EXEC ('ALTER TABLE ProdStruct ADD OID INT IDENTITY(1,1) NOT NULL')

INSERT INTO ProdStruct
(ProdID, ParentID)
SELECT OID, ParentID
FROM Products
WHERE Products.Deleted <> 1

UPDATE ProdStruct SET Parent1ID = Products.ParentID
FROM Products
WHERE ProdStruct.ParentID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent2ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent1ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent3ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent2ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent4ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent3ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent5ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent4ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent6ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent5ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent7ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent6ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent8ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent7ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent9ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent8ID = Products.OID AND Products.ParentID <> 0

UPDATE ProdStruct SET Parent10ID = Products.ParentID
FROM Products
WHERE ProdStruct.Parent9ID = Products.OID AND Products.ParentID <> 0

ALTER TABLE ProdStruct ALTER COLUMN OID INT NOT NULL

ALTER TABLE ProdStruct ADD CONSTRAINT PK_ProdStruct 
   PRIMARY KEY CLUSTERED (OID) ON [PRIMARY]

UPDATE ProdStruct SET Parent10ID = NULL WHERE Parent10ID = Parent9ID
UPDATE ProdStruct SET Parent9ID = NULL WHERE Parent9ID = Parent8ID
UPDATE ProdStruct SET Parent8ID = NULL WHERE Parent8ID = Parent7ID
UPDATE ProdStruct SET Parent7ID = NULL WHERE Parent7ID = Parent6ID
UPDATE ProdStruct SET Parent6ID = NULL WHERE Parent6ID = Parent5ID
UPDATE ProdStruct SET Parent5ID = NULL WHERE Parent5ID = Parent4ID
UPDATE ProdStruct SET Parent4ID = NULL WHERE Parent4ID = Parent3ID
UPDATE ProdStruct SET Parent3ID = NULL WHERE Parent3ID = Parent2ID
UPDATE ProdStruct SET Parent2ID = NULL WHERE Parent2ID = Parent1ID
UPDATE ProdStruct SET Parent1ID = NULL WHERE Parent1ID = ParentID
UPDATE ProdStruct SET ParentID = NULL WHERE ParentID = ProdID

UPDATE Products SET ParentID = NULL WHERE ParentID = OID

/******************************************************************************
 * Update Products.SortField with data from ProdStruct 
 * HierID_Parent10ID_Parent9ID_...ParentID_Orgs.Name
 ******************************************************************************/

UPDATE Products 
  SET SortField = CAST(OID AS VARCHAR)
UPDATE Products 
  SET SortField = CAST(ProdStruct.ParentID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.ParentID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent1ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent1ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent2ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent2ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent3ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent3ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent4ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent4ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent5ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent5ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent6ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent6ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent7ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent7ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent8ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent8ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent9ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent9ID IS NOT NULL
UPDATE Products 
  SET SortField = CAST(ProdStruct.Parent10ID AS VARCHAR) + '_' + SortField 
  FROM Products, ProdStruct 
  WHERE Products.OID = ProdStruct.ProdID AND ProdStruct.Parent10ID IS NOT NULL

/*************************************************************************************
 * Load ProdTreeStruct table
 *************************************************************************************/

DECLARE @ProdStructOID BIGINT
DECLARE @NodeCount INT
DECLARE @RecordCount BIGINT
SELECT @RecordCount = 1

TRUNCATE TABLE ProdTreeStruct

-- SET up cursor
DECLARE curProdStruct1 CURSOR FOR

SELECT OID FROM ProdStruct

--Open cursor, get first record
OPEN curProdStruct1
FETCH NEXT FROM curProdStruct1 INTO @ProdStructOID

--loop through cursor
WHILE @@FETCH_STATUS = 0

BEGIN

SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, ProdID, 0 FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID

IF (SELECT ParentID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT  @RecordCount, ProdID, ParentID, 1 FROM ProdStruct WHERE ParentID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent1ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT  @RecordCount, ProdID, Parent1ID, 2 FROM ProdStruct WHERE Parent1ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent2ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent2ID, 3 FROM ProdStruct WHERE Parent2ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent3ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent3ID, 4 FROM ProdStruct WHERE Parent3ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent4ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent4ID, 5 FROM ProdStruct WHERE Parent4ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent5ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent5ID, 6 FROM ProdStruct WHERE Parent5ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent6ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent6ID, 7 FROM ProdStruct WHERE Parent6ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent7ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent7ID, 8 FROM ProdStruct WHERE Parent7ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent8ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent8ID, 9 FROM ProdStruct WHERE Parent8ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent9ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent9ID, 10 FROM ProdStruct WHERE Parent9ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END

IF (SELECT Parent10ID FROM ProdStruct WHERE ProdStruct.OID = @ProdStructOID) Is NOT NULL
BEGIN
  SELECT @RecordCount = convert(BIGINT,OID + 1) FROM ProdTreeStruct 
INSERT INTO ProdTreeStruct (OID, ProdID, AncestorID, Depth) 
SELECT @RecordCount, ProdID, Parent10ID, 11 FROM ProdStruct WHERE Parent10ID  Is NOT NULL AND ProdStruct.OID = @ProdStructOID
END


FETCH NEXT FROM curProdStruct1 INTO @ProdStructOID
END

CLOSE curProdStruct1
DEALLOCATE curProdStruct1

UPDATE ProdTreeStruct SET NodeCount =
(SELECT (Count(OID) + 1) FROM ProdStruct 
 WHERE ProdTreeStruct.ProdID = ParentID 
    OR ProdTreeStruct.ProdID = Parent1ID 
    OR ProdTreeStruct.ProdID = Parent2ID 
    OR ProdTreeStruct.ProdID = Parent3ID 
    OR ProdTreeStruct.ProdID = Parent4ID
    OR ProdTreeStruct.ProdID = Parent5ID 
    OR ProdTreeStruct.ProdID = Parent6ID 
    OR ProdTreeStruct.ProdID = Parent7ID 
    OR ProdTreeStruct.ProdID = Parent8ID 
    OR ProdTreeStruct.ProdID = Parent9ID 
    OR ProdTreeStruct.ProdID = Parent10ID)

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

