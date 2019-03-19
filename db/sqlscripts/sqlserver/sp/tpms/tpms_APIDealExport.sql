CREATE   PROCEDURE [dbo].[tpms_APIDealExport] AS

/*********************************
 * sp_TPMS_APIDealExport    8/1/03
 * Export Deals to APIDealExport
 * B. Sullivan
 *********************************/
/* Modified 3/13/03  forestall nulls from AccountingGroup values  */
/* Modified 3/13/03  Status field added                	          */
/* Modified 5/12/03  Change Deal selection for export    	  */
/* Modified 6/2/03   Change Export control method       	  */
/* Modified 6/2/03   Add SourceID to APIDealExport       	  */
/* Modified 6/3/03   Change Status A,C,D - Add, Change, Delete    */
/* Modified 6/30/03  Modify to export DE deals                    */
/* Modified 6/30/03  Modify export selection: DealBegDate <= GetDate() + 30 will export   */
/* Modified 7/2/03   Modify update selection list include DE      */
/* Modified 7/7/03   Change Status setting logic                  */
/* Modified 7/7/03   Fix selection logic for dates                */
/* Modified 7/7/03   Deals below DealID 7534 excluded from export */
/* Modified 7/8/03   Export any new deal not already exported     */
/* Modified 7/10/03  Add TPRs (DealTypeID-3) to Export            */
/* Modified 8/1/03   Export CL deals                              */
/* Modified 8/1/03   Export INV deals if approved                 */
/* Modified 10/8/03  Change Update Exported field to be the same as export selection criteria (not done on 7/8 change?)*/
/* Modified 12/13/03 Stop export of INV deals                     */
/* Modified 12/13/03 Delete all records from APIDealExport when starting, not just successfully exported ones */
/* Modified 2/18/04  Modify export selection to prevent export of Deals that have been created and deleted 
                     without ever being exported                  */
/* Modified 7/19/04  Eliminate fully qualified db names           */
 

/***********************************************************************
 * Export control method
 * 1. In sp_TPMS_APIDealExport
 *    a. Truncate table
 *    b. Load newly exported  
 *    c. Set Deals.Exported = 1, Deals.ExportDate = GetDate()
 * 2. In sp_TPMS_ClientDealExport
 *    a. Load new APIDealExport records 
 *    b. Prepare ClientDealExport table
 *    c. Set APIDealExport.Loaded = 1
  *   d. Set APIDealExport.Exported = 1, APIDealExport.ExportDate = GetDate() 
* 3. Run Client Export job to export to client transaction system
 * 4. On success of Client Export job
 *    a. Set APIDealExport.Loaded = 2 where Loaded = 1
 *    b. Truncate ClientDealExport table
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
VALUES (@BatchOID, @BatchStart, 'TPMS - Export Deals', GetDate(), 'Running')
 


/******************************************
 * Export from Deal tables to APIDealExport
 ******************************************/

INSERT INTO APIDealExportHist
SELECT * FROM APIDealExport
WHERE Exported = 1 
  AND Loaded = 2

/*********** Old Code *************/ 
/* DELETE FROM APIDealExport
WHERE Exported = 1 
  AND Loaded = 2 */

/*********** New Code 12/13/03 *************/ 
TRUNCATE TABLE APIDealExport


INSERT INTO APIDealExport 
(
	EventCode, 
	EventName, 
	DealCode,	
	SourceID,	
	DealName, 
	CustID,
	CustomerName,	
	CustSourceCode,	
	ProductName, 
	ProdSourceCode, 
	PromoBegDate, 
	PromoEndDate,		
	DealType, 
	DealBasis, 
	UnitMsr,		 
	Amount,	
	AmountRate, 
	AmountPct,			
	OrderMin, 
	OrderLimit, 
	InvoicePrint,				
	ReasonCode, 
	ClearAccount, 
	ClearSubAcct,
	Status,	
	Loaded, 
	CreatedDate
)
SELECT 
	Promotions.OID, 
	Promotions.Name, 
	DealCode = Convert(varchar (20), Deals.OID), 
	Deals.SourceID,
	Deals.Name, 
	DealCustomers.CustID,
	Orgs.Name, 
	Orgs.SourceID, 
	Products.Name, 
	Products.SourceCode,
	Deals.DealBegDate, 
	Deals.DealEndDate, 
	DealTypes.Name, 
	DealTypes.DealBasis, 
	DealProducts.UnitMsr, 
	DealProducts.TotAmount, 
	DealProducts.Amount,
	DealProducts.PctList, 
	Deals.OrderMin, 
	Deals.OrderLimit, 
	Deals.InvoicePrint, 
	ReasonCodes.Name, 
	ClearAccount =
	  CASE WHEN DealTypes.ClearAccount is not null THEN DealTypes.ClearAccount ELSE ' ' END, 
	ClearSubAcct =
	  CASE WHEN DealTypes.ClearSubAcct is not null THEN DealTypes.ClearSubAcct ELSE ' ' END,
	Status = 
	  CASE 
	     WHEN Deals.ExportDate is null and Deals.Exported = 0 AND Deals.SysStatus not in  ('CA','DE') THEN 'A'
	     WHEN Deals.ExportDate < Deals.EditedDate AND Deals.Exported = 1 AND Deals.SysStatus not in  ('CA','DE') THEN 'C'
	     WHEN Deals.ExportDate < Deals.EditedDate AND Deals.Exported = 1 AND Deals.SysStatus in ('CA' , 'DE') THEN 'D'
	     END,
	0, 
	GetDate()
FROM 
Promotions Promotions, 
Deals Deals, 
Orgs Orgs, 
Customers Customers, 
DealCustomers DealCustomers, 
Products Products, 
DealProducts DealProducts, 
DealTypes DealTypes, 
ReasonCodes ReasonCodes, 
SysDealTypes SysDealTypes
WHERE       Promotions.OID =* Deals.PromoID 
	AND Customers.OrgsID = Orgs.OID 
	AND DealCustomers.DealID = Deals.OID 
	AND DealCustomers.CustID = Customers.OID 
	AND DealProducts.DealID = Deals.OID 
	AND DealProducts.ProdID = Products.OID 
	AND Deals.DealTypeID = DealTypes.OID 
	AND DealTypes.ReasonID = ReasonCodes.OID 
	AND DealTypes.SysDealTypeID = SysDealTypes.OID 
	AND SysDealTypes.Name in ('OI', 'BB', 'FF', 'FG', 'PctOI', 'PctBB', 'TPR') 
                AND Deals.SysStatus in ('VAL','CA', 'ACT', 'DE','CL')
	AND Deals.ApprovalStatus in ('Approved','Warning')
	AND ((Deals.Exported = 0 AND Deals.SysStatus not in  ('CA','DE') )
	 OR  (Deals.Exported = 1 AND (Deals.ExportDate < Deals.EditedDate))) 
        AND Deals.OID > 7534

/******************************************
 * Update Deal table for Export
 ******************************************/
SET @StepEnd = GetDate()

UPDATE Deals SET Exported = 1, ExportDate = @StepEnd
FROM 
Deals Deals,
Promotions Promotions, 
Orgs Orgs, 
Customers Customers, 
DealCustomers DealCustomers, 
Products Products, 
DealProducts DealProducts, 
DealTypes DealTypes, 
ReasonCodes ReasonCodes, 
SysDealTypes SysDealTypes
WHERE       Promotions.OID =* Deals.PromoID 
	AND Customers.OrgsID = Orgs.OID 
	AND DealCustomers.DealID = Deals.OID 
	AND DealCustomers.CustID = Customers.OID 
	AND DealProducts.DealID = Deals.OID 
	AND DealProducts.ProdID = Products.OID 
	AND Deals.DealTypeID = DealTypes.OID 
	AND DealTypes.ReasonID = ReasonCodes.OID 
	AND DealTypes.SysDealTypeID = SysDealTypes.OID 
	AND SysDealTypes.Name in ('OI', 'BB', 'FF', 'FG', 'PctOI', 'PctBB','TPR')  
      	AND Deals.SysStatus in ('VAL','CA', 'ACT','DE','CL')
	AND Deals.ApprovalStatus in ('Approved','Warning')
	AND ((Deals.Exported = 0)
	 OR  (Deals.Exported = 1 AND (Deals.ExportDate < Deals.EditedDate))) 
        AND Deals.OID > 7534



/*********************************************************
 * Update BatchMonitor
 *********************************************************/
	UPDATE BatchMonitor SET  Status = 'Finished', StepEnd = @StepEnd
	WHERE BatchMonitor.OID = @BatchOID

;
