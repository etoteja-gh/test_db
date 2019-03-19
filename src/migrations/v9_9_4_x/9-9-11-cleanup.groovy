package v9_9_x

databaseChangeLog{
	clid = '9-9-11'

	changeSet(id: "${clid}.0.5", author: "Ken", dbms:'mssql') { // This is a fix for ArScoreCard alteration which is broken on microsoft.
		dropUniqueConstraint(tableName: 'ArScoreCard', constraintName: 'IX_ArScoreCard')
		//dropIndex(tableName: 'ArScoreCard', indexName: 'IX_ArScoreCard')
		dropIndex(tableName: 'ArScoreCard', indexName: 'IX_ArScoreCard_OrgId')
	}

	changeSet(id: "${clid}.1", author: "Sudhir") {
		sql "update ArScoreCard set orgId = 205 where orgId is null"
		sql "update ArScoreCard set glPostPeriod = '200807' where glPostPeriod is null"
		addNotNullConstraint(tableName: "ArScoreCard", columnName: "orgId", columnDataType: "bigint")
		addNotNullConstraint(tableName: "ArScoreCard", columnName: "glPostPeriod", columnDataType: "varchar(10)")
	}

	changeSet(id: "${clid}.2", author: "Ken", dbms:'mssql') { // MSSQL needs to drop and recreate the index
		createIndex(indexName: "IX_ArScoreCard", tableName: "ArScoreCard", unique: "true") {
			column(name: "glPostPeriod")
			column(name: "orgId")
		}
		createIndex(indexName: "IX_ArScoreCard_OrgId", tableName: "ArScoreCard", unique: "false") {
			column(name: "orgId")
		}
	}


	changeSet(id: "${clid}.3", author: "sudhir") {
		sql "update SecRole set inactive = 0 where inactive is null"
		addNotNullConstraint(tableName: "SecRole", columnName: "inactive", columnDataType: "CHAR(1)")
	}

	changeSet(id: "${clid}.4", author: "sudhir") {
		sql "update Contact set orgId = 2 where orgId = 1 and exists(select 1 from Users where contactId = Contact.id)"
	}

	changeSet(id: "${clid}.5", author: "sudhir") {
		sql "delete from OrgType where name = 'Default'"
	}

	changeSet(id: "${clid}.6", author: "sudhir") {
		sql "update AppParam set Variable = 'custAccountActive', Value='false' WHERE Variable = 'custAccountReqOnArTran'"
		sql("insert into AppParam (id, Variable, value) values (1394, 'custAccountReqOnDocType', 'false')")
	}

	changeSet(id: "${clid}.7", author: "sudhir", context:'dev') {
		sql "update AppParam set Value='true' WHERE Variable = 'custAccountActive'"
		sql "update AppParam set Value='IN,DD,DM,CM' WHERE Variable = 'custAccountReqOnDocType'"
	}

}