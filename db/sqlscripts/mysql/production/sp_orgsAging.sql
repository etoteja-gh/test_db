CREATE PROCEDURE `sp_OrgsAging`()
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

DECLARE AgedAsOfDate dateTime;
set AgedAsOfDate = '2008-12-24';

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

UPDATE OrgsCalc SET
OpenPromises = 0,
OpenCredits = 0,
OverDue = 0,
HighestBal = 0,
YTDSales = 0,TotalOpenItems = 0,TotalDue = 0,Aging1   = 0,Aging2   = 0,Aging3   = 0,Aging4   = 0,Aging5   = 0,Aging6   = 0,Aging7   = 0,
Aging8   = 0,Aging9   = 0,Aging10   = 0,
Aging11   = 0,Aging12   = 0,Aging13   = 0,Aging14   = 0,Aging15   = 0,Aging16   = 0,Aging17   = 0,
Aging18   = 0,Aging19   = 0,Aging20   = 0;

-- customer
UPDATE OrgsCalc, Orgs SET
Aging1   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging1Start AND Aging1End  AND  closed=0),
Aging2   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging2Start AND Aging2End AND  closed=0),
Aging3   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging3Start AND Aging3End AND  closed=0),
Aging4   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging4Start AND Aging4End AND  closed=0),
Aging5   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging5Start AND Aging5End AND  closed=0),
Aging6   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging6Start AND Aging6End AND  closed=0),
Aging7   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging7Start AND Aging7End AND closed=0),
Aging8   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging8Start AND Aging8End AND  closed=0),
Aging9   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging9Start AND Aging9End AND  closed=0),
Aging10   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging10Start AND Aging10End AND  closed=0),
Aging11   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging11Start AND Aging11End AND  closed=0),
Aging12   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging12Start AND Aging12End AND  closed=0),
Aging13   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging13Start AND Aging13End AND  closed=0),
Aging14   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging14Start AND Aging14End AND  closed=0),
Aging15   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging15Start AND Aging15End AND  closed=0),
Aging16   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging16Start AND Aging16End AND  closed=0),
Aging17   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging17Start AND Aging17End AND  closed=0),
Aging18   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging18Start AND Aging18End AND  closed=0),
Aging19   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging19Start AND Aging19End AND  closed=0),
Aging20   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging20Start AND Aging20End AND  closed=0),
YTDSales =  (SELECT Sum(Amount) FROM ArDocs WHERE ArDocs.CustID = Orgs.oid and doctype = 'IN' and year(duedate) = year(AgedAsOfDate)),
OpenPromises = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND closed = 0 and statusid=35),
OpenCredits = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND closed = 0 and doctype = 'CM'),
OverDue = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND closed = 0 and duedate < AgedAsOfDate),
-- HighestBal = (SELECT Sum(Amount) FROM ArDocs WHERE ArDocs.CustID = Orgs.oid AND  closed = 0 having sum(amount) > HighestBal),
TotalOpenItems = (SELECT count(oid) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND closed = 0),
TotalDue = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CustID = Orgs.oid AND  closed = 0),
DateofLastCash = (SELECT max(docdate) from ArDocs ArDocs where ArDocs.CustID = Orgs.oid and doctype = 'PA'),
WeightedAvgDaysToPay= (SELECT cast(sum((DATEDIFF(ArDocs.ClosedDate,ArDocs.DocDate) * ArDocs.Amount))/sum(Amount) as DECIMAL(21,5)) FROM ArDocs ArDocs where ArDocs.CustID  = OrgsCalc.oid AND ArDocs.Doctype = 'IN' AND ArDocs.Closed = 1),
AvgDaysToPay= ifnull((SELECT sum((DATEDIFF(ArDocs.ClosedDate,ArDocs.DocDate))) /count(ArDocs.oid) FROM ArDocs ArDocs where ArDocs.CustID  = OrgsCalc.oid AND ArDocs.Doctype = 'IN' AND ArDocs.Closed = 1),0)
WHERE Orgs.OID=OrgsCalc.OID AND 
EXISTS (SELECT * FROM ArDocs ArDocs 
 WHERE ArDocs.CustID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 1;


UPDATE OrgsExt, Orgs SET
LastNotedate = (Select max(Notes.editeddate) from ArDocs ArDocs, Notes where ArDocs.CustID = Orgs.oid and ArDocs.oid = Notes.linkedid),
LastDocDate = (Select max(docdate) from ArDocs ArDocs where ArDocs.CustID = Orgs.oid)
WHERE Orgs.OID=OrgsExt.OID 
AND EXISTS (SELECT * FROM ArDocs ArDocs 
 WHERE ArDocs.CustID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 1;
   
  
-- company
UPDATE OrgsCalc, Orgs SET
Aging1   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging1Start AND Aging1End AND  closed=0),
Aging2   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging2Start AND Aging2End AND  closed=0),
Aging3   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging3Start AND Aging3End AND  closed=0),
Aging4   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging4Start AND Aging4End AND  closed=0),
Aging5   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging5Start AND Aging5End AND  closed=0),
Aging6   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging6Start AND Aging6End AND  closed=0),
Aging7   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging7Start AND Aging7End AND closed=0),
Aging8   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging8Start AND Aging8End AND  closed=0),
Aging9   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging9Start AND Aging9End AND  closed=0),
Aging10   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging10Start AND Aging10End AND  closed=0),
Aging11   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging11Start AND Aging11End AND  closed=0),
Aging12   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging12Start AND Aging12End AND  closed=0),
Aging13   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging13Start AND Aging13End AND  closed=0),
Aging14   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging14Start AND Aging14End AND  closed=0),
Aging15   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging15Start AND Aging15End AND  closed=0),
Aging16   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging16Start AND Aging16End AND  closed=0),
Aging17   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging17Start AND Aging17End AND  closed=0),
Aging18   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging18Start AND Aging18End AND  closed=0),
Aging19   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging19Start AND Aging19End AND  closed=0),
Aging20   = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND DateDiff(AgedAsOfDate,DUEDATE) between Aging20Start AND Aging20End AND  closed=0),
YTDSales =  (SELECT Sum(Amount) FROM ArDocs WHERE ArDocs.CompanyId = Orgs.oid and doctype = 'IN' and year(duedate) = year(AgedAsOfDate)),
OpenPromises = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND closed = 0 and statusid=35),
OpenCredits = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND closed = 0 and doctype = 'CM'),
OverDue = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND closed = 0 and duedate < AgedAsOfDate),
-- HighestBal = (SELECT Sum(Amount) FROM ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND  closed = 0 having sum(amount) > HighestBal),
TotalOpenItems = (SELECT count(oid) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND closed = 0),
TotalDue = (SELECT Sum(Amount) FROM ArDocs ArDocs WHERE ArDocs.CompanyId = Orgs.oid AND  closed = 0),
DateofLastCash = (SELECT max(docdate) from ArDocs ArDocs where ArDocs.CompanyId = Orgs.oid and doctype = 'PA'),
WeightedAvgDaysToPay= (SELECT cast(sum((DATEDIFF(ArDocs.ClosedDate,ArDocs.DocDate) * ArDocs.Amount))/sum(Amount) as DECIMAL(21,5)) FROM ArDocs ArDocs where ArDocs.CompanyId  = OrgsCalc.oid AND ArDocs.Doctype = 'IN' AND ArDocs.Closed = 1),
AvgDaysToPay= ifnull((SELECT sum((DATEDIFF(ArDocs.ClosedDate,ArDocs.DocDate))) /count(ArDocs.oid) FROM ArDocs ArDocs where ArDocs.CompanyId  = OrgsCalc.oid AND ArDocs.Doctype = 'IN' AND ArDocs.Closed = 1),0)
WHERE Orgs.OID=OrgsCalc.OID AND 
EXISTS (SELECT * FROM ArDocs ArDocs 
 WHERE ArDocs.CompanyId = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 12;


UPDATE OrgsExt, Orgs SET
LastNotedate = (Select max(Notes.editeddate) from ArDocs ArDocs, Notes where ArDocs.CompanyId = Orgs.oid and ArDocs.oid = Notes.linkedid),
LastDocDate = (Select max(docdate) from ArDocs ArDocs where ArDocs.CompanyId = Orgs.oid)
WHERE Orgs.OID=OrgsExt.OID 
AND EXISTS (SELECT * FROM ArDocs ArDocs 
 WHERE ArDocs.CompanyID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 12;


UPDATE OrgsCalc Set TotalOpenItems = 0 WHERE TotalOpenItems is null;
UPDATE OrgsCalc Set TotalDue = 0 WHERE TotalDue is null;

UPDATE OrgsCalc Set Aging1 = 0 WHERE Aging1 is null;
UPDATE OrgsCalc Set Aging2 = 0 WHERE Aging2 is null;
UPDATE OrgsCalc Set Aging3 = 0 WHERE Aging3 is null;
UPDATE OrgsCalc Set Aging4 = 0 WHERE Aging4 is null;
UPDATE OrgsCalc Set Aging5 = 0 WHERE Aging5 is null;
UPDATE OrgsCalc Set Aging6 = 0 WHERE Aging6 is null;
UPDATE OrgsCalc Set Aging7 = 0 WHERE Aging7 is null;
UPDATE OrgsCalc Set Aging8 = 0 WHERE Aging8 is null;
UPDATE OrgsCalc Set Aging9 = 0 WHERE Aging9 is null;
UPDATE OrgsCalc Set Aging10 = 0 WHERE Aging10 is null;

UPDATE OrgsCalc Set Aging11 = 0 WHERE Aging11 is null;
UPDATE OrgsCalc Set Aging12 = 0 WHERE Aging12 is null;
UPDATE OrgsCalc Set Aging13 = 0 WHERE Aging13 is null;
UPDATE OrgsCalc Set Aging14 = 0 WHERE Aging14 is null;
UPDATE OrgsCalc Set Aging15 = 0 WHERE Aging15 is null;
UPDATE OrgsCalc Set Aging16 = 0 WHERE Aging16 is null;
UPDATE OrgsCalc Set Aging17 = 0 WHERE Aging17 is null;
UPDATE OrgsCalc Set Aging18 = 0 WHERE Aging18 is null;
UPDATE OrgsCalc Set Aging19 = 0 WHERE Aging19 is null;
UPDATE OrgsCalc Set Aging20 = 0 WHERE Aging20 is null;

END;
