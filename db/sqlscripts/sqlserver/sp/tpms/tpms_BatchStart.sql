CREATE PROCEDURE [dbo].[tpms_BatchStart] AS

/******************************************
 * Update Batch Monitor Table
 ******************************************/
/* Set OID values for Batch Monitor  */
DECLARE @BatchOID int
DECLARE @OID int
DECLARE @BatchStart smalldatetime

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
SET @BatchStart = GetDate()


INSERT INTO BatchMonitor (OID, BatchStart, BatchStep, StepStart, Status)
VALUES (@BatchOID, @BatchStart, 'TPMS-Batch Start', GetDate(), 'Running')

;
