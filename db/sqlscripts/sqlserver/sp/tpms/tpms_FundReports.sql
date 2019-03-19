SET QUOTED_IDENTIFIER ON 
;
SET ANSI_NULLS ON 
;

CREATE PROCEDURE [dbo].[tpms_FundReports] AS

/*********************************
 * sp_TPMS_FundReports    
 * Load FundReports table
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
VALUES (@BatchOID, @BatchStart, 'Fund Reports', GetDate(), 'Running')
 

/************************************************
 * Load FundReports table
 ************************************************/
TRUNCATE TABLE FundReports

INSERT INTO FundReports (Fund, FundID, Customer, CustID, Product, ProdID, 
            FinYear, FinPer, Period, PLN, PGL, EGL, REBATE, ADJ, PND, APP, ACT)
SELECT FundMaster.Name, Funds.FundID, Orgs.Name, Funds.CustID, Products.Name, Funds.ProdID,
 FundMaster.FundYear, FundMaster.FundPeriod, Funds.Period,
SUM(CASE FundDataTypeID WHEN 1 THEN Amount ELSE 0 END) AS PLN,
SUM(CASE FundDataTypeID WHEN 4 THEN Amount ELSE 0 END) AS PGL,
SUM(CASE FundDataTypeID WHEN 5 THEN Amount ELSE 0 END) AS EGL,
SUM(CASE FundDataTypeID WHEN 6 THEN Amount ELSE 0 END) AS REBATE,
SUM(CASE FundDataTypeID WHEN 12 THEN Amount ELSE 0 END) AS ADJ,
SUM(CASE FundDataTypeID WHEN 8 THEN Amount ELSE 0 END) AS PND,
SUM(CASE FundDataTypeID WHEN 9 THEN Amount ELSE 0 END) AS APP,
SUM(CASE FundDataTypeID WHEN 7 THEN Amount ELSE 0 END) AS ACT
FROM Funds, FundMaster, Customers, Products, Orgs
WHERE CustID = Customers.OID 
  AND Customers.OrgsID = Orgs.OID 
  AND ProdID = Products.OID 
  AND FundID = FundMaster.OID
GROUP BY FundMaster.Name, Funds.FundID, Orgs.Name, Funds.CustID, Products.Name, Funds.ProdID,
         FundMaster.FundYear, FundMaster.FundPeriod, Funds.Period

UPDATE FundReports SET
BudActPct = 
	CASE
		WHEN EGL >= PGL and (PLN + EGL + REBATE + ADJ)<> 0 THEN ((ACT/ (PLN + EGL + REBATE + ADJ)) * 100)
		WHEN PGL > EGL and (PLN + PGL + REBATE + ADJ)<> 0 THEN ((ACT/ (PLN + PGL + REBATE + ADJ)) * 100)
		ELSE 0
		END,
Budget = 
	CASE
		WHEN EGL >= PGL THEN PLN + EGL + REBATE + ADJ
		WHEN PGL > EGL THEN PLN + PGL + REBATE + ADJ
		ELSE 0
		END,
PlanSpend = PND + APP,
Avail = 
	CASE
		WHEN EGL >= PGL THEN (PLN + EGL + REBATE + ADJ) - (PND + APP + ACT)
		WHEN PGL > EGL THEN (PLN + PGL + REBATE + ADJ) - (PND + APP + ACT) 
		ELSE 0
		END

UPDATE FundReports SET
BudPlnSpendPct = 
  CASE WHEN Budget <> 0 THEN (PlanSpend/Budget) * 100 ELSE 0 END

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

