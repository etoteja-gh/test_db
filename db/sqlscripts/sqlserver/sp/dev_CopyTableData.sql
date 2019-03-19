

--itv_copy_table_data 'itv80'

-- This procedure is used to migrate data out of the database that holds it.
-- The output of this procedure is another procedure, which can be copied into a MSSQL Query
-- Analyzer window to be executed.  That procedure will perform the copy.
--
-- The second script will probably need to be tweaked, especially if there are column name changes.

create procedure dev_CopyTableData @targetdb varchar(100) as

DECLARE @SelectSql varchar(5000),
   @TableName varchar(200),
   @ColumnName varchar(200),
   @InsertSql varchar(5000),
   @TruncateSql varchar(200),
  @IdentityOn varchar(100),
  @IdentityOff varchar(100)

declare @count int

set @count = 0

DECLARE AllTables cursor for
select c_obj.name
from    sysobjects      c_obj
where
       c_obj.uid       = user_id()
       and c_obj.xtype = 'U'
       and c_obj.name != 'dtproperties'
       and c_obj.name not like 'qrtz%'
       and c_obj.name not like 'tempImport_%'
       and c_obj.name not like '%API'
order by c_obj.name

OPEN AllTables

FETCH NEXT FROM AllTables
INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN

   Set @TruncateSql = 'Truncate table [' + @targetDB + ']..[' + @TableName + ']'
   Set @InsertSql = 'Insert into [' + @targetDB + ']..[' + @TableName + '] ( '
   Set @SelectSql = 'Select '

   set @IdentityOn = ''
   set @IdentityOff = ''

   if exists (select *
            from    sysobjects      c_obj
         join    syscolumns      col on c_obj.id = col.id
         where
                 c_obj.uid       = user_id()
                 and c_obj.xtype = 'U'
             and c_obj.name = @TableName and autoval is not null)
   begin
   set @IdentityOn = 'Set Identity_Insert ' + @targetDB + '..[' + @TableName + '] On'
   set @IdentityOff = 'Set Identity_Insert ' + @targetDB + '..[' + @TableName + '] Off'
   end

   Declare AllColumns Cursor  for
   select col.name
   from    sysobjects      c_obj
   join    syscolumns      col on c_obj.id = col.id
   where
           c_obj.uid       = user_id()
           and c_obj.xtype = 'U'
       and c_obj.name = @TableName

   Open AllColumns

   FETCH NEXT FROM AllColumns
   INTO @ColumnName

   set @InsertSql = @InsertSql + '[' + @ColumnName
   Set @SelectSql = @SelectSql + '[' + @ColumnName

   FETCH NEXT FROM AllColumns
   INTO @ColumnName

       WHILE @@FETCH_STATUS = 0
              BEGIN
              Set @SelectSql = @SelectSql + '], [' + @ColumnName

              If @ColumnName = 'Comment'
                   Begin
                      Set @ColumnName = 'Comments'
                   End

              If @ColumnName = 'BusName'
                   Begin
                      Set @ColumnName = 'BusinessName'
                   End

              If @ColumnName = 'Visibility'
                   Begin
                      Set @ColumnName = 'Visible'
                   End

              If @ColumnName = 'ColName'
                   Begin
                      Set @ColumnName = 'ColumnName'
                   End

              set @InsertSql = @InsertSql + '], [' + @ColumnName

       FETCH NEXT FROM AllColumns
          INTO @ColumnName
              END
       CLOSE AllColumns
       DEALLOCATE AllColumns

   set @InsertSql = @InsertSql + '])'
   Set @SelectSql = @SelectSql + '] From  [' + @TableName + ']'


   print @truncatesql
   print @IdentityOn
   print @insertSql + ' ' +  @SelectSql
   print @IdentityOff
   print ''

  FETCH NEXT FROM AllTables
  INTO @TableName

  set @count = @count + 1
END

print '--Number of Tables Inserted:'
print @count

CLOSE AllTables
DEALLOCATE AllTables

;
SET QUOTED_IDENTIFIER OFF 
;
SET ANSI_NULLS ON 
;

