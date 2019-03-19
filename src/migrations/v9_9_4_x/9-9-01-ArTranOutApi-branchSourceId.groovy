

databaseChangeLog{
    clid = '9-9-01'

    changeSet(id: "${clid}.1", author: "ken") {
		modifyDataType(columnName: "branchSourceId", newDataType: "VARCHAR(255)", tableName: "ArTranOutApi")
	}
}