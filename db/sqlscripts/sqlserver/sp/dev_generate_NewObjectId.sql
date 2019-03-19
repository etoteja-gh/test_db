CREATE procedure dev_generate_NewObjectID as
/**
 * Script generates NewObjectId table. First it takes table names from sysobjects 
 * table and inserts them into keyName with default nextId value (1). Then, it 
 * updates nextId values with ids from table itself. 
 */
DECLARE keyName_cursor CURSOR FOR
SELECT name FROM dbo.sysobjects
 WHERE xtype = 'U'  --U - user types 
 and name != 'DATABASECHANGELOG'
and 
 exists (select * from syscolumns
  where id=object_id(sysobjects.name) and name='id') -- only tables with column id in it

DECLARE @keyName varchar(100)
DECLARE @insert varchar(500)
DECLARE @update varchar(500)

truncate table NewObjectID

OPEN keyName_cursor

fetch next from keyName_cursor into @keyName  while @@FETCH_STATUS = 0 begin


set @insert=
'Insert into NewObjectID (KeyName, NextId) values ('+ ''''+@keyName+'.id'',1)'

set @update=

'Update NewObjectID set NextId=(select isnull(max(id)+1,1) from '+ @keyName+') where KeyName='''+@keyName+'.id'''


exec (@insert)
exec (@update)
fetch next from keyName_cursor into @keyName end

close keyName_cursor
deallocate keyName_cursor

/** GlobalID is used for columns that have set needsDynamicFormIDCreator (look at Col9.setNeedsDynamicFormIDCreator(boolean b)),
* like GLBatchID or CrossRefNum (make sure that's numeric only and then put it in)
**/
declare @globalID int
declare @maxCrossRefNum int
declare @maxGLBatchID int
set @maxCrossRefNum=(select max(crossRefNum) from ArTranExt where isnumeric(crossRefNum)=1)

-- only when crossrefNum is numeric only
set @maxGLBatchID=(select isnull(max(GLBatchID),0) from ArTran)
set @globalID=@maxGLBatchID
set @globalID=
CASE 
      WHEN @maxCrossRefNum > @globalID  THEN @maxCrossRefNum	
         ELSE @globalID
      END

Insert into NewObjectID (KeyName, NextId) values ('Global.ID',isnull(@globalID,0));
Insert into NewObjectID (KeyName, NextId) select 'Customer.num',
 max(num) from Customer where isnumeric(num)=1;





