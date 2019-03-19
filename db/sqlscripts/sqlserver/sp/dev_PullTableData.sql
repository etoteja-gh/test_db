
--dev_PullTableData 'itv82devbb'
--dev_PullTableData 'itv82devbb',1000

create procedure dev_PullTableData @oldDB as varchar(100), @numRowsToPull as varchar(10) = null as

/* 
built 02/21/2007 BB
This will match the old database to the new database and procuce insert scripts
to pull data from Old in to the current database
Identifies full table and column matches, then lists the differences
as warnings.  Also lists the columns where there is a difference 
(old not in new/new not in old)
*/

/*
declare @oldDB varchar(100)
set @OldDB = 'ITV82Devbb'
drop table #workingtable
drop table #OldSys
drop table #NewSys
*/

declare @topPhrase varchar(100)
set @topPhrase = CASE WHEN @numRowsToPull is null THEN ' ' ELSE ' TOP ' + @numRowsToPull + ' ' END

create table #workingtable (
    LoadType Varchar(50),
	id bigint not null,
    colName varchar(50) not null,
    list varchar(7500),
	tablename varchar(100),
    autoval varchar(50)
   primary key (id, colname, tablename, loadtype) )

declare @sql varchar(1000)

create table #OldSys (
    id bigint not null,
    colName varchar(100) not null,
	tablename varchar(100),
	autoval int
)

set @sql = 'Insert into #OldSys(id,colName, tablename, autoval)
  select dbo.FN9_CONCAT(db_id(),OBJECT_ID(C.TABLE_NAME),'''') id,
  C.COLUMN_NAME colName,
  C.TABLE_NAME tableName,
  case when OBJECTPROPERTY(OBJECT_ID(C.TABLE_NAME), ''TableHasIdentity'') = 0 then null else 1 end autoval
from '+@OldDB+'.INFORMATION_SCHEMA.TABLES T,
     '+@OldDB+'.INFORMATION_SCHEMA.COLUMNS C
WHERE T.TABLE_CATALOG = C.TABLE_CATALOG
  AND T.TABLE_SCHEMA = C.TABLE_SCHEMA
  AND T.TABLE_NAME = C.TABLE_NAME
  AND T.TABLE_TYPE = ''BASE TABLE''
  AND T.TABLE_NAME != ''dtproperties''
  AND T.TABLE_NAME not like ''qrtz%''
  AND T.TABLE_NAME not like ''tempImport_%''
  AND T.TABLE_NAME not like ''%API''
  AND dbo.FN9_CONCAT(db_id(),OBJECT_ID(C.TABLE_NAME),'''') is not null
'

exec (@sql)

create table #NewSys (
    id bigint not null,
    colName varchar(100) not null,
	tablename varchar(100),
	autoval int
)


Insert into #NewSys(id,colName, tablename, autoval)
select dbo.FN9_CONCAT(db_id(),OBJECT_ID(C.TABLE_NAME),'') id,
	C.COLUMN_NAME colName,
	C.TABLE_NAME tableName,
	case when OBJECTPROPERTY(OBJECT_ID(C.TABLE_NAME), 'TableHasIdentity') = 0 then null else 1 end autoval
from INFORMATION_SCHEMA.TABLES T, INFORMATION_SCHEMA.COLUMNS C
WHERE T.TABLE_CATALOG = C.TABLE_CATALOG
  AND T.TABLE_SCHEMA = C.TABLE_SCHEMA
  AND T.TABLE_NAME = C.TABLE_NAME
  AND T.TABLE_TYPE = 'BASE TABLE'
  AND T.TABLE_NAME != 'dtproperties'
  AND T.TABLE_NAME not like 'qrtz%'
  AND T.TABLE_NAME not like 'tempImport_%'
  AND T.TABLE_NAME not like '%API'
       
--select * from #workingtable where id = 90480720765
-- FULL MATCHES
insert into #workingtable (LoadType, id,colName, tablename, autoval)
 select 'Complete table and column match', 
		new.id id,new.Colname , New.Tablename , New.autoval
   from #NewSys New
      join #OldSys Old on old.tablename = New.Tablename  
         and Old.colName = New.Colname
       and  new.tablename not in
        ( select distinct old2.Tablename 
		 from #NewSys New2
			right join #OldSys Old2 on old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where new2.colname is null
       and exists (select 1 from #NewSys where tablename = old.tablename) )
          and  old.tablename not in
        ( select distinct new2.Tablename 
		 from #NewSys New2
			left join #OldSys Old2 on old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where old2.colname is null
       and exists (select 1 from #OldSys where tablename = new.tablename) )
union 
-- TP Prefix
 select 'Complete with PREFIX table and column match', 
		new.id id,new.Colname , New.Tablename , New.autoval
   from #NewSys New
      join #OldSys Old on 'TP_' + old.tablename =  New.Tablename  
         and Old.colName = New.Colname
       and  new.tablename not in
        ( select distinct 'TP_' + old2.Tablename 
		 from #NewSys New2
			right join #OldSys Old2 on 'TP_' + old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where new2.colname is null
       and exists (select 1 from #NewSys where tablename = 'TP_' + old.tablename) )
          and  'TP_' + old.tablename not in
        ( select distinct new2.Tablename 
		 from #NewSys New2
			left join #OldSys Old2 on 'TP_' + old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where old2.colname is null
       and exists (select 1 from #OldSys where 'TP_' + tablename = new.tablename) )
union
-- Partial column Matches
 select 'Warning: Table match with PARTIAL column match', 
		new.id id,new.Colname , New.Tablename , New.autoval
   from #NewSys New
      join #OldSys Old on old.tablename = New.Tablename  
         and Old.colName = New.Colname
       where  new.tablename in
        ( select distinct old2.Tablename 
		 from #NewSys New2
			right join #OldSys Old2 on old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where new2.colname is null
       and exists (select 1 from #NewSys where tablename = old.tablename)
        )
union
 -- Partial column Matches
select 'Warning: Table match with PARTIAL column match', 
		new.id id, old.Colname , old.Tablename , old.autoval
   from #NewSys New
      join #OldSys Old on old.tablename = New.Tablename  
         and Old.colName = New.Colname
	     where Old.tableName in 
	(Select distinct New2.Tablename
   from #NewSys New2
      left join #OldSys Old2 on old2.tablename = New2.Tablename  
         and old2.colName = New2.Colname
     where old2.colname is null
       and exists (select 1 from #OldSys where tablename = new2.tablename))		
Union
 select 'Warning: NewList: Columns Added/Renamed', 
     (new.id *-1) id,new.Colname , New.Tablename , Null
   from #NewSys New
      left join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where old.colname is null
       and exists (select 1 from #OldSys where tablename = new.tablename)
union
 select 'Warning: OldList: Columns Removed/Renamed', 
		(OLD.id *-1) id,Old.Colname , Old.Tablename , Null
   from #NewSys New
      right join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where new.colname is null
       and exists (select 1 from #NewSys where tablename = old.tablename)
order by new.id,new.colName
     --  and  exists (select 1 from #oldsys where old.tablename = tbl.name  
	    --  and Old.colName <> col.name)

update #workingtable set list = ''

declare
    @list varchar(8000),
    @lastid bigint,
	@InsertStmt varchar(8000)

select
    @list = '',
    @lastid = -2

--This converts the columns to a CSV list
update
    #workingtable
set
    @list = list = case
                       when @lastid <> id then colName
                       else @list + ', ' + colName
                   end,
    @lastid = id


--return results and lists

-- Complete Matches
select 1 a, max(loadtype), max(tableName),
     Case 
		when max(autoval) is not null then
		  'Set Identity_Insert [' + max(tableName) + '] On' 
     Else
			''
    End  ,
    '' oldlist, '' newlist
from
    #workingtable
group by
    id
having  max(autoval) is not null and max(loadtype) not like '%Warn%' 
union
select 2 a, max(loadtype),  max(tableName),
  'truncate table ' + max(tableName) +'
	     ',
    '' oldlist, '' newlist
from #workingtable
group by id
having  max(loadtype) not like '%Warn%' 
union
select 3 a, max(loadtype),  max(tableName),
  'Insert into ' + max(tableName) + '(' +  max(list) + ')
           Select ' + + @topPhrase + + max(list) + ' From ' + @OldDB + '..' + max(tableName) + '
	     ',
    '' oldlist, '' newlist
from  #workingtable
group by id
having  max(loadtype) not like '%Warn%' 
union
select 4 a, max(loadtype), max(tableName),
     Case 
		when max(autoval) is not null then
		  'Set Identity_Insert [' + max(tableName) + '] Off' 
     Else
			''
    End  ,
    '' oldlist, '' newlist
from
    #workingtable
group by
    id
having  max(autoval) is not null and max(loadtype) not like '%Warn%' 
order by
    max(loadtype), max(tableName),a

-- Warnings/Partial matches
select 1 a, max(loadtype), max(tableName),
     Case 
		when max(autoval) is not null then
		  'Set Identity_Insert [' + max(tableName) + '] On' 
     Else
			''
    End  ,
    '' oldlist, '' newlist
from
    #workingtable
group by
    id
having  max(autoval) is not null and max(loadtype) like '%Warning: Table%' 
union
select 2 a, max(loadtype),  max(tableName),
  'truncate table ' + max(tableName) +'
	     ',
    '' oldlist, '' newlist
from #workingtable
group by id
having  max(loadtype)  like '%Warning: Table%' 
union
select 3 a, max(loadtype),  max(tableName),
  'Insert into ' + max(tableName) + '(' +  max(list) + ')
           Select ' + + @topPhrase + + max(list) + ' From ' + @OldDB + '..' + max(tableName) + '
	     ',
    '' oldlist, '' newlist
from
    #workingtable
group by
    id
having  max(loadtype)  like '%Warning: Table%' 
union
select 4 a, max(loadtype),  max(tableName), --max(list),
      ''  ,
    case 
		when  left(max(loadtype), 12) = 'Warning: Old' then Max(list)
		else ''
	end, 
    case 
		when  left(max(loadtype), 12) = 'Warning: New' then Max(list)
		else ''
	end
from
    #workingtable
group by
    id
having  max(loadtype) like '%list%'
union
select 4 a, max(loadtype), max(tableName),
     Case 
		when max(autoval) is not null then
		  'Set Identity_Insert [' + max(tableName) + '] Off' 
     Else
			''
    End  ,
    '' oldlist, '' newlist
from
    #workingtable
group by
    id
having   max(autoval) is not null and max(loadtype) like '%Warn%' 
order by
   max(tableName), a, max(loadtype)


 select distinct 'Table Added/Renamed', new.tablename 
   from #NewSys new 
     left join #OldSys Old on old.tablename = new.tablename  
   where old.id is null
     order by new.tablename
       --and tbl.name = 'orgs'

 select distinct 'Table Deleted/Renamed', old.tablename tablename
   from #NewSys new
     right join #OldSys Old on old.tablename = new.Tablename  
   where  new.id is null
     order by tablename

 select 'WARNING: Columns Added/Renamed', 
		 new.Tablename ,new.Colname NewColumnName
   from #NewSys New
      left join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where old.colname is null
       and exists (select 1 from #OldSys where tablename = new.tablename)
order by new.tablename, new.colname

 select 'WARNING: Columns Removed/Renamed/Missing', 
		old.Tablename ,old.colname OldColumnName
   from #NewSys New
      right join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where new.colname is null
       and exists (select 1 from #NewSys where tablename = old.tablename)
order by old.tablename, old.colname


 select distinct 
		 new.Tablename, ' Tables with Columns Added/Renamed'
   from #NewSys New
      left join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where old.colname is null
       and exists (select 1 from #OldSys where tablename = new.tablename)
order by new.tablename

 select distinct 
		old.Tablename, 'Table with columns Removed/Renamed/Missing'
   from #NewSys New
      right join #OldSys Old on old.tablename = New.Tablename  
         and old.colName = New.Colname
     where new.colname is null
       and exists (select 1 from #NewSys where tablename = old.tablename)
order by old.tablename
;

