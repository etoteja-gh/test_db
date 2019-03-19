package v9_9_x

databaseChangeLog{
	clid = '9-9-26-AddDefault'

	changeSet(id: "${clid}.1", author: "Alexey") {
		dropColumn(tableName:"ArTranStats" , columnName:"version")
		addColumn(tableName: 'ArTranStats') {
			column(defaultValueNumeric: "0", name: "version", type: "BIGINT") {
				constraints(nullable: "false")
			}
		}
	}


	changeSet(id: "${clid}.2", author: "snimavat") {
		dropNotNullConstraint(tableName:"ArAdjust", columnName:"arBatchId", columnDataType:"BIGINT")
	}

	changeSet(id: "${clid}.3", author: "snimavat") {
		addColumn(tableName: 'ArTranLineType') {
			column(defaultValueNumeric: "1", name: "hideOnInvoice", type: "BIT") {
				constraints(nullable: "false")
			}
		}
	}

	changeSet(id: "${clid}.4", author: "snimavat") {
		sql "update ArTranSource set source='Autocash' where source='autoCash'"
		sql "update ArTranSource set source='PayGateway' where source in ('QB', 'Authorize.Net', 'PayPal', 'PaySimple', 'ACH Direct')"
		sql "update ArTranSource set sourceType = 'PayGateway' where sourceType = 'Gateway'"
		sql "update ArTranSource set sourceType = 'ERP' where sourceType = 'Erp'"
	}

	changeSet(id: "${clid}.5", author: "snimavat",  context:"test") {
		sql "update Contact set email = replace(email, 'comx', 'com')"
		sql "update Contact set email = replace(email, 'comz', 'com')"
	}



}