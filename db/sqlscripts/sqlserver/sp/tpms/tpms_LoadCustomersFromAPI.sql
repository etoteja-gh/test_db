SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_LoadCustomersFromAPI] AS

/*********************************
 * sp_TPMS_LoadCustomersFromAPI   
 * Load Customers table from APICustomers
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
VALUES (@BatchOID, @BatchStart, 'LoadCustomersFromAPI', GetDate(), 'Running')
 
/*********************************************************
 *  
 *********************************************************/



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

