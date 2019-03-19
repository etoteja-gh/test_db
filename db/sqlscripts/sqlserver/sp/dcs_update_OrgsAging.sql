CREATE  PROCEDURE dcs_update_OrgsAging AS

DECLARE @Aging1Start int
DECLARE @Aging1End   int
DECLARE @Aging2Start int
DECLARE @Aging2End   int
DECLARE @Aging3Start int
DECLARE @Aging3End   int
DECLARE @Aging4Start int
DECLARE @Aging4End   int
DECLARE @Aging5Start int
DECLARE @Aging5End   int
DECLARE @Aging6Start int
DECLARE @Aging6End   int
DECLARE @Aging7Start int
DECLARE @Aging7End   int
DECLARE @Aging8Start int
DECLARE @Aging8End   int
DECLARE @Aging9Start int
DECLARE @Aging9End   int
DECLARE @Aging10Start int
DECLARE @Aging10End   int

DECLARE @Aging11Start int
DECLARE @Aging11End   int
DECLARE @Aging12Start int
DECLARE @Aging12End   int
DECLARE @Aging13Start int
DECLARE @Aging13End   int
DECLARE @Aging14Start int
DECLARE @Aging14End   int
DECLARE @Aging15Start int
DECLARE @Aging15End   int
DECLARE @Aging16Start int
DECLARE @Aging16End   int
DECLARE @Aging17Start int
DECLARE @Aging17End   int
DECLARE @Aging18Start int
DECLARE @Aging18End   int
DECLARE @Aging19Start int
DECLARE @Aging19End   int
DECLARE @Aging20Start int
DECLARE @Aging20End   int


DECLARE @Error       int
DECLARE @AgedAsOfDate smallDateTime
set @AgedAsOfDate = getDate()
-- *******************************************************************-- * Fill the aging days variables-- *******************************************************************
Set @Aging1Start = (SELECT StartDay FROM CFGAging WHERE OID = 1)IF (@@ERROR <> 0) Set @Error = @@Error
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

--DROP INDEXES
if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging1')
  drop index  OrgsCalc.IX_Orgs_Aging1

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging2')
  drop index  OrgsCalc.IX_Orgs_Aging2

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging3')
  drop index  OrgsCalc.IX_Orgs_Aging3

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging4')
  drop index  OrgsCalc.IX_Orgs_Aging4

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging5')
  drop index  OrgsCalc.IX_Orgs_Aging5

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging6')
  drop index  OrgsCalc.IX_Orgs_Aging6

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging7')
  drop index  OrgsCalc.IX_Orgs_Aging7

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging8')
  drop index  OrgsCalc.IX_Orgs_Aging8

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging9')
  drop index  OrgsCalc.IX_Orgs_Aging9

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging10')
  drop index  OrgsCalc.IX_Orgs_Aging10

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging11')
  drop index  OrgsCalc.IX_Orgs_Aging11

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging12')
  drop index  OrgsCalc.IX_Orgs_Aging12

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging13')
  drop index  OrgsCalc.IX_Orgs_Aging13

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging14')
  drop index  OrgsCalc.IX_Orgs_Aging14

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging15')
  drop index  OrgsCalc.IX_Orgs_Aging15

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging16')
  drop index  OrgsCalc.IX_Orgs_Aging16

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging17')
  drop index  OrgsCalc.IX_Orgs_Aging17

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging18')
  drop index  OrgsCalc.IX_Orgs_Aging18

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging19')
  drop index  OrgsCalc.IX_Orgs_Aging19

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_Aging20')
  drop index  OrgsCalc.IX_Orgs_Aging20

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_TotalDue')
  drop index  OrgsCalc.IX_Orgs_TotalDue

if exists (select * from dbo.sysindexes where name = 'IX_Orgs_TotalOpenItems')
  drop index  OrgsCalc.IX_Orgs_TotalOpenItems

-- END Drop indexes

select 'drop indexes', getdate()

UPDATE OrgsCalc SET
OpenPromises = 0,
OpenCredits = 0,
OverDue = 0,
HighestBal = 0,
YTDSales = 0,TotalOpenItems = 0,TotalDue = 0,Aging1   = 0,Aging2   = 0,Aging3   = 0,Aging4   = 0,Aging5   = 0,Aging6   = 0,Aging7   = 0,
Aging8   = 0,Aging9   = 0,Aging10   = 0,
Aging11   = 0,Aging12   = 0,Aging13   = 0,Aging14   = 0,Aging15   = 0,Aging16   = 0,Aging17   = 0,
Aging18   = 0,Aging19   = 0,Aging20   = 0
FROM OrgsCalc

select 'update to 0', getdate()

-- for business
if not exists (select * from dbo.sysindexes where name = 'ix_ardocs_coverBus')
   create index ix_ardocs_coverBus on ardocs(busid,amount, closed)

UPDATE OrgsCalc SET
YTDSales =  (SELECT Sum(Origamount) FROM ARDocs WHERE ARDocs.BusID = Orgs.oid and doctype = 'IN' and year(duedate) = year(getdate())),
OpenPromises = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND closed = 0 and statusid=35),
OpenCredits = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND closed = 0 and doctype = 'CM'),
OverDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND closed = 0 and duedate < getdate()),
HighestBal = (SELECT Sum(Amount) FROM ARDocs WHERE ARDocs.BusID = Orgs.oid AND  closed = 0 having sum(amount) > HighestBal),
TotalOpenItems = (SELECT count(oid) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND closed = 0),
TotalDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND  closed = 0),
DateofLastCash = (Select max(docdate) from ardocs where ARDocs.BusID = Orgs.oid and doctype = 'PA'),
Aging1   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging1Start AND @Aging1End AND closed = 0),
Aging2   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging2Start AND @Aging2End AND closed = 0),
Aging3   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging3Start AND @Aging3End AND closed = 0),
Aging4   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging4Start AND @Aging4End AND closed = 0),
Aging5   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging5Start AND @Aging5End AND closed = 0),
Aging6   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging6Start AND @Aging6End AND closed = 0),
Aging7   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging7Start AND @Aging7End AND closed = 0),
Aging8   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging8Start AND @Aging8End AND closed = 0),
Aging9   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging9Start AND @Aging9End AND closed = 0),
Aging10   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging10Start AND @Aging10End AND closed = 0),
Aging11   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging11Start AND @Aging11End AND closed = 0),
Aging12   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging12Start AND @Aging12End AND closed = 0),
Aging13   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging13Start AND @Aging13End AND closed = 0),
Aging14   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging14Start AND @Aging14End AND closed = 0),
Aging15   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging15Start AND @Aging15End AND closed = 0),
Aging16   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging16Start AND @Aging16End AND closed = 0),
Aging17   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging17Start AND @Aging17End AND closed = 0),
Aging18   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging18Start AND @Aging18End AND closed = 0),
Aging19   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging19Start AND @Aging19End AND closed = 0),
Aging20   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.BusID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging20Start AND @Aging20End AND closed = 0)
FROM OrgsCalc OrgsCalc JOIN Orgs Orgs ON Orgs.OID=OrgsCalc.OID 
WHERE EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.BusID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 3

UPDATE OrgsExt SET
LastNotedate = (Select max(notes.editeddate) from ardocs, notes where ARDocs.BusID = Orgs.oid and ardocs.oid = notes.linkedid),
LastDocDate = (Select max(docdate) from ardocs where ARDocs.BusID = Orgs.oid)
FROM OrgsExt OrgsExt JOIN Orgs Orgs ON Orgs.OID=OrgsExt.OID 
WHERE   EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.BusID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 3

drop index ardocs.ix_ardocs_coverBus

select 'bus', getdate()


-- for customers
if not exists (select * from dbo.sysindexes where name = 'ix_ardocs_coverCust')
  create index ix_ardocs_coverCust on ardocs(custid,amount, closed)

UPDATE OrgsCalc SET
YTDSales =  (SELECT Sum(Origamount) FROM ARDocs WHERE ARDocs.CustID = Orgs.oid and doctype = 'IN' and year(duedate) = year(getdate())),
OpenPromises = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND closed = 0 and statusid=35),
OpenCredits = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND closed = 0 and doctype = 'CM'),
OverDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND closed = 0 and duedate < getdate()),
HighestBal = (SELECT Sum(Amount) FROM ARDocs WHERE ARDocs.CustID = Orgs.oid AND  closed = 0 having sum(amount) > HighestBal),
TotalOpenItems = (SELECT count(oid) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND closed = 0),
TotalDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND  closed = 0),
DateofLastCash = (SELECT max(docdate) from ardocs where ARDocs.CustID = Orgs.oid and doctype = 'PA'),
WeightedAvgDaysToPay= (SELECT sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount))/sum(OrigAmount)FROM ARDocs ARDocs where ARDocs.CustID  = OrgsCalc.oid AND ARDocs.Doctype = 'IN' AND ARDocs.Closed = 1),
AvgDaysToPay= isnull((SELECT sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate))) /count(ARDocs.oid) FROM ARDocs ARDocs where ARDocs.CustID  = OrgsCalc.oid AND ARDocs.Doctype = 'IN' AND ARDocs.Closed = 1),0),
Aging1   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging1Start AND @Aging1End AND closed = 0),
Aging2   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging2Start AND @Aging2End AND closed = 0),
Aging3   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging3Start AND @Aging3End AND closed = 0),
Aging4   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging4Start AND @Aging4End AND closed = 0),
Aging5   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging5Start AND @Aging5End AND closed = 0),
Aging6   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging6Start AND @Aging6End AND closed = 0),
Aging7   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging7Start AND @Aging7End AND closed = 0),
Aging8   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging8Start AND @Aging8End AND closed = 0),
Aging9   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging9Start AND @Aging9End AND closed = 0),
Aging10   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging10Start AND @Aging10End AND closed = 0),
Aging11   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging11Start AND @Aging11End AND closed = 0),
Aging12   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging12Start AND @Aging12End AND closed = 0),
Aging13   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging13Start AND @Aging13End AND closed = 0),
Aging14   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging14Start AND @Aging14End AND closed = 0),
Aging15   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging15Start AND @Aging15End AND closed = 0),
Aging16   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging16Start AND @Aging16End AND closed = 0),
Aging17   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging17Start AND @Aging17End AND closed = 0),
Aging18   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging18Start AND @Aging18End AND closed = 0),
Aging19   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging19Start AND @Aging19End AND closed = 0),
Aging20   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.CustID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging20Start AND @Aging20End AND closed = 0)
FROM OrgsCalc OrgsCalc JOIN Orgs Orgs ON Orgs.OID=OrgsCalc.OID 
WHERE EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.CustID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 1


UPDATE OrgsExt SET
LastNotedate = (Select max(notes.editeddate) from ardocs, notes where ARDocs.CustID = Orgs.oid and ardocs.oid = notes.linkedid),
LastDocDate = (Select max(docdate) from ardocs where ARDocs.CustID = Orgs.oid)
FROM OrgsExt OrgsExt JOIN Orgs Orgs ON Orgs.OID=OrgsExt.OID 
WHERE   EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.CustID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 1

select 'cust', getdate()

drop index ardocs.ix_ardocs_coverCust

if not exists (select * from dbo.sysindexes where name = 'ix_ardocs_coverFactory')
   create index ix_ardocs_coverFactory on ardocs(Factoryid,amount, closed)

--factory
UPDATE OrgsCalc SET
YTDSales =  (SELECT Sum(Origamount) FROM ARDocs WHERE ARDocs.FactoryID = Orgs.oid and doctype = 'IN' and year(duedate) = year(getdate())),
OpenPromises = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0 and statusid=35),
OpenCredits = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0 and doctype = 'CM'),
OverDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0 and duedate < getdate()),
HighestBal = (SELECT Sum(Amount) FROM ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND  closed = 0 having sum(amount) > HighestBal),
TotalOpenItems = (SELECT count(oid) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0),
TotalDue = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND  closed = 0),
DateofLastCash = (Select max(docdate) from ardocs where ARDocs.FactoryID = Orgs.oid and doctype = 'PA'),
Aging1   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging1Start AND @Aging1End AND closed = 0),
Aging2   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging2Start AND @Aging2End AND closed = 0),
Aging3   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging3Start AND @Aging3End AND closed = 0),
Aging4   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging4Start AND @Aging4End AND closed = 0),
Aging5   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging5Start AND @Aging5End AND closed = 0),
Aging6   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging6Start AND @Aging6End AND closed = 0),
Aging7   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging7Start AND @Aging7End AND closed = 0),
Aging8   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging8Start AND @Aging8End AND closed = 0),
Aging9   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging9Start AND @Aging9End AND closed = 0),
Aging10   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging10Start AND @Aging10End AND closed = 0),
Aging11   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging11Start AND @Aging11End AND closed = 0),
Aging12   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging12Start AND @Aging12End AND closed = 0),
Aging13   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging13Start AND @Aging13End AND closed = 0),
Aging14   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging14Start AND @Aging14End AND closed = 0),
Aging15   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging15Start AND @Aging15End AND closed = 0),
Aging16   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging16Start AND @Aging16End AND closed = 0),
Aging17   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging17Start AND @Aging17End AND closed = 0),
Aging18   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging18Start AND @Aging18End AND closed = 0),
Aging19   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging19Start AND @Aging19End AND closed = 0),
Aging20   = (SELECT Sum(Amount) FROM ARDocs ARDocs WHERE ARDocs.FactoryID = Orgs.oid AND DateDiff(Day,DUEDATE,@AgedAsOfDate) between @Aging20Start AND @Aging20End AND closed = 0)
FROM OrgsCalc OrgsCalc JOIN Orgs Orgs ON Orgs.OID=OrgsCalc.OID 
WHERE EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 5

UPDATE OrgsExt SET
LastNotedate = (Select max(notes.editeddate) from ardocs, notes where ARDocs.FactoryID = Orgs.oid and ardocs.oid = notes.linkedid),
LastDocDate = (Select max(docdate) from ardocs where ARDocs.FactoryID = Orgs.oid)
FROM OrgsExt OrgsExt JOIN Orgs Orgs ON Orgs.OID=OrgsExt.OID 
WHERE EXISTS (SELECT * FROM ARDocs ARDocs 
 WHERE ARDocs.FactoryID = Orgs.oid AND closed = 0 ) 
and Orgs.orgtype = 5

drop index ardocs.ix_ardocs_coverFactory

select 'factory', getdate()

-- for parents 
UPDATE OrgsCalc SET
YTDSales =  (SELECT Sum(YTDSales) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
OpenPromises = (SELECT Sum(OpenPromises) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
OpenCredits = (SELECT Sum(OpenCredits) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
OverDue = (SELECT Sum(OverDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
HighestBal = (SELECT Sum(TotalDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
TotalOpenItems = (SELECT count(TotalOpenItems) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
TotalDue = (SELECT Sum(TotalDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
DateofLastCash = (Select max(DateofLastCash) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging1   = (SELECT Sum(aging1) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging2   = (SELECT Sum(aging2) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging3   = (SELECT Sum(aging3) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging4   = (SELECT Sum(aging4) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging5   = (SELECT Sum(aging5) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging6   = (SELECT Sum(aging6) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging7   = (SELECT Sum(aging7) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging8   = (SELECT Sum(aging8) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging9   = (SELECT Sum(aging9) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging10   = (SELECT Sum(aging10) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging11   = (SELECT Sum(aging11) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging12   = (SELECT Sum(aging12) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging13   = (SELECT Sum(aging13) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging14   = (SELECT Sum(aging14) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging15   = (SELECT Sum(aging15) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging16   = (SELECT Sum(aging16) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging17   = (SELECT Sum(aging17) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging18   = (SELECT Sum(aging18) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging19   = (SELECT Sum(aging19) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid),
Aging20   = (SELECT Sum(aging20) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1 and O.parentid=OrgsCalc.oid)
FROM OrgsCalc OrgsCalc JOIN Orgs Orgs ON Orgs.OID=OrgsCalc.OID 
WHERE Orgs.orgtype = 7

UPDATE OrgsExt SET
LastNotedate = (Select max(LastNotedate) FROM OrgsExt JOIN Orgs O ON O.OID=OrgsExt.OID where O.orgtype = 1 and O.parentid=OrgsExt.oid),
LastDocDate = (Select max(LastDocDate) FROM OrgsExt JOIN Orgs O ON O.OID=OrgsExt.OID where O.orgtype = 1 and O.parentid=OrgsExt.oid)
FROM OrgsExt OrgsExt JOIN Orgs Orgs ON Orgs.OID=OrgsExt.OID 
WHERE Orgs.orgtype = 7

select 'parents', getdate()

-- for corp
UPDATE OrgsCalc SET
YTDSales =  (SELECT Sum(YTDSales) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
OpenPromises = (SELECT Sum(OpenPromises) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
OpenCredits = (SELECT Sum(OpenCredits) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
OverDue = (SELECT Sum(OverDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
HighestBal = (SELECT Sum(TotalDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
TotalOpenItems = (SELECT count(TotalOpenItems) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
TotalDue = (SELECT Sum(TotalDue) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
DateofLastCash = (Select max(docdate) from ardocs where doctype = 'PA'),
Aging1   = (SELECT Sum(aging1) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging2   = (SELECT Sum(aging2) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging3   = (SELECT Sum(aging3) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging4   = (SELECT Sum(aging4) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging5   = (SELECT Sum(aging5) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging6   = (SELECT Sum(aging6) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging7   = (SELECT Sum(aging7) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging8   = (SELECT Sum(aging8) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging9   = (SELECT Sum(aging9) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging10   = (SELECT Sum(aging10) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging11   = (SELECT Sum(aging11) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging12   = (SELECT Sum(aging12) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging13   = (SELECT Sum(aging13) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging14   = (SELECT Sum(aging14) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging15   = (SELECT Sum(aging15) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging16   = (SELECT Sum(aging16) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging17   = (SELECT Sum(aging17) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging18   = (SELECT Sum(aging18) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging19   = (SELECT Sum(aging19) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1),
Aging20   = (SELECT Sum(aging20) FROM OrgsCalc JOIN Orgs O ON O.OID=OrgsCalc.OID  where O.orgtype = 1)
FROM OrgsCalc OrgsCalc 
WHERE OrgsCalc.oid = 1

UPDATE OrgsExt SET
LastNotedate = (Select max(LastNotedate) FROM OrgsExt JOIN Orgs O ON O.OID=OrgsExt.OID where O.orgtype = 1),
LastDocDate = (Select max(LastDocDate) FROM OrgsExt JOIN Orgs O ON O.OID=OrgsExt.OID where O.orgtype = 1)
FROM OrgsExt OrgsExt 
WHERE OrgsExt.oid = 1

select 'corp', getdate()


Create index IX_Orgs_Aging1 on OrgsCalc(Aging1)
Create index IX_Orgs_Aging2 on OrgsCalc(Aging2)
Create index IX_Orgs_Aging3 on OrgsCalc(Aging3)
Create index IX_Orgs_Aging4 on OrgsCalc(Aging4)
Create index IX_Orgs_Aging5 on OrgsCalc(Aging5)
Create index IX_Orgs_Aging6 on OrgsCalc(Aging6)
Create index IX_Orgs_Aging7 on OrgsCalc(Aging7)
Create index IX_Orgs_Aging8 on OrgsCalc(Aging8)
Create index IX_Orgs_Aging9 on OrgsCalc(Aging9)
Create index IX_Orgs_Aging10 on OrgsCalc(Aging10)
Create index IX_Orgs_Aging11 on OrgsCalc(Aging11)
Create index IX_Orgs_Aging12 on OrgsCalc(Aging12)
Create index IX_Orgs_Aging13 on OrgsCalc(Aging13)
Create index IX_Orgs_Aging14 on OrgsCalc(Aging14)
Create index IX_Orgs_Aging15 on OrgsCalc(Aging15)
Create index IX_Orgs_Aging16 on OrgsCalc(Aging16)
Create index IX_Orgs_Aging17 on OrgsCalc(Aging17)
Create index IX_Orgs_Aging18 on OrgsCalc(Aging18)
Create index IX_Orgs_Aging19 on OrgsCalc(Aging19)
Create index IX_Orgs_Aging20 on OrgsCalc(Aging20)
Create index IX_Orgs_TotalOpenItems on OrgsCalc(TotalOpenItems)
--
Create index IX_Orgs_TotalDue on OrgsCalc(TotalDue)


select 'index', getdate()

UPDATE OrgsCalc Set TotalOpenItems = 0 WHERE TotalOpenItems is null
UPDATE OrgsCalc Set TotalDue = 0 WHERE TotalDue is null

UPDATE OrgsCalc Set Aging1 = 0 WHERE Aging1 is null
UPDATE OrgsCalc Set Aging2 = 0 WHERE Aging2 is null
UPDATE OrgsCalc Set Aging3 = 0 WHERE Aging3 is null
UPDATE OrgsCalc Set Aging4 = 0 WHERE Aging4 is null
UPDATE OrgsCalc Set Aging5 = 0 WHERE Aging5 is null
UPDATE OrgsCalc Set Aging6 = 0 WHERE Aging6 is null
UPDATE OrgsCalc Set Aging7 = 0 WHERE Aging7 is null
UPDATE OrgsCalc Set Aging8 = 0 WHERE Aging8 is null
UPDATE OrgsCalc Set Aging9 = 0 WHERE Aging9 is null
UPDATE OrgsCalc Set Aging10 = 0 WHERE Aging10 is null

UPDATE OrgsCalc Set Aging11 = 0 WHERE Aging11 is null
UPDATE OrgsCalc Set Aging12 = 0 WHERE Aging12 is null
UPDATE OrgsCalc Set Aging13 = 0 WHERE Aging13 is null
UPDATE OrgsCalc Set Aging14 = 0 WHERE Aging14 is null
UPDATE OrgsCalc Set Aging15 = 0 WHERE Aging15 is null
UPDATE OrgsCalc Set Aging16 = 0 WHERE Aging16 is null
UPDATE OrgsCalc Set Aging17 = 0 WHERE Aging17 is null
UPDATE OrgsCalc Set Aging18 = 0 WHERE Aging18 is null
UPDATE OrgsCalc Set Aging19 = 0 WHERE Aging19 is null
UPDATE OrgsCalc Set Aging20 = 0 WHERE Aging20 is null



select 'update nulls', getdate()

