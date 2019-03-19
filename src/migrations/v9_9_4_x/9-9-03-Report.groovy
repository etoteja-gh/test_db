package v9_9_x

databaseChangeLog{
    clid = '9-9-03'

	changeSet(author: "Alexey", id: "${clid}.1") {
		sql("TRUNCATE TABLE Report")
	}

    changeSet(id: "${clid}.2", author: "Alexey") {
		addColumn(tableName: 'Report') {
			column(name:'isSaveResult', defaultValueBoolean: false, type:'bit'){
				constraints(nullable: false)
			}
			column(name:'orgId', type:'bigint')
			column(name:'format', type:'varchar(50)'){
				constraints(nullable: false)
			}
		}
		renameColumn(tableName: "Report", oldColumnName: "reportFileName", newColumnName: "filename",columnDataType: 'varchar(50)')
		dropColumn(tableName:"Report" , columnName:"reportServerCatalog")
		dropColumn(tableName:"Report" , columnName:"reportServerHost")
		dropColumn(tableName:"Report" , columnName:"reportServerPort")
		dropColumn(tableName:"Report" , columnName:"configReportMethod")
    }

	changeSet(author: "Alexey", id: "${clid}.3") {
		sql("INSERT INTO Report (version, filename, orgId, name, format, description, createdBy, editedBy, createdDate, editedDate) SELECT rc.version, rc.filename, rc.divisionId, rc.name, rc.format, rc.description, rc.createdBy, rc.editedBy, rc.createdDate, rc.editedDate FROM ReportCustom rc where rc.id > 0 ")
	}

	changeSet(id: "${clid}.4", author: "Alexey") {
		renameColumn(tableName: "ReportDistribution", oldColumnName: "divisionId", newColumnName: "orgId" ,columnDataType: "bigint")
		renameColumn(tableName: "ReportResult", oldColumnName: "divisionId", newColumnName: "orgId" ,columnDataType: "bigint")
		renameColumn(tableName: "ReportSchedule", oldColumnName: "divisionId", newColumnName: "orgId" ,columnDataType: "bigint")
	}

	changeSet(id: "${clid}.5", author: "Alexey") {
		dropTable(tableName:"ReportXref")
		dropTable(tableName:"ReportCustom")
	}



}
