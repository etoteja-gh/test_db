CREATE PROCEDURE `sp_ArScoreCard`()
BEGIN
DECLARE Aging1Start varchar(10);
DECLARE Aging1End   varchar(10);
DECLARE Aging2Start varchar(10);
DECLARE Aging2End   varchar(10);
DECLARE Aging3Start varchar(10);
DECLARE Aging3End   varchar(10);
DECLARE Aging4Start varchar(10);
DECLARE Aging4End   varchar(10);
DECLARE Aging5Start varchar(10);
DECLARE Aging5End   varchar(10);
DECLARE Aging6Start varchar(10);
DECLARE Aging6End   varchar(10);
DECLARE Aging7Start varchar(10);
DECLARE Aging7End   varchar(10);
DECLARE Aging8Start varchar(10);
DECLARE Aging8End   varchar(10);
DECLARE Aging9Start varchar(10);
DECLARE Aging9End   varchar(10);
DECLARE Aging10Start varchar(10);
DECLARE Aging10End   varchar(10);
DECLARE Aging11Start varchar(10);
DECLARE Aging11End   varchar(10);
DECLARE Aging12Start varchar(10);
DECLARE Aging12End   varchar(10);
DECLARE Aging13Start varchar(10);
DECLARE Aging13End   varchar(10);
DECLARE Aging14Start varchar(10);
DECLARE Aging14End   varchar(10);
DECLARE Aging15Start varchar(10);
DECLARE Aging15End   varchar(10);
DECLARE Aging16Start varchar(10);
DECLARE Aging16End   varchar(10);
DECLARE Aging17Start varchar(10);
DECLARE Aging17End   varchar(10);
DECLARE Aging18Start varchar(10);
DECLARE Aging18End   varchar(10);
DECLARE Aging19Start varchar(10);
DECLARE Aging19End   varchar(10);
DECLARE Aging20Start varchar(10);
DECLARE Aging20End   varchar(10);
DECLARE period varchar(10);
DECLARE closingdate_date dateTime; -- post period closing date
DECLARE ClosingDateVarchar varchar(30); -- converted date value into varchar. Quick work around
DECLARE begDate_date dateTime; -- post period begin date (needed for DSO)
DECLARE begDateVarchar varchar(30); -- converted date value into varchar. Quick work around
DECLARE linkedID   varchar (20);
DECLARE linkedType   varchar (5);

 DECLARE DONE INT DEFAULT 0;
 

/*loop through period to post table, RUNS ALL CLOSED POST PERIODS AND THE CURRENT ONE - GOOD FOR THE FIRST LOAD */
 DECLARE period_cursor CURSOR FOR 
    SELECT name, cast(closingdate as char), cast(begdate as char)
    FROM PeriodToPost 
    where isclosed=1 
    or oid in 
    (select min(oid) from PeriodToPost where isclosed=0);
    
-- RUNS ONLY THE MOST RECENT CLOSED AND CURRENT POST PERIOD - GOOD FOR DAILY LOADS
/*
SELECT name,  closingdate , begdate
FROM PeriodToPost 
where oid in 
((select min(oid) from PeriodToPost where isclosed=0), (select max(oid) from PeriodToPost where isclosed=1))
*/

/*loop through orgs table for customers */
DECLARE linkedID_cursor CURSOR FOR 
	SELECT cast(oid as char), cast(orgtype as char) FROM Orgs where orgtype in (1,12);

 DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE=1;

 
Set Aging1Start = (SELECT StartDay FROM CfgAging WHERE OID = 1);
Set Aging1End =   (SELECT EndDay FROM   CfgAging WHERE OID = 1);
Set Aging2Start = (SELECT StartDay FROM CfgAging WHERE OID = 2);
Set Aging2End =   (SELECT EndDay FROM   CfgAging WHERE OID = 2);
Set Aging3Start = (SELECT StartDay FROM CfgAging WHERE OID = 3);
Set Aging3End =   (SELECT EndDay FROM   CfgAging WHERE OID = 3);
Set Aging4Start = (SELECT StartDay FROM CfgAging WHERE OID = 4);
Set Aging4End =   (SELECT EndDay FROM   CfgAging WHERE OID = 4);
Set Aging5Start = (SELECT StartDay FROM CfgAging WHERE OID = 5);
Set Aging5End =   (SELECT EndDay FROM   CfgAging WHERE OID = 5);
Set Aging6Start = (SELECT StartDay FROM CfgAging WHERE OID = 6);
Set Aging6End =   (SELECT EndDay FROM   CfgAging WHERE OID = 6);
Set Aging7Start = (SELECT StartDay FROM CfgAging WHERE OID = 7);
Set Aging7End =   (SELECT EndDay FROM   CfgAging WHERE OID = 7);
Set Aging8Start = (SELECT StartDay FROM CfgAging WHERE OID = 8);
Set Aging8End =   (SELECT EndDay FROM   CfgAging WHERE OID = 8);
Set Aging9Start = (SELECT StartDay FROM CfgAging WHERE OID = 9);
Set Aging9End =   (SELECT EndDay FROM   CfgAging WHERE OID = 9);
Set Aging10Start = (SELECT StartDay FROM CfgAging WHERE OID = 10);
Set Aging10End =   (SELECT EndDay FROM   CfgAging WHERE OID = 10);
Set Aging11Start = (SELECT StartDay FROM CfgAging WHERE OID = 11);
Set Aging11End =   (SELECT  EndDay FROM  CfgAging WHERE OID = 11);
Set Aging12Start = (SELECT StartDay FROM CfgAging WHERE OID = 12);
Set Aging12End =   (SELECT EndDay FROM   CfgAging WHERE OID = 12);
Set Aging13Start = (SELECT StartDay FROM CfgAging WHERE OID = 13);
Set Aging13End =   (SELECT EndDay FROM   CfgAging WHERE OID = 13);
Set Aging14Start = (SELECT StartDay FROM CfgAging WHERE OID = 14);
Set Aging14End =   (SELECT EndDay FROM   CfgAging WHERE OID = 14);
Set Aging15Start = (SELECT StartDay FROM CfgAging WHERE OID = 15);
Set Aging15End =   (SELECT EndDay FROM   CfgAging WHERE OID = 15);
Set Aging16Start = (SELECT StartDay FROM CfgAging WHERE OID = 16);
Set Aging16End =   (SELECT EndDay FROM   CfgAging WHERE OID = 16);
Set Aging17Start = (SELECT StartDay FROM CfgAging WHERE OID = 17);
Set Aging17End =   (SELECT EndDay FROM   CfgAging WHERE OID = 17);
Set Aging18Start = (SELECT StartDay FROM CfgAging WHERE OID = 18);
Set Aging18End =   (SELECT EndDay FROM   CfgAging WHERE OID = 18);
Set Aging19Start = (SELECT StartDay FROM CfgAging WHERE OID = 19);
Set Aging19End =   (SELECT EndDay FROM   CfgAging WHERE OID = 19);
Set Aging20Start = (SELECT StartDay FROM CfgAging WHERE OID = 20);
Set Aging20End =   (SELECT EndDay FROM   CfgAging WHERE OID = 20);

OPEN period_cursor;

REPEAT
FETCH period_cursor INTO period, ClosingDateVarchar, begDateVarchar;
IF NOT done THEN 

	  OPEN linkedID_cursor;
    REPEAT
	  FETCH linkedID_cursor into linkedID, linkedType;
      IF NOT done THEN 

         -- inserts rows to ArScoreCard table for this post period for all customers
        INSERT INTO ArScoreCard
          (PeriodToPost, LinkedID, LinkedType, LinkedTable ) 
        VALUES(period,linkedID,linkedType,'Orgs');
	
      END IF; 

	  UNTIL done END REPEAT; 
    CLOSE linkedID_cursor;
    
  SET done = 0; 
-- updates values in ArScoreCard table for this period
UPDATE ArScoreCard, Orgs SET
Aging1   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) <= Aging1End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging2Start AND Aging2End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging3Start AND Aging3End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging4Start AND Aging4End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging5Start AND Aging5End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging6Start AND Aging6End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(DUEDATE, ClosingDateVarchar) between  Aging7Start AND Aging7End AND docdate< ClosingDateVarchar and (closeddate> ClosingDateVarchar or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging8Start AND Aging8End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging9Start AND Aging9End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging10Start AND Aging10End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging11Start AND Aging11End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging12Start AND Aging12End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging13Start AND Aging13End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging14Start AND Aging14End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging15Start AND Aging15End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging16Start AND Aging16End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging17Start AND Aging17End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging18Start AND Aging18End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging19Start AND Aging19End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(ClosingDateVarchar,DUEDATE) between Aging20Start AND Aging20End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0))
WHERE ArScoreCard.LinkedID=Orgs.oid
AND ArScoreCard.LinkedTable='Orgs'
and Orgs.orgtype = 1
and ArScoreCard.PeriodToPost=period;



UPDATE ArScoreCard, Orgs SET
AvgDaysToPay=round((Select cast(sum(DATEDIFF( AR.ClosedDate,AR.DocDate)) / count(AR.OID) as DECIMAL(21,5)) FROM ArDocs AR where CustID  = Orgs.oid AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND AR.Closed = 1)/2,2), -- FIXME - somehow value is too high
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(AR.ClosedDate, AR.DueDate)) / count(AR.OID) as DECIMAL(21,5)) FROM ArDocs AR where CustID  = Orgs.oid AND Doctype = 'IN' AND duedate<ClosingDateVarchar AND duedate<closeddate AND closeddate<ClosingDateVarchar AND AR.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF( AR.ClosedDate, AR.DocDate)) FROM ArDocs AR 	where CustID  = Orgs.oid AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND Closed = 1),
WeightedAvgDaysToPay=(Select cast(sum((DATEDIFF( AR.ClosedDate, AR.DocDate) * AR.OrigAmount))/sum(OrigAmount) as DECIMAL(21,5)) FROM ArDocs AR where CustID  = Orgs.oid AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND Closed = 1),
-- BrokenPromisesAmount=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateadjusted<ClosingDateVarchar AND docdate<ClosingDateVarchar AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
-- BrokenPromisesCount=(SELECT Count(PP.oid) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateadjusted<ClosingDateVarchar AND docdate<ClosingDateVarchar AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
ArScoreCard.Currency=(select Orgs.currency),
DiscAmount=(SELECT Sum(DiscAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalCount=(SELECT Count(OID) FROM ArDocs AR WHERE CustID  = Orgs.oid AND docdate<ClosingDateVarchar),
TotalOpenItems=(SELECT Count(OID) FROM ArDocs AR WHERE CustID  = Orgs.oid AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalDue=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalOpened=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid  AND docdate<ClosingDateVarchar and docdate >begDateVarchar),
TotalClosed=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid  AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
OverDue=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND duedate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0))
WHERE  ArScoreCard.LinkedID=Orgs.oid
AND ArScoreCard.LinkedTable='Orgs'
and Orgs.orgtype = 1
and ArScoreCard.PeriodToPost=period;

UPDATE ArScoreCard, Orgs SET
OpenCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'CM' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'IN' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'DM' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND reasonid>0 AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'PA' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
-- OpenPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateAdjusted<ClosingDateVarchar  AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'CM' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'IN' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'DM' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'DD' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewPayments = (SELECT Sum(OrigAmount) FROM ArDocs ARD WHERE CustID  = Orgs.oid AND doctype = 'PA' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
-- NewPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.adjusterDocDate<ClosingDateVarchar and PP.adjusterDocDate > begDateVarchar),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'CM' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'IN' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'DM' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'DD' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE CustID  = Orgs.oid AND doctype = 'PA' AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
-- ClosedPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.adjusterDocDate<ClosingDateVarchar AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
YTDSales = (SELECT Sum(Origamount) FROM ArDocs AR WHERE CustID = Orgs.oid and doctype = 'IN' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDInvoices = (SELECT Sum(Origamount) FROM ArDocs AR WHERE CustID = Orgs.oid and doctype = 'CM' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDDebits = (SELECT Sum(Origamount) FROM ArDocs AR WHERE CustID = Orgs.oid and doctype = 'DM' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDDeductions = (SELECT Sum(Origamount) FROM ArDocs AR WHERE CustID = Orgs.oid and doctype = 'DD' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDPayments = (SELECT Sum(Origamount) FROM ArDocs AR WHERE CustID = Orgs.oid and doctype = 'PA' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar)
-- YTDPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND  year(adjusterdocdate)=left(period,4) and adjusterdocdate<ClosingDateVarchar)
WHERE  ArScoreCard.LinkedID=Orgs.oid
AND ArScoreCard.LinkedTable='Orgs'
and Orgs.orgtype = 1
and ArScoreCard.PeriodToPost=period;


UPDATE ArScoreCard  SET
Aging1   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and DateDiff(ClosingDateVarchar,DUEDATE) <= Aging1End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging2Start AND Aging2End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging3Start AND Aging3End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging4Start AND Aging4End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging5Start AND Aging5End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging6Start AND Aging6End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(DUEDATE, ClosingDateVarchar) between  Aging7Start AND Aging7End AND docdate< ClosingDateVarchar and (closeddate> ClosingDateVarchar or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging8Start AND Aging8End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging9Start AND Aging9End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging10Start AND Aging10End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging11Start AND Aging11End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging12Start AND Aging12End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging13Start AND Aging13End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging14Start AND Aging14End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging15Start AND Aging15End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and  DateDiff(ClosingDateVarchar,DUEDATE) between Aging16Start AND Aging16End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging17Start AND Aging17End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging18Start AND Aging18End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging19Start AND Aging19End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ArDocs ArDocs WHERE  ArDocs.CompanyId=ArScoreCard.LinkedId and   DateDiff(ClosingDateVarchar,DUEDATE) between Aging20Start AND Aging20End AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0))
WHERE ArScoreCard.LinkedType=12
AND ArScoreCard.LinkedTable='Orgs'
and ArScoreCard.PeriodToPost=period;

UPDATE ArScoreCard SET
AvgDaysToPay=round((Select cast(sum(DATEDIFF( AR.ClosedDate,AR.DocDate)) / count(AR.OID) as DECIMAL(21,5)) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND AR.Closed = 1)/2,2),
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(AR.ClosedDate, AR.DueDate)) / count(AR.OID) as DECIMAL(21,5)) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND Doctype = 'IN' AND duedate<ClosingDateVarchar AND duedate<closeddate AND closeddate<ClosingDateVarchar AND AR.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF( AR.ClosedDate, AR.DocDate)) FROM ArDocs AR 	WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND Closed = 1),
WeightedAvgDaysToPay=(Select cast(sum((DATEDIFF( AR.ClosedDate, AR.DocDate) * AR.OrigAmount))/sum(OrigAmount) as DECIMAL(21,5)) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND Doctype = 'IN' AND docdate<ClosingDateVarchar AND closeddate<ClosingDateVarchar AND Closed = 1),
-- BrokenPromisesAmount=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId and PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateadjusted<ClosingDateVarchar AND docdate<ClosingDateVarchar AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
-- BrokenPromisesCount=(SELECT Count(PP.oid) FROM ArAdjust PP, ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId and PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateadjusted<ClosingDateVarchar AND docdate<ClosingDateVarchar AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
DiscAmount=(SELECT Sum(DiscAmount) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalCount=(SELECT Count(OID) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND docdate<ClosingDateVarchar),
TotalOpenItems=(SELECT Count(OID) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalDue=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
TotalOpened=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId   AND docdate<ClosingDateVarchar and docdate >begDateVarchar),
TotalClosed=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId   AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
OverDue=(SELECT Sum(OrigAmount) FROM ArDocs AR WHERE  AR.CompanyId=ArScoreCard.LinkedId  AND duedate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0))
WHERE ArScoreCard.LinkedType=12
AND ArScoreCard.LinkedTable='Orgs'
and ArScoreCard.PeriodToPost=period;

UPDATE ArScoreCard SET
OpenCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'CM' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'IN' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'DM' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND reasonid>0 AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'PA' AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
-- OpenPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.dateAdjusted<ClosingDateVarchar  AND docdate<ClosingDateVarchar and (closeddate>ClosingDateVarchar or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'CM' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'IN' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'DM' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'DD' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
NewPayments = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'PA' AND docdate<ClosingDateVarchar and docdate > begDateVarchar),
-- NewPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CustID = Orgs.oid AND PP.adjusterDocDate<ClosingDateVarchar and PP.adjusterDocDate > begDateVarchar),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'CM' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'IN' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'DM' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'DD' AND closeddate<ClosingDateVarchar and closeddate > begDateVarchar),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId AND doctype = 'PA' AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
-- ClosedPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CompanyId=ArScoreCard.LinkedId AND PP.adjusterDocDate<ClosingDateVarchar AND closeddate<ClosingDateVarchar and closeddate>begDateVarchar),
YTDSales = (SELECT Sum(Origamount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId and doctype = 'IN' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDInvoices = (SELECT Sum(Origamount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId and doctype = 'CM' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDDebits = (SELECT Sum(Origamount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId and doctype = 'DM' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDDeductions = (SELECT Sum(Origamount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId and doctype = 'DD' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar),
YTDPayments = (SELECT Sum(Origamount) FROM ArDocs AR WHERE AR.CompanyId=ArScoreCard.LinkedId and doctype = 'PA' AND year(docdate)=left(period,4) and docdate<ClosingDateVarchar)
-- YTDPromises=(SELECT Sum(PP.adjusteramount) FROM ArAdjust PP, ArDocs AR where PP.adjusterdoctype = 'PP' and PP.adjustedoid = ar.oid AND AR.CompanyId=ArScoreCard.LinkedId AND  year(adjusterdocdate)=left(period,4) and adjusterdocdate<ClosingDateVarchar)
WHERE ArScoreCard.LinkedType=12
AND ArScoreCard.LinkedTable='Orgs'
and ArScoreCard.PeriodToPost=period;

UPDATE ArScoreCard SET
DSO=round((Select TotalDue/NewInvoices*DATEDIFF(ClosingDateVarchar,BegDateVarchar)),2),
DSOBP=round((Select Aging8/NewInvoices*DATEDIFF(ClosingDateVarchar,begDateVarchar)),2),
DSOAD=round((Select DSO-DSOBP),2),
BeginBalance=round((Select ifnull(TotalDue,0)-ifnull(TotalOpened,0)+ifnull(TotalClosed,0)),2),
CEI=round(((Select BeginBalance+NewInvoices-TotalDue)/(BeginBalance+NewInvoices-Aging8)*100),2);
END IF; 
UNTIL done END REPEAT; 
CLOSE period_cursor;

UPDATE ArScoreCard set createddate=now(), editeddate=now();

END;
