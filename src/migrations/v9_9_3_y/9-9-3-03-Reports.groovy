package v9_9_3_y

databaseChangeLog{
	clid = '9-9-3-02-AppParam-NewRefnumGenerator'

	changeSet(id: "${clid}.1", author: 'snimavat', dbms: "mssql") {
		modifyDataType(tableName:"ReportResult", columnName:"params", newDataType:"nvarchar(2000)")
	}

	changeSet(id: "${clid}.2", author: 'Joanna') {
		sql("""
			insert into AppParam(id, Variable, CreatedBy, EditedBy, Value)
			select 282, 'apiRecalcAgingAfterArApiImport', 0, 0, 'false'
		""")
	}
}