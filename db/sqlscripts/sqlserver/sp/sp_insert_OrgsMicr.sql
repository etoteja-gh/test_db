
CREATE procedure [dbo].[sp_insert_OrgsMicr] as
/*
truncate table OrgsMicrApi




insert into orgsmicrapi (accountnum,routingnum,orgid)

select  distinct(isnull(p.accountnum,'')), p.routingnum, p.custid
 from payments p where 


((not exists 
(select 1 from orgsmicr o where p.accountnum=o.accountnum)
 and p.custid<>0 and p.accountnum is not null and rtrim(p.accountnum)<>'')
OR
(not exists 
(select 1 from orgsmicr o where p.accountnum=o.accountnum and p.routingnum=o.routingnum)
 and p.custid<>0 and p.accountnum is not null and rtrim(p.accountnum)<>'' and p.routingnum is not null and rtrim(p.routingnum)<>''))


SET NOCOUNT ON
DECLARE @tableName varchar(50)
set @tableName='OrgsMicr'
 DECLARE @newoid int
 DECLARE @OID int
 SELECT @newoid = NextId from newobjectid where KeyName=@tableName+'.OID'
 DECLARE api cursor for
    SELECT oid from OrgsMICRApi  for update of oid

    OPEN api
    FETCH NEXT FROM api into @OID
    WHILE @@FETCH_STATUS = 0
    BEGIN
      update OrgsMICRApi set oid = @newoid where current of api
      set @newoid = @newoid+1
      fetch next from api into @OID
    END
    UPDATE newobjectid SET NextId = @newoid where KeyName=@tableName+'.OID'
 CLOSE api
 DEALLOCATE api

SET NOCOUNT OFF


INSERT INTO OrgsMicr
(oid, orgid, accountnum, routingnum, source)
select 
oid, orgid, accountnum, routingnum, 'Payments' from orgsmicrapi


set QUOTED_IDENTIFIER ON
*/