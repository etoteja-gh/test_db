--truncate table arscorecard
--select * from arscorecard
/**Generates ARScoreCard table with history aging for each customer per historical
period to post.
*/
CREATE    procedure [dbo].[dcs_ArScoreCard] as
/*
DECLARE @Aging1Start varchar(10)
DECLARE @Aging1End   varchar(10)
DECLARE @Aging2Start varchar(10)
DECLARE @Aging2End   varchar(10)
DECLARE @Aging3Start varchar(10)
DECLARE @Aging3End   varchar(10)
DECLARE @Aging4Start varchar(10)
DECLARE @Aging4End   varchar(10)
DECLARE @Aging5Start varchar(10)
DECLARE @Aging5End   varchar(10)
DECLARE @Aging6Start varchar(10)
DECLARE @Aging6End   varchar(10)
DECLARE @Aging7Start varchar(10)
DECLARE @Aging7End   varchar(10)
DECLARE @Aging8Start varchar(10)
DECLARE @Aging8End   varchar(10)
DECLARE @Aging9Start varchar(10)
DECLARE @Aging9End   varchar(10)
DECLARE @Aging10Start varchar(10)
DECLARE @Aging10End   varchar(10)

DECLARE @Aging11Start varchar(10)
DECLARE @Aging11End   varchar(10)
DECLARE @Aging12Start varchar(10)
DECLARE @Aging12End   varchar(10)
DECLARE @Aging13Start varchar(10)
DECLARE @Aging13End   varchar(10)
DECLARE @Aging14Start varchar(10)
DECLARE @Aging14End   varchar(10)
DECLARE @Aging15Start varchar(10)
DECLARE @Aging15End   varchar(10)
DECLARE @Aging16Start varchar(10)
DECLARE @Aging16End   varchar(10)
DECLARE @Aging17Start varchar(10)
DECLARE @Aging17End   varchar(10)
DECLARE @Aging18Start varchar(10)
DECLARE @Aging18End   varchar(10)
DECLARE @Aging19Start varchar(10)
DECLARE @Aging19End   varchar(10)
DECLARE @Aging20Start varchar(10)
DECLARE @Aging20End   varchar(10)

DECLARE @period varchar(10)
DECLARE @closingdate_date smallDateTime -- post period closing date
DECLARE @closingdate varchar(30) -- converted date value into varchar. Quick work around
DECLARE @begDate_date smallDateTime -- post period begin date (needed for DSO)
DECLARE @begDate varchar(30) -- converted date value into varchar. Quick work around


DECLARE @linkedID   varchar (20)
DECLARE @linkedType   varchar (5)
DECLARE @updatesystem varchar(100)

DECLARE @insert varchar(8000)
DECLARE @updateCustAging varchar(8000)
DECLARE @updateBusAging varchar(8000)
DECLARE @updateFactoryAging varchar(8000)
DECLARE @updateParentAging varchar(8000)
DECLARE @updateSalesAging varchar(8000)
DECLARE @updateCorpAging varchar(8000)

DECLARE @updateCustOpenNewClosedYTD varchar(8000)
DECLARE @updateBusOpenNewClosedYTD varchar(8000)
DECLARE @updateFactoryOpenNewClosedYTD varchar(8000)
DECLARE @updateParentOpenNewClosedYTD varchar(8000)
DECLARE @updateSalesOpenNewClosedYTD varchar(8000)
DECLARE @updateCorpOpenNewClosedYTD varchar(8000)

DECLARE @updateCustOther varchar(8000)
DECLARE @updateBusOther varchar(8000)
DECLARE @updateFactoryOther varchar(8000)
DECLARE @updateParentOther varchar(8000)
DECLARE @updateSalesOther varchar(8000)
DECLARE @updateCorpOther varchar(8000)


DECLARE @DSO varchar(1000)


DECLARE @Error       int

Set @Aging1End =   (SELECT  EndDay FROM  CFGAging WHERE OID = 1)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging2Start = (SELECT StartDay FROM CFGAging WHERE OID = 2)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging2End =   (SELECT EndDay FROM   CFGAging WHERE OID = 2)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging3Start = (SELECT StartDay FROM CFGAging WHERE OID = 3)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging3End =   (SELECT EndDay FROM   CFGAging WHERE OID = 3)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging4Start = (SELECT StartDay FROM CFGAging WHERE OID = 4)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging4End =   (SELECT EndDay FROM   CFGAging WHERE OID = 4)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging5Start = (SELECT StartDay FROM CFGAging WHERE OID = 5)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging5End =   (SELECT EndDay FROM   CFGAging WHERE OID = 5)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging6Start = (SELECT StartDay FROM CFGAging WHERE OID = 6)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging6End =   (SELECT EndDay FROM   CFGAging WHERE OID = 6)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging7Start = (SELECT StartDay FROM CFGAging WHERE OID = 7)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging7End =   (SELECT EndDay FROM   CFGAging WHERE OID = 7)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging8Start = (SELECT StartDay FROM CFGAging WHERE OID = 8)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging8End =   (SELECT EndDay FROM   CFGAging WHERE OID = 8)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging9Start = (SELECT StartDay FROM CFGAging WHERE OID = 9)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging9End =   (SELECT EndDay FROM   CFGAging WHERE OID = 9)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging10Start = (SELECT StartDay FROM CFGAging WHERE OID = 10)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging10End =   (SELECT EndDay FROM   CFGAging WHERE OID = 10)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging11Start = (SELECT StartDay FROM CFGAging WHERE OID = 11)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging11End =   (SELECT  EndDay FROM  CFGAging WHERE OID = 11)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging12Start = (SELECT StartDay FROM CFGAging WHERE OID = 12)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging12End =   (SELECT EndDay FROM   CFGAging WHERE OID = 12)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging13Start = (SELECT StartDay FROM CFGAging WHERE OID = 13)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging13End =   (SELECT EndDay FROM   CFGAging WHERE OID = 13)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging14Start = (SELECT StartDay FROM CFGAging WHERE OID = 14)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging14End =   (SELECT EndDay FROM   CFGAging WHERE OID = 14)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging15Start = (SELECT StartDay FROM CFGAging WHERE OID = 15)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging15End =   (SELECT EndDay FROM   CFGAging WHERE OID = 15)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging16Start = (SELECT StartDay FROM CFGAging WHERE OID = 16)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging16End =   (SELECT EndDay FROM   CFGAging WHERE OID = 16)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging17Start = (SELECT StartDay FROM CFGAging WHERE OID = 17)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging17End =   (SELECT EndDay FROM   CFGAging WHERE OID = 17)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging18Start = (SELECT StartDay FROM CFGAging WHERE OID = 18)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging18End =   (SELECT EndDay FROM   CFGAging WHERE OID = 18)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging19Start = (SELECT StartDay FROM CFGAging WHERE OID = 19)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging19End =   (SELECT EndDay FROM   CFGAging WHERE OID = 19)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging20Start = (SELECT StartDay FROM CFGAging WHERE OID = 20)IF (@@ERROR <> 0) Set @Error = @@Error
Set @Aging20End =   (SELECT EndDay FROM   CFGAging WHERE OID = 20)IF (@@ERROR <> 0) Set @Error = @@Error


DECLARE period_cursor CURSOR FOR -- loop through period to post table
-- RUNS ALL CLOSED POST PERIODS AND THE CURRENT ONE - GOOD FOR THE FIRST LOAD
SELECT name,  closingdate , begdate
FROM PeriodToPost 
where isclosed=1 
or oid in 
(select min(oid) from periodtopost where isclosed=0)

-- RUNS ONLY THE MOST RECENT CLOSED AND CURRENT POST PERIOD - GOOD FOR DAILY LOADS
/*
SELECT name,  closingdate , begdate
FROM PeriodToPost 
where oid in 
((select min(oid) from periodtopost where isclosed=0), (select max(oid) from periodtopost where isclosed=1))
*/

OPEN period_cursor

fetch next from period_cursor into @period,  @closingdate_date, @BegDate_date
  while @@FETCH_STATUS = 0 begin

--print (@period + ' --> '+ @begdate_date + ' - ' +@closingdate_date)


set @closingdate=''''+cast(@closingdate_date as varchar(20))+''''
set @begdate=''''+cast(@begdate_date as varchar(20))+''''


----------------------- LINKEDID CURSOR -----------------------------------------
	DECLARE linkedID_cursor CURSOR FOR -- loop through orgs table for customers
	SELECT cast(oid as varchar(20)), cast(orgtype as varchar(5)) FROM Orgs

	OPEN linkedID_cursor

	fetch next from linkedID_cursor into @linkedID, @linkedType
  	while @@FETCH_STATUS = 0 begin
	--print (@linkedID)
	--exec (@linkedID)

	-- inserts rows to ARScorecard table for this post period for all customers
	set @insert='INSERT INTO [ArScoreCard](PeriodToPost, LinkedID, LinkedType, LinkedTable ) VALUES('+@period+','+@linkedID+','+@linkedType+',''Orgs'''+')'
	exec (@insert)

	fetch next from linkedID_cursor into @linkedID, @linkedType end
	close linkedID_cursor
	deallocate linkedID_cursor;	
------------------------LINKEDID CURSOR ENDS ------------------------------------------

-- updates values in ARScoreCard table for this period
set @updateCustAging=
'UPDATE ARScoreCard SET
Aging1   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') <= '+@Aging1End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging2Start+' AND '+@Aging2End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging3Start+' AND '+@Aging3End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging4Start+' AND '+@Aging4End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging5Start+' AND '+@Aging5End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging6Start+' AND '+@Aging6End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE, '+@ClosingDate+') between  '+@Aging7Start+' AND '+@Aging7End+' AND docdate< '+@ClosingDate+' and (closeddate> '+@ClosingDate+' or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging8Start+' AND '+@Aging8End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging9Start+' AND '+@Aging9End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging10Start+' AND '+@Aging10End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging11Start+' AND '+@Aging11End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging12Start+' AND '+@Aging12End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging13Start+' AND '+@Aging13End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging14Start+' AND '+@Aging14End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging15Start+' AND '+@Aging15End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging16Start+' AND '+@Aging16End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging17Start+' AND '+@Aging17End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging18Start+' AND '+@Aging18End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging19Start+' AND '+@Aging19End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging20Start+' AND '+@Aging20End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 1
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateCustAging)

set @updateCustOther=
'UPDATE ARScoreCard SET
AvgDaysToPay=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs where ARDocs.CustID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(day, ARDocs.DueDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs where ARDocs.CustID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND duedate<'+@ClosingDate+' AND duedate<closeddate AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) FROM ARDocs ARDocs 	where ARDocs.CustID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
WeightedAvgDaysToPay=(Select sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount))/sum(OrigAmount) FROM ARDocs ARDocs where ARDocs.CustID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
BrokenPromisesAmount=(SELECT Sum(PP.adjusteramount) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND PP.dateadjusted<'+@ClosingDate+' AND docdate<'+@ClosingDate+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
BrokenPromisesCount=(SELECT Count(PP.oid) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND PP.dateadjusted<'+@ClosingDate+' AND docdate<'+@ClosingDate+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Currency=(select Orgs.currency),
DiscAmount=(SELECT Sum(DiscAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalCount=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND docdate<'+@ClosingDate+'),
TotalOpenItems=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalOpened=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid  AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
TotalClosed=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid  AND closeddate<'+@ClosingDate+' and closeddate>'+@BegDate+'),
OverDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND duedate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard 
WHERE  ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 1
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateCustOther)

set @updateCustOpenNewClosedYTD=
'UPDATE ARScoreCard SET
OpenCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''CM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''IN'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DD'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''PA'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenPromises=(SELECT Sum(PP.adjusteramount) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND PP.dateAdjusted<'+@ClosingDate+'  AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''CM'' AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
NewInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''IN'' AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
NewDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DM'' AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
NewDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DD'' AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
NewPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''PA'' AND docdate<'+@ClosingDate+' and docdate > '+@BegDate+'),
NewPromises=(SELECT Sum(PP.adjusteramount) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND PP.adjusterDocDate<'+@ClosingDate+' and PP.adjusterDocDate > '+@BegDate+'),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''CM'' AND closeddate<'+@ClosingDate+' and closeddate > '+@BegDate+'),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''IN'' AND closeddate<'+@ClosingDate+' and closeddate > '+@BegDate+'),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DM'' AND closeddate<'+@ClosingDate+' and closeddate > '+@BegDate+'),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''DD'' AND closeddate<'+@ClosingDate+' and closeddate > '+@BegDate+'),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.CustID  = Orgs.oid AND doctype = ''PA'' AND closeddate<'+@ClosingDate+' and closeddate>'+@BegDate+'),
ClosedPromises=(SELECT Sum(PP.adjusteramount) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND PP.adjusterDocDate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' and closeddate>'+@BegDate+'),
YTDSales = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = ''IN'' AND year(docdate)='+left(@period,4)+' and docdate<'+@ClosingDate+'),
YTDInvoices = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = ''CM'' AND year(docdate)='+left(@period,4)+' and docdate<'+@ClosingDate+'),
YTDDebits = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = ''DM'' AND year(docdate)='+left(@period,4)+' and docdate<'+@ClosingDate+'),
YTDDeductions = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = ''DD'' AND year(docdate)='+left(@period,4)+' and docdate<'+@ClosingDate+'),
YTDPayments = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = ''PA'' AND year(docdate)='+left(@period,4)+' and docdate<'+@ClosingDate+'),
YTDPromises=(SELECT Sum(PP.adjusteramount) FROM ARAdjust PP, ARDOCS ARDOCS where PP.adjusterdoctype = ''PP'' and PP.adjustedoid = ardocs.oid AND ARDocs.CustID = Orgs.oid AND  year(adjusterdocdate)='+left(@period,4)+' and adjusterdocdate<'+@ClosingDate+')
FROM Orgs Orgs, ARScoreCard ARScoreCard 
WHERE  ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 1
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateCustOpenNewClosedYTD)

set @updateBusAging=
'UPDATE ARScoreCard SET
Aging1   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') <= '+@Aging1End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging2Start+' AND '+@Aging2End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging3Start+' AND '+@Aging3End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging4Start+' AND '+@Aging4End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging5Start+' AND '+@Aging5End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging6Start+' AND '+@Aging6End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE, '+@ClosingDate+') between  '+@Aging7Start+' AND '+@Aging7End+' AND docdate< '+@ClosingDate+' and (closeddate> '+@ClosingDate+' or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging8Start+' AND '+@Aging8End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging9Start+' AND '+@Aging9End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging10Start+' AND '+@Aging10End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging11Start+' AND '+@Aging11End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging12Start+' AND '+@Aging12End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging13Start+' AND '+@Aging13End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging14Start+' AND '+@Aging14End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging15Start+' AND '+@Aging15End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging16Start+' AND '+@Aging16End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging17Start+' AND '+@Aging17End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging18Start+' AND '+@Aging18End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging19Start+' AND '+@Aging19End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging20Start+' AND '+@Aging20End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 3
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateBusAging)


set @updateBusOther=
'UPDATE ARScoreCard SET
AvgDaysToPay=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.BusID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(day, ARDocs.DueDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.BusID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND duedate<closeddate AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) FROM ARDocs ARDocs 	
	where ARDocs.BusID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
WeightedAvgDaysToPay=(Select sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount))/sum(OrigAmount) FROM ARDocs ARDocs 
	where ARDocs.BusID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
OpenCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''CM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''IN'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DD'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''PA'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''CM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''IN'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DD'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''PA'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''CM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''IN'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''DD'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND doctype = ''PA'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
YTDSales = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = ''IN'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDInvoices = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = ''CM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDebits = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = ''DM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDeductions = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = ''DD'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDPayments = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = ''PA'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
TotalCount=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalOpenItems=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND docdate<'+@ClosingDate+'),
TotalDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OverDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.BusID  = Orgs.oid AND duedate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 3
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateBusOther)

set @updateFactoryAging=
'UPDATE ARScoreCard SET
Aging1   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') <= '+@Aging1End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging2Start+' AND '+@Aging2End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging3Start+' AND '+@Aging3End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging4Start+' AND '+@Aging4End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging5Start+' AND '+@Aging5End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging6Start+' AND '+@Aging6End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE, '+@ClosingDate+') between  '+@Aging7Start+' AND '+@Aging7End+' AND docdate< '+@ClosingDate+' and (closeddate> '+@ClosingDate+' or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging8Start+' AND '+@Aging8End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging9Start+' AND '+@Aging9End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging10Start+' AND '+@Aging10End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging11Start+' AND '+@Aging11End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging12Start+' AND '+@Aging12End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging13Start+' AND '+@Aging13End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging14Start+' AND '+@Aging14End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging15Start+' AND '+@Aging15End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging16Start+' AND '+@Aging16End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging17Start+' AND '+@Aging17End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging18Start+' AND '+@Aging18End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging19Start+' AND '+@Aging19End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging20Start+' AND '+@Aging20End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 5
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateFactoryAging)


set @updateFactoryOther=
'UPDATE ARScoreCard SET
AvgDaysToPay=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.FactoryID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.FactoryID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND duedate<closeddate AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) FROM ARDocs ARDocs 	
	where ARDocs.FactoryID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
WeightedAvgDaysToPay=(Select sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount))/sum(OrigAmount) FROM ARDocs ARDocs 
	where ARDocs.FactoryID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
OpenCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''CM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''IN'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DD'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''PA'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''CM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''IN'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DD'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''PA'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''CM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''IN'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''DD'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND doctype = ''PA'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
YTDSales = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = ''IN'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDInvoices = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = ''CM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDebits = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = ''DM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDeductions = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = ''DD'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDPayments = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = ''PA'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
TotalCount=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalOpenItems=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND docdate<'+@ClosingDate+'),
TotalDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OverDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID  = Orgs.oid AND duedate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 5
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateFactoryOther)

set @updateSalesAging=
'UPDATE ARScoreCard SET
Aging1   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') <= '+@Aging1End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging2   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging2Start+' AND '+@Aging2End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging3   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging3Start+' AND '+@Aging3End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging4   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging4Start+' AND '+@Aging4End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging5   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging5Start+' AND '+@Aging5End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging6   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging6Start+' AND '+@Aging6End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging7   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE, '+@ClosingDate+') between  '+@Aging7Start+' AND '+@Aging7End+' AND docdate< '+@ClosingDate+' and (closeddate> '+@ClosingDate+' or closed=0)),
Aging8   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging8Start+' AND '+@Aging8End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging9   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging9Start+' AND '+@Aging9End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging10   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging10Start+' AND '+@Aging10End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging11   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging11Start+' AND '+@Aging11End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging12   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging12Start+' AND '+@Aging12End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging13   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging13Start+' AND '+@Aging13End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging14   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging14Start+' AND '+@Aging14End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging15   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging15Start+' AND '+@Aging15End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging16   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging16Start+' AND '+@Aging16End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging17   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging17Start+' AND '+@Aging17End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging18   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging18Start+' AND '+@Aging18End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging19   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging19Start+' AND '+@Aging19End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
Aging20   = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid AND DateDiff(Day,DUEDATE,'+@ClosingDate+') between '+@Aging20Start+' AND '+@Aging20End+' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 4
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateSalesAging)

set @updateSalesOther=
'UPDATE ARScoreCard SET
AvgDaysToPay=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.SlsID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
AvgDaysBeyondTerms=(Select cast(sum(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) / count(ARDocs.OID) as DECIMAL(21,5)) FROM ARDocs ARDocs 
	where ARDocs.SlsID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND duedate<closeddate AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
BestPossDaysToPay=(Select min(DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate)) FROM ARDocs ARDocs 	
	where ARDocs.SlsID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
WeightedAvgDaysToPay=(Select sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount))/sum(OrigAmount) FROM ARDocs ARDocs 
	where ARDocs.SlsID  = Orgs.oid AND ARDocs.Doctype = ''IN'' AND docdate<'+@ClosingDate+' AND closeddate<'+@ClosingDate+' AND ARDocs.Closed = 1),
OpenCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''CM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''IN'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DM'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DD'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OpenPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''PA'' AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
NewCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''CM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''IN'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DM'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DD'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
NewPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''PA'' AND month(docdate)='+right(@period,2)+' AND year(docdate)='+left(@period,4)+'),
ClosedCredits = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''CM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedInvoices = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''IN'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDebits= (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DM'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedDeductions = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''DD'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
ClosedPayments = (SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND doctype = ''PA'' AND month(closeddate)='+right(@period,2)+' AND year(closeddate)='+left(@period,4)+'),
YTDSales = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid and doctype = ''IN'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDInvoices = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid and doctype = ''CM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDebits = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid and doctype = ''DM'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDDeductions = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid and doctype = ''DD'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
YTDPayments = (SELECT Sum(Origamount) FROM ARDocs ARDocs WHERE ARDocs.SlsID = Orgs.oid and doctype = ''PA'' AND docdate>''1-1-'+left(@period,4)+''' and docdate<'+@ClosingDate+'),
TotalCount=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
TotalOpenItems=(SELECT Count(OID) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND docdate<'+@ClosingDate+'),
TotalDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND docdate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0)),
OverDue=(SELECT Sum(OrigAmount) FROM ARDocs ARDocs WHERE ARDocs.SlsID  = Orgs.oid AND duedate<'+@ClosingDate+' and (closeddate>'+@ClosingDate+' or closed=0))
FROM Orgs Orgs, ARScoreCard ARScoreCard
WHERE ARScoreCard.LinkedID=Orgs.oid
AND ARScoreCard.LinkedTable=''Orgs''
and Orgs.orgtype = 4
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateSalesOther)

set @updateParentAging=
'UPDATE ARScoreCard SET
ARScoreCard.Aging1   = (SELECT Sum(ARScore_Cust.Aging1) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging2   = (SELECT Sum(ARScore_Cust.Aging2) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging3   = (SELECT Sum(ARScore_Cust.Aging3) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging4   = (SELECT Sum(ARScore_Cust.Aging4) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging5   = (SELECT Sum(ARScore_Cust.Aging5) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging6   = (SELECT Sum(ARScore_Cust.Aging6) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging7   = (SELECT Sum(ARScore_Cust.Aging7) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging8   = (SELECT Sum(ARScore_Cust.Aging8) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging9   = (SELECT Sum(ARScore_Cust.Aging9) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging10   = (SELECT Sum(ARScore_Cust.Aging10) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging11   = (SELECT Sum(ARScore_Cust.Aging11) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging12   = (SELECT Sum(ARScore_Cust.Aging12) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging13   = (SELECT Sum(ARScore_Cust.Aging13) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging14  = (SELECT Sum(ARScore_Cust.Aging14) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ARScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging15   = (SELECT Sum(ARScore_Cust.Aging15) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging16   = (SELECT Sum(ARScore_Cust.Aging16) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging17   = (SELECT Sum(ARScore_Cust.Aging17) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging18   = (SELECT Sum(ARScore_Cust.Aging18) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging19   = (SELECT Sum(ARScore_Cust.Aging19) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.Aging20   = (SELECT Sum(ARScore_Cust.Aging20) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1)
FROM ARScoreCard ARScoreCard 
WHERE ARScoreCard.LinkedType = 7 
AND ARScoreCard.LinkedTable=''Orgs'' and ARScoreCard.PeriodToPost='+@period+''

exec (@updateParentAging)

set @updateParentOther=
'UPDATE ARScoreCard SET
ARScoreCard.AvgDaysToPay=(SELECT Sum(ARScore_Cust.AvgDaysToPay)/Count(ARScore_Cust.AvgDaysToPay) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.AvgDaysBeyondTerms=(SELECT Sum(ARScore_Cust.AvgDaysBeyondTerms)/Count(ARScore_Cust.AvgDaysBeyondTerms) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.BestPossDaysToPay=(SELECT Min(ARScore_Cust.BestPossDaysToPay) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OpenCredits = (SELECT Sum(ARScore_Cust.OpenCredits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OpenInvoices = (SELECT Sum(ARScore_Cust.OpenInvoices) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OpenDebits= (SELECT Sum(ARScore_Cust.OpenDebits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OpenDeductions = (SELECT Sum(ARScore_Cust.OpenDeductions) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OpenPayments = (SELECT Sum(ARScore_Cust.OpenPayments) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.NewCredits = (SELECT Sum(ARScore_Cust.NewCredits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.NewInvoices = (SELECT Sum(ARScore_Cust.NewInvoices) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.NewDebits= (SELECT Sum(ARScore_Cust.NewDebits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.NewDeductions = (SELECT Sum(ARScore_Cust.NewDeductions) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.NewPayments = (SELECT Sum(ARScore_Cust.NewPayments) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.ClosedCredits = (SELECT Sum(ARScore_Cust.ClosedCredits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.ClosedInvoices = (SELECT Sum(ARScore_Cust.ClosedInvoices) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.ClosedDebits= (SELECT Sum(ARScore_Cust.ClosedDebits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.ClosedDeductions = (SELECT Sum(ARScore_Cust.ClosedDeductions) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.ClosedPayments = (SELECT Sum(ARScore_Cust.ClosedPayments) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.YTDSales = (SELECT Sum(ARScore_Cust.YTDSales) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.YTDInvoices = (SELECT Sum(ARScore_Cust.YTDInvoices) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.YTDDebits = (SELECT Sum(ARScore_Cust.YTDDebits) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.YTDDeductions = (SELECT Sum(ARScore_Cust.YTDDeductions) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.YTDPayments = (SELECT Sum(ARScore_Cust.YTDPayments) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.TotalCount=(SELECT Sum(ARScore_Cust.TotalCount) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.TotalOpenItems=(SELECT Sum(ARScore_Cust.TotalOpenItems) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.TotalDue=(SELECT Sum(ARScore_Cust.TotalDue) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1),
ARScoreCard.OverDue=(SELECT Sum(ARScore_Cust.OverDue) FROM ARScoreCard ARScore_Cust JOIN Orgs O ON O.OID=ARScore_Cust.LinkedID 
		where ArScoreCard.LinkedID=O.ParentID and ARScoreCard.LinkedType=7 and  ARScore_Cust.LinkedType=1 and O.orgtype = 1)
FROM ARScoreCard ARScoreCard 
WHERE ARScoreCard.LinkedType = 7 
AND ARScoreCard.LinkedTable=''Orgs''
and ARScoreCard.PeriodToPost='+@period+''

exec (@updateParentOther)

set @updateCorpAging=
'UPDATE ARScoreCard SET
ARScoreCard.YTDSales = (SELECT Sum(ARScore_Cust.YTDSales) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging1   = (SELECT Sum(ARScore_Cust.Aging1) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging2   = (SELECT Sum(ARScore_Cust.Aging2) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging3   = (SELECT Sum(ARScore_Cust.Aging3) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging4   = (SELECT Sum(ARScore_Cust.Aging4) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging5   = (SELECT Sum(ARScore_Cust.Aging5) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging6   = (SELECT Sum(ARScore_Cust.Aging6) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging7   = (SELECT Sum(ARScore_Cust.Aging7) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging8   = (SELECT Sum(ARScore_Cust.Aging8) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging9   = (SELECT Sum(ARScore_Cust.Aging9) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging10   = (SELECT Sum(ARScore_Cust.Aging10) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging11   = (SELECT Sum(ARScore_Cust.Aging11) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging12   = (SELECT Sum(ARScore_Cust.Aging12) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging13   = (SELECT Sum(ARScore_Cust.Aging13) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging14  = (SELECT Sum(ARScore_Cust.Aging14) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging15   = (SELECT Sum(ARScore_Cust.Aging15) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging16   = (SELECT Sum(ARScore_Cust.Aging16) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging17   = (SELECT Sum(ARScore_Cust.Aging17) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging18   = (SELECT Sum(ARScore_Cust.Aging18) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging19   = (SELECT Sum(ARScore_Cust.Aging19) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.Aging20   = (SELECT Sum(ARScore_Cust.Aging20) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1)
FROM ARScoreCard ARScoreCard 
WHERE ArScoreCard.LinkedID=1 
AND ARScoreCard.LinkedTable=''Orgs'' and ARScoreCard.PeriodToPost='+@period+''

exec (@updateCorpAging)

set @updateCorpOther=
'UPDATE ARScoreCard SET
ARScoreCard.AvgDaysToPay=(SELECT Sum(ARScore_Cust.AvgDaysToPay)/Count(ARScore_Cust.AvgDaysToPay) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.AvgDaysBeyondTerms=(SELECT Sum(ARScore_Cust.AvgDaysBeyondTerms)/Count(ARScore_Cust.AvgDaysBeyondTerms) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.BestPossDaysToPay=(SELECT Min(ARScore_Cust.BestPossDaysToPay) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OpenCredits = (SELECT Sum(ARScore_Cust.OpenCredits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OpenInvoices = (SELECT Sum(ARScore_Cust.OpenInvoices) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OpenDebits= (SELECT Sum(ARScore_Cust.OpenDebits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OpenDeductions = (SELECT Sum(ARScore_Cust.OpenDeductions) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OpenPayments = (SELECT Sum(ARScore_Cust.OpenPayments) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.NewCredits = (SELECT Sum(ARScore_Cust.NewCredits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.NewInvoices = (SELECT Sum(ARScore_Cust.NewInvoices) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.NewDebits= (SELECT Sum(ARScore_Cust.NewDebits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.NewDeductions = (SELECT Sum(ARScore_Cust.NewDeductions) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.NewPayments = (SELECT Sum(ARScore_Cust.NewPayments) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.ClosedCredits = (SELECT Sum(ARScore_Cust.ClosedCredits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.ClosedInvoices = (SELECT Sum(ARScore_Cust.ClosedInvoices) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.ClosedDebits= (SELECT Sum(ARScore_Cust.ClosedDebits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.ClosedDeductions = (SELECT Sum(ARScore_Cust.ClosedDeductions) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.ClosedPayments = (SELECT Sum(ARScore_Cust.ClosedPayments) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.YTDSales = (SELECT Sum(ARScore_Cust.YTDSales) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.YTDInvoices = (SELECT Sum(ARScore_Cust.YTDInvoices) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.YTDDebits = (SELECT Sum(ARScore_Cust.YTDDebits) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.YTDDeductions = (SELECT Sum(ARScore_Cust.YTDDeductions) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.YTDPayments = (SELECT Sum(ARScore_Cust.YTDPayments) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.TotalCount=(SELECT Sum(ARScore_Cust.TotalCount) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.TotalOpenItems=(SELECT Sum(ARScore_Cust.TotalOpenItems) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.TotalDue=(SELECT Sum(ARScore_Cust.TotalDue) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1),
ARScoreCard.OverDue=(SELECT Sum(ARScore_Cust.OverDue) FROM ARScoreCard ARScore_Cust where ARScore_Cust.LinkedType=1)
FROM ARScoreCard ARScoreCard 
WHERE ArScoreCard.LinkedID=1 
AND ARScoreCard.LinkedTable=''Orgs'' and ARScoreCard.PeriodToPost='+@period+''


exec (@updateCorpOther)

set @DSO=
'UPDATE ARScoreCard SET
DSO=(Select TotalDue/NewInvoices*DATEDIFF(day, '+@BegDate+','+@ClosingDate+')),
DSOBP=(Select Aging8/NewInvoices*DATEDIFF(day, '+@BegDate+','+@ClosingDate+')),
DSOAD=(Select DSO-DSOBP),
BeginBalance=(Select isnull(TotalDue,0)-isnull(TotalOpened,0)+isnull(TotalClosed,0)),
CEI=round(((Select BeginBalance+NewInvoices-TotalDue)/(BeginBalance+NewInvoices-Aging8)*100),2)'
exec (@DSO)


fetch next from period_cursor into @period,  @closingdate_date, @begdate_date end
close period_cursor
deallocate period_cursor

set @updateSystem='UPDATE ArScoreCard set createddate=getdate(), editeddate=getdate()'
exec (@updateSystem)

*/
