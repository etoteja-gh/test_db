
CREATE  proc dcs_auto_Activities as

/*
DECLARE @tableName varchar(50)
set @tableName='Activities'

truncate table ActivitiesAPI

--Update existing activities
Update Activities set Priority = 3
where source in  ('Past Due 30', 'Past Due PTP',
		'Past Due 30 P2', 'Past Due 30 P3')
	and completed = 0 and actdate < getdate() - .5
 	and Priority <> 3

-- Create Past Due PTP activities
INSERT INTO ActivitiesAPI (
 Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid,
Priority)
select 0,0,'Call','Past Due PTP',
'Past Due PTP DUE: ' + cast(dateadjusted as varchar(20)) + '
IN Amt: ' + cast(a.amount as varchar(15)) + ' Refnum: ' + A.refnum + '.
CheckRef: ' + PP.AdjusterRefNbr + ' CheckAmount: ' +
Case
	when cast(PP.AdjusterAmount as varchar(15)) is null then 'Not Given'
	else cast(PP.AdjusterAmount as varchar(15))
end + '
' + (select cast(count(*) as varchar(10)) from ardocs where oid = a.oid and a.amount = 0) +
' Out of ' + (select cast(count(*) as varchar(10)) from ardocs where oid = a.oid) + ' PTP Invoices paid' ,
a.ownerid,getdate(),'Minutes',
0,0,A.oid, 'ARDocs',
a.ownerid, Getdate(), 0, GetDate(),
'Past Due PTP',PP.oid,
a.custid,
1
from aradjust PP, ardocs a
  where adjusterdoctype = 'PP'
     and adjustedoid = a.oid
     and dateadjusted < getdate()
     and a.amount > 0
     and a.doctype = 'IN'
and pp.oid not in (select sourceid from Activities where source = 'Past Due PTP')
--and a.ownerid in (select oid from persons where Fname in ('ICC2', 'ICC1'))

Update ardocs set statusid = 36
from aradjust PP, ardocs a
  where adjusterdoctype = 'PP'
     and adjustedoid = a.oid
     and dateadjusted < getdate()
     and a.amount > 0
     and a.doctype = 'IN'
     and a.statusid <> 36
and pp.oid not in (select sourceid from Activities where source = 'Past Due PTP')


-- Create Past Due Activities at Org level
INSERT INTO ActivitiesAPI (
 Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid,
priority)
select 0,0,'Call','5K > 30',
'30+ aging over $5000
 Total Amt over 30 days: ' + cast(c.aging9 as varchar(15)),
o.defaultownerid,
getdate(),
'Minutes',
0,0,
o.oid, 'Orgs',
o.defaultownerid, Getdate(), 0, GetDate(),
'5K > 30', o.oid, o.oid,
3
 from orgscalc C
join Orgs o on o.oid=c.oid
where aging9 > 5000 and orgtype = 1
 and o.oid not in (select linkedid from activities
			where source = '5K > 30' and linkedtable = 'Orgs'
			   and completed = 0)
   and datepart(weekday, getdate()) = 3 -- Monday morning



-- Insert Activities for courtesy call on 5k invoices
INSERT INTO ActivitiesAPI (
 Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid,
priority)
select distinct 0,0,'Call','Courtesy Call >5k',
'Invoice is due on: ' + cast(a.duedate as varchar(20)),
a.ownerid,
getdate(),
'Minutes',
0,0,
a.oid, 'ARDocs',
a.ownerid, Getdate(), 0, GetDate(),
'Courtesy Call >5k', a.oid, a.custid,
3
from ardocs a
where a.closed = 0 and a.amount > 5000 and a.doctype = 'IN'
 and datediff(d,duedate,getdate()) between -10 and 99999
 and not exists (select * from activities
    where linkedid = a.oid and completed = 0)
  and datepart(weekday, getdate()) = 3 -- Monday morning

-- Insert Activities for Chargebacks
INSERT INTO ActivitiesAPI (
 Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid,
priority)
select distinct 0,0,'Call','Chargeback over 10K',
'Deduction Due: ' + cast(a.duedate as varchar(20)),
a.ownerid,
getdate() -.75,
'Minutes',
0,0,
a.oid, 'ARDocs',
a.ownerid, Getdate(), 0, GetDate(),
'DD 10K', a.oid, a.custid,
2
from ardocs a
where a.closed = 0 and a.amount > 10000 and a.doctype = 'DD'
 and not exists (select * from activities
    where linkedid = a.oid and completed = 0)
 and not exists (select * from notes
    where linkedid = notes.oid)

-- Insert Activities when no contact for last 21 days
INSERT INTO ActivitiesAPI (
 Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid,
priority)
select distinct 0,0,'Call','No Activity ',
'No notes or activities on account for 21 days
Last contact on  ' + cast(x.lastnotedate as varchar(20)) + '
Account has: ' + cast(c.totalopenitems as varchar(15)) + ' Open Items',
o.defaultownerid,
getdate(),
'Minutes',
0,0,
o.oid, 'Orgs',
o.defaultownerid, Getdate(), 0, GetDate(),
'No Activity', o.oid, o.oid,
1
from orgs o, orgsext x, orgscalc c, ardocs a
where o.oid=x.oid and o.oid=c.oid 
 and o.inactive = 0
 and x.lastnotedate < getdate() - 14
 and a.custid = o.oid
 and a.closed = 0 and a.amount > 0
 and datediff(d,duedate,getdate()) > 21
 and not exists (select * from activities
    where linkedid = o.oid and completed = 0)

-- set oid from NewObjectID table
SET NOCOUNT ON
 DECLARE @newoid int
 DECLARE @OID int
  SELECT @newoid = NextId from newobjectid where KeyName=@tableName+'.OID'
  DECLARE api cursor for
    SELECT oid from ActivitiesAPI  for update of oid

    OPEN api
    FETCH NEXT FROM api into @OID
    WHILE @@FETCH_STATUS = 0
    BEGIN
      update ActivitiesAPI set oid = @newoid where current of api
      set @newoid = @newoid+1
      fetch next from api into @OID
    END
    UPDATE newobjectid SET NextId = @newoid where KeyName=@tableName+'.OID'
    CLOSE api
    DEALLOCATE api


SET NOCOUNT OFF


-- Insert new activities
INSERT INTO Activities (OID,  Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid, priority)
SELECT OID,  Version, ContactID, Activity, Subject,
Comments, UserID, ActDate,
DurationType, Alarm,
Completed, LinkedID, LinkedTable,
CreatedBy, CreatedDate, EditedBy, EditedDate,
source, sourceid, orgid, priority
FROM ActivitiesAPI

*/
