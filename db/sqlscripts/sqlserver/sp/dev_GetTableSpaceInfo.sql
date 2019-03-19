CREATE PROCEDURE [dbo].[dev_GetTableSpaceInfo]
	  @DBName as varchar(200)
	, @Format as varchar(5) = Null
AS
BEGIN
	Create Table #TableInfo (
		  table_name sysname ,
		  row_count int,
		  reserved_size varchar(50),
		  data_size varchar(50),
		  index_size varchar(50),
		  unused_size varchar(50))

	DECLARE @SQL as nvarchar(1000)
	SET NOCOUNT ON
	SET @SQL = 'insert #TableInfo exec [' + @DBName + ']..sp_msforeachtable ''sp_spaceused ''''?'''' '' '
	exec sp_executesql @SQL

	if @Format = 'XML'
		select 
			  TableSpaceInfo.table_name as tableName
			, TableSpaceInfo.row_count as tableRows
			, CAST(CAST(Replace(TableSpaceInfo.data_size, ' KB', '') as decimal(20,3)) / 1024 as decimal(20,3)) as tableSizeMb
			, CAST(CAST(Replace(TableSpaceInfo.index_size, ' KB', '') as decimal(20,3)) / 1024 as decimal(20,3)) as indexSizeMb
		from #TableInfo as TableSpaceInfo
		Order by CAST(Replace(TableSpaceInfo.data_size, ' KB', '') as integer) desc
		FOR XML AUTO, ELEMENTS		
	else
		select 
			  TableSpaceInfo.table_name as tableName
			, TableSpaceInfo.row_count as tableRows
			, CAST(CAST(Replace(TableSpaceInfo.data_size, ' KB', '') as decimal(20,3)) / 1024 as decimal(20,3)) as tableSizeMb
			, CAST(CAST(Replace(TableSpaceInfo.index_size, ' KB', '') as decimal(20,3)) / 1024 as decimal(20,3)) as indexSizeMb
		from #TableInfo TableSpaceInfo
		Order by CAST(Replace(TableSpaceInfo.data_size, ' KB', '') as integer) desc

		drop table #TableInfo
END