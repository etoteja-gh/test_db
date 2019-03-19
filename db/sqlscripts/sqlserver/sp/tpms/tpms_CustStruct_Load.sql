SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_CustStruct_Load] AS

/*  sp_TPMS_CustStruct_Load.sql  8/21/03
 *  B. Sullivan                           */

/* Modified  7/19/04 Elim fully qualified db names        */ 

/***********************************************************************************************
 * Build Customer Hierarchy Table (CustStruct) and CustTreeStruct and UPDATE Customers.SortField
 ***********************************************************************************************/


TRUNCATE TABLE CustStruct

ALTER TABLE CustStruct DROP CONSTRAINT PK_CustStruct 

alter table CustStruct drop column OID

exec ('alter table CustStruct add OID int IDENTITY(1,1) NOT NULL')


INSERT INTO CustStruct
(CustID, ParentID)
SELECT OID, ParentID
FROM Customers

UPDATE CustStruct set Parent1ID = Customers.ParentID
FROM Customers
WHERE CustStruct.ParentID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent2ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent1ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent3ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent2ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent4ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent3ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent5ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent4ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent6ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent5ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent7ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent6ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent8ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent7ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent9ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent8ID = Customers.OID and Customers.ParentID <> 0

UPDATE CustStruct set Parent10ID = Customers.ParentID
FROM Customers
WHERE CustStruct.Parent9ID = Customers.OID and Customers.ParentID <> 0

ALTER TABLE CustStruct ALTER COLUMN OID int NOT NULL

ALTER TABLE CustStruct ADD CONSTRAINT PK_CustStruct 
   PRIMARY KEY CLUSTERED (OID) ON [PRIMARY]

UPDATE CustStruct SET Parent10ID = NULL WHERE Parent10ID = Parent9ID
UPDATE CustStruct SET Parent9ID = NULL WHERE Parent9ID = Parent8ID
UPDATE CustStruct SET Parent8ID = NULL WHERE Parent8ID = Parent7ID
UPDATE CustStruct SET Parent7ID = NULL WHERE Parent7ID = Parent6ID
UPDATE CustStruct SET Parent6ID = NULL WHERE Parent6ID = Parent5ID
UPDATE CustStruct SET Parent5ID = NULL WHERE Parent5ID = Parent4ID
UPDATE CustStruct SET Parent4ID = NULL WHERE Parent4ID = Parent3ID
UPDATE CustStruct SET Parent3ID = NULL WHERE Parent3ID = Parent2ID
UPDATE CustStruct SET Parent2ID = NULL WHERE Parent2ID = Parent1ID
UPDATE CustStruct SET Parent1ID = NULL WHERE Parent1ID = ParentID
UPDATE CustStruct SET ParentID = NULL WHERE ParentID = CustID

UPDATE Customers SET ParentID = NULL WHERE ParentID = OID

/************************************************************
 * UPDATE Customers.SortField with data FROM CustStruct
 * HierID_Parent10ID_Parent9ID_...ParentID_Orgs.Name
 ************************************************************/

UPDATE Customers 
  SET SortField = CAST(OID AS VARCHAR)

/*UPDATE Customers SET SortField = Orgs.Name
FROM Orgs WHERE Customers.OrgsID = Orgs.OID*/

UPDATE Customers 
  SET SortField = CAST(CustStruct.ParentID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.ParentID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent1ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent1ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent2ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent2ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent3ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent3ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent4ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent4ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent5ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent5ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent6ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent6ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent7ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent7ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent8ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent8ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent9ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent9ID IS NOT NULL
UPDATE Customers 
  SET SortField = CAST(CustStruct.Parent10ID AS VARCHAR) + '_' + SortField 
  FROM Customers, CustStruct 
  WHERE Customers.OID = CustStruct.CustID AND CustStruct.Parent10ID IS NOT NULL


--SELECT * FROM CustStruct

--SELECT * FROM Customers WHERE ParentID <> 0 and ParentID <> OID

--Load CustTreeStruct table

DECLARE @CustStructOID bigint
DECLARE @NodeCount int
DECLARE @RecordCount bigint
SELECT @RecordCount = 1

Truncate table CustTreeStruct

-- Set up cursor
DECLARE curCustStruct CURSOR FOR

SELECT OID FROM CustStruct

--Open cursor, get first record
OPEN curCustStruct
FETCH NEXT FROM curCustStruct INTO @CustStructOID

--loop through cursor
WHILE @@FETCH_STATUS = 0

BEGIN

SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, CustID, 0 FROM CustStruct WHERE CustStruct.OID = @CustStructOID

IF (SELECT ParentID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT  @RecordCount, CustID, ParentID, 1 FROM CustStruct WHERE ParentID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent1ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT  @RecordCount, CustID, Parent1ID, 2 FROM CustStruct WHERE Parent1ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent2ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent2ID, 3 FROM CustStruct WHERE Parent2ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent3ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent3ID, 4 FROM CustStruct WHERE Parent3ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent4ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent4ID, 5 FROM CustStruct WHERE Parent4ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent5ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent5ID, 6 FROM CustStruct WHERE Parent5ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent6ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent6ID, 7 FROM CustStruct WHERE Parent6ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent7ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent7ID, 8 FROM CustStruct WHERE Parent7ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent8ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent8ID, 9 FROM CustStruct WHERE Parent8ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent9ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent9ID, 10 FROM CustStruct WHERE Parent9ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END

IF (SELECT Parent10ID FROM CustStruct WHERE CustStruct.OID = @CustStructOID) IS NOT NULL
BEGIN
  SELECT @RecordCount = convert(bigint,OID + 1) FROM CustTreeStruct 
INSERT INTO CustTreeStruct (OID, CustID, AncestorID, Depth) 
SELECT @RecordCount, CustID, Parent10ID, 11 FROM CustStruct WHERE Parent10ID  IS NOT NULL AND CustStruct.OID = @CustStructOID
END


FETCH NEXT FROM curCustStruct INTO @CustStructOID
END

CLOSE curCustStruct
DEALLOCATE curCustStruct

UPDATE CustTreeStruct set NodeCount =
(SELECT (Count(OID) + 1) FROM CustStruct 
 WHERE 
CustTreeStruct.CustID = ParentID or
CustTreeStruct.CustID = Parent1ID or
CustTreeStruct.CustID = Parent2ID or
CustTreeStruct.CustID = Parent3ID or
CustTreeStruct.CustID = Parent4ID or
CustTreeStruct.CustID = Parent5ID or
CustTreeStruct.CustID = Parent6ID or
CustTreeStruct.CustID = Parent7ID or
CustTreeStruct.CustID = Parent8ID or
CustTreeStruct.CustID = Parent9ID or
CustTreeStruct.CustID = Parent10ID)




;
SET QUOTED_IDENTIFIER OFF 
;
SET ANSI_NULLS ON 
;

