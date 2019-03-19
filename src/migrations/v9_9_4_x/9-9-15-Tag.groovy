package v9_9_x

databaseChangeLog{
    clid = '9-9-15'

	changeSet(author: "Alexey", id: "${clid}.1") {
		renameTable(oldTableName: "CustTag", newTableName: "OrgTag")
		renameColumn(tableName: "OrgTag", oldColumnName: "custId", newColumnName: "orgId",columnDataType: 'BIGINT')
	}

	changeSet(author: "Alexey", id: "${clid}.2") {
		sql("INSERT INTO OrgTag (orgId, tagId) SELECT cat.custAccountId, cat.tagId FROM CustAccountTag cat where cat.custAccountId > -1")
	}

	changeSet(id: "${clid}.3", author: "Alexey") {
		dropTable(tableName:"CustAccountTag")
	}

	changeSet(id: "${clid}.4", author: "Alexey") {
		sql("update Tag set name='Credit Limit' where name='CLIM'")
		sql("update AppParam set value='Credit Limit' where variable='climTagName'")
	}
}
