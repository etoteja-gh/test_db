SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_LoadFactStructures] AS

/*************************************************************************************
 * Create Flattened Customers AND Products Hierarcy tables
 * Brian Sullivan  5/2/04
 * Last Modified 7/19/04
 *************************************************************************************/

/* Modified  7/19/04  Comment out Hain specific code  */
/* Modified  8/3/04   Add Batch Monitor               */

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
VALUES (@BatchOID, @BatchStart, 'Fact Structures', GetDate(), 'Running')
 

/*************************************************************************************
 *  Invert CustStruct AND ProdStruct
 * This code should run in the sp after the creation of the customers AND products
 *************************************************************************************/

TRUNCATE TABLE CustStruct2

INSERT INTO CustStruct2 (CustID, CustHierID, CustTypeID, CustParentID, EditedBy, EditedDate, CreatedBy, CreatedDate)
SELECT OID, HierID, CustTypeID, ParentID, 355, GetDate(), 355, GetDate()
 FROM Customers

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent6ID, 
CustLevel2 = CustStruct.Parent5ID, 
CustLevel3 = CustStruct.Parent4ID,
CustLevel4 = CustStruct.Parent3ID,
CustLevel5 = CustStruct.Parent2ID,
CustLevel6 = CustStruct.Parent1ID,
CustLevel7 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent6ID IS NOT NULL AND Parent6ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent5ID, 
CustLevel2 = CustStruct.Parent4ID, 
CustLevel3 = CustStruct.Parent3ID,
CustLevel4 = CustStruct.Parent2ID,
CustLevel5 = CustStruct.Parent1ID,
CustLevel6 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent5ID is not null AND Parent5ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent4ID, 
CustLevel2 = CustStruct.Parent3ID, 
CustLevel3 = CustStruct.Parent2ID,
CustLevel4 = CustStruct.Parent1ID,
CustLevel5 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent4ID is not null AND Parent4ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent3ID, 
CustLevel2 = CustStruct.Parent2ID, 
CustLevel3 = CustStruct.Parent1ID,
CustLevel4 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent3ID is not null AND Parent3ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent2ID, 
CustLevel2 = CustStruct.Parent1ID, 
CustLevel3 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent2ID is not null AND Parent2ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.Parent1ID, 
CustLevel2 = CustStruct.ParentID
 FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND Parent1ID is not null AND Parent1ID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 
SET CustID = CustStruct.CustID, 
CustLevel1 = CustStruct.ParentID
FROM CustStruct
WHERE CustStruct2.CustID = CustStruct.CustID
  AND CustStruct2.CustParentID is not null AND CustStruct2.CustParentID <> 0
  AND CustLevel1 IS NULL

UPDATE CustStruct2 SET CustFromTop = 0
WHERE CustLevel1 IS NULL
UPDATE CustStruct2 SET CustFromTop = 1
WHERE CustLevel2 IS NULL AND CustLevel1 is not null
UPDATE CustStruct2 SET CustFromTop = 2
WHERE CustLevel3 IS NULL AND CustLevel2 is not null
UPDATE CustStruct2 SET CustFromTop = 3
WHERE CustLevel4 IS NULL AND CustLevel3 is not null
UPDATE CustStruct2 SET CustFromTop = 4
WHERE CustLevel5 IS NULL AND CustLevel4 is not null
UPDATE CustStruct2 SET CustFromTop = 5
WHERE CustLevel6 IS NULL AND CustLevel5 is not null
UPDATE CustStruct2 SET CustFromTop = 6
WHERE CustLevel7 IS NULL AND CustLevel6 is not null
UPDATE CustStruct2 SET CustFromTop = 7
WHERE CustLevel8 IS NULL AND CustLevel7 is not null
UPDATE CustStruct2 SET CustFromTop = 8
WHERE CustLevel9 IS NULL AND CustLevel8 is not null



/**************************************************************
 * This code doesn't work
Declare @FromTop int
SELECT @FromTop = Max(FromTop) FROM CustStruct2
UPDATE CustStruct2 SET FromBottom = 0 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 1 WHERE FromTop = @FromTop 
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 2 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 3 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 4 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 5 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE CustStruct2 SET FromBottom = 6 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
**************************************************************/



UPDATE CustStruct2 SET
OrgsID = Orgs.OID, CustName = Orgs.Name, CustSourceID = Orgs.SourceID
FROM Orgs, Customers
WHERE CustID = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel1 = Orgs.OID, CustNameLevel1 = Orgs.Name, CustSourceIDLevel1 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel1 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel2 = Orgs.OID, CustNameLevel2 = Orgs.Name, CustSourceIDLevel2 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel2 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel3 = Orgs.OID, CustNameLevel3 = Orgs.Name, CustSourceIDLevel3 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel3 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel4 = Orgs.OID, CustNameLevel4 = Orgs.Name, CustSourceIDLevel4 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel4 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel5 = Orgs.OID, CustNameLevel5 = Orgs.Name, CustSourceIDLevel5 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel5 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel6 = Orgs.OID, CustNameLevel6 = Orgs.Name, CustSourceIDLevel6 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel6 = Customers.OID
  AND Customers.OrgsID = Orgs.OID
UPDATE CustStruct2 SET
OrgsIDLevel7 = Orgs.OID, CustNameLevel7 = Orgs.Name, CustSourceIDLevel7 = Orgs.SourceID
FROM Orgs, Customers
WHERE CustLevel7 = Customers.OID
  AND Customers.OrgsID = Orgs.OID

/*************************************************************
 * This code has to be set by client from Parameters table -- Also not working
 *************************************************************/
/********************************************************
 * Code for Demo
UPDATE CustStruct2 SET CustLevelDesc = 'Total' WHERE CustFromTop = 0 AND CustName = 'Abc Corp.'

UPDATE CustStruct2 SET CustLevelDesc = 'Category' WHERE CustFromTop = 1
UPDATE CustStruct2 SET CustLevelDesc = 'Territory' WHERE CustFromTop = 2
UPDATE CustStruct2 SET CustLevelDesc = 'Customer' WHERE CustFromTop = 3

-- CustLevelDesc for National Account parents
UPDATE CustStruct2 SET CustLevelDesc = 'National Parent' 
FROM Hierarchies
WHERE CustHierID = Hierarchies.OID
  AND Hierarchies.Name = 'National'
  AND CustFromTop = 1

-- CustLevelDesc for National Account customers
UPDATE CustStruct2 SET CustLevelDesc = 'Customer' 
FROM Hierarchies
WHERE CustHierID = Hierarchies.OID
  AND Hierarchies.Name = 'National'
  AND CustFromTop = 2
***/

/****
 * Code for Hain

UPDATE CustStruct2 SET CustLevelDesc = 'Total' WHERE CustFromTop = 0 AND CustName = 'Total'

UPDATE CustStruct2 SET CustLevelDesc = 'Division' 
WHERE  CustFromTop = 1 
  AND CustName in ('KEVIN MOSLEY: V.P. OF SALES','SNACKS: SNACKS')

UPDATE CustStruct2 SET CustLevelDesc = 'Region' WHERE CustFromTop = 2
UPDATE CustStruct2 SET CustLevelDesc = 'Territory' WHERE CustFromTop = 3
UPDATE CustStruct2 SET CustLevelDesc = 'Customer' WHERE CustTypeID in (1,2,6)

 ****/

TRUNCATE TABLE ProdStruct2

INSERT INTO ProdStruct2 (ProdID, ProdHierID, ProdParentID, SourceCode, EditedBy, EditedDate, CreatedBy, CreatedDate)
SELECT OID, HierID, ParentID, SourceCode, 355, GetDate(), 355, GetDate() FROM Products

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent6ID, 
ProdLevel2 = ProdStruct.Parent5ID, 
ProdLevel3 = ProdStruct.Parent4ID,
ProdLevel4 = ProdStruct.Parent3ID,
ProdLevel5 = ProdStruct.Parent2ID,
ProdLevel6 = ProdStruct.Parent1ID,
ProdLevel7 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent6ID is not null AND Parent6ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent5ID, 
ProdLevel2 = ProdStruct.Parent4ID, 
ProdLevel3 = ProdStruct.Parent3ID,
ProdLevel4 = ProdStruct.Parent2ID,
ProdLevel5 = ProdStruct.Parent1ID,
ProdLevel6 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent5ID is not null AND Parent5ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent4ID, 
ProdLevel2 = ProdStruct.Parent3ID, 
ProdLevel3 = ProdStruct.Parent2ID,
ProdLevel4 = ProdStruct.Parent1ID,
ProdLevel5 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent4ID is not null AND Parent4ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent3ID, 
ProdLevel2 = ProdStruct.Parent2ID, 
ProdLevel3 = ProdStruct.Parent1ID,
ProdLevel4 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent3ID is not null AND Parent3ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent2ID, 
ProdLevel2 = ProdStruct.Parent1ID, 
ProdLevel3 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent2ID is not null AND Parent2ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.Parent1ID, 
ProdLevel2 = ProdStruct.ParentID
 FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND Parent1ID is not null AND Parent1ID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 
SET ProdID = ProdStruct.ProdID, 
ProdLevel1 = ProdStruct.ParentID
FROM ProdStruct
WHERE ProdStruct2.ProdID = ProdStruct.ProdID
  AND ProdStruct2.ProdParentID is not null AND ProdStruct2.ProdParentID <> 0
  AND ProdLevel1 IS NULL

UPDATE ProdStruct2 SET ProdFromTop = 0
WHERE ProdLevel1 IS NULL
UPDATE ProdStruct2 SET ProdFromTop = 1
WHERE ProdLevel2 IS NULL AND ProdLevel1 is not null
UPDATE ProdStruct2 SET ProdFromTop = 2
WHERE ProdLevel3 IS NULL AND ProdLevel2 is not null
UPDATE ProdStruct2 SET ProdFromTop = 3
WHERE ProdLevel4 IS NULL AND ProdLevel3 is not null
UPDATE ProdStruct2 SET ProdFromTop = 4
WHERE ProdLevel5 IS NULL AND ProdLevel4 is not null
UPDATE ProdStruct2 SET ProdFromTop = 5
WHERE ProdLevel6 IS NULL AND ProdLevel5 is not null
UPDATE ProdStruct2 SET ProdFromTop = 6
WHERE ProdLevel7 IS NULL AND ProdLevel6 is not null
UPDATE ProdStruct2 SET ProdFromTop = 7
WHERE ProdLevel8 IS NULL AND ProdLevel7 is not null
UPDATE ProdStruct2 SET ProdFromTop = 8
WHERE ProdLevel9 IS NULL AND ProdLevel8 is not null

/**************************************************************
 * This code doesn't work
Declare @FromTop int
SELECT @FromTop = Max(FromTop) FROM ProdStruct2
UPDATE ProdStruct2 SET FromBottom = 0 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 1 WHERE FromTop = @FromTop 
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 2 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 3 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 4 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 5 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
UPDATE ProdStruct2 SET FromBottom = 6 WHERE FromTop = @FromTop
SET @FromTop = @FromTop - 1
**************************************************************/

/*************************************************************
 * This code has to be SET by client FROM Parameters table -- Also not working
 *************************************************************/
/**************  Demo Code   *******************************************
UPDATE ProdStruct2 SET ProdLevelDesc = 'Total' WHERE ProdFromTop = 0
UPDATE ProdStruct2 SET ProdLevelDesc = 'Group' WHERE ProdFromTop = 1
UPDATE ProdStruct2 SET ProdLevelDesc = 'Brand' WHERE ProdFromTop = 2
UPDATE ProdStruct2 SET ProdLevelDesc = 'SKU' WHERE ProdFromTop = 3
UPDATE ProdStruct2 SET ProdLevelDesc = 'SKU' WHERE ProdLevel2 = 13
************************************************************************/
/**************  Hain Code   *******************************************/
UPDATE ProdStruct2 SET ProdLevelDesc = 'Total' WHERE ProdFromTop = 0
UPDATE ProdStruct2 SET ProdLevelDesc = 'Brand' WHERE ProdFromTop = 1
UPDATE ProdStruct2 SET ProdLevelDesc = 'Class/Line' WHERE ProdFromTop = 2
UPDATE ProdStruct2 SET ProdLevelDesc = 'SKU' WHERE ProdFromTop = 3
/************************************************************************/
UPDATE ProdStruct2
SET ProdName = Products.Name, SourceCode = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdID = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel1 = Products.Name, SourceCodeLevel1 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel1 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel2 = Products.Name, SourceCodeLevel2 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel2 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel3 = Products.Name, SourceCodeLevel3 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel3 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel4 = Products.Name, SourceCodeLevel4 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel4 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel5 = Products.Name, SourceCodeLevel5 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel5 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel6 = Products.Name, SourceCodeLevel6 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel6 = Products.OID
UPDATE ProdStruct2
SET ProdNameLevel7 = Products.Name, SourceCodeLevel7 = Products.SourceCode
FROM Products
WHERE ProdStruct2.ProdLevel7 = Products.OID


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

