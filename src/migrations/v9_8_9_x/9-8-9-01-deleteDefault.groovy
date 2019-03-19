package v9_8_9_x

databaseChangeLog{
	clid = '9-8-9-01-deleteDefaults'

	changeSet(id: "${clid}.1", author: "Andrey") {
		delete(tableName: 'AcSetupGroup', whereClause: "id = 0")
	}

	changeSet(id: "${clid}.2", author: "Andrey") {
		[ 'matchGroupId', 'memoGroupId', 'offsetGroupId', 'discountGroupId',].each { column ->
			sql "UPDATE CustAcSetup set $column=null where $column=0"
			sql "UPDATE AcLayoutImport set $column=null where $column=0"
			sql "UPDATE PaymentSetting set $column=null where $column=0"
		}
	}

}