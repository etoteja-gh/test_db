package v9_9_x

databaseChangeLog{
	clid = "9-9-36-FcAppParam"

	changeSet(author: "Alexey", id: "${clid}.1") {
		sql("insert into AppParam (id, Variable, value) values (4002, 'financeChargeMinimumValue', '')")
	}

	changeSet(author: "snimavat", id: "${clid}.2") {
		addColumn(tableName: "ArScoreCard") {
			column(name: "possibleFC", type:'numeric(19,4)')
		}
	}

	changeSet(author: "Alexey", id: "${clid}.3") {
		sql("insert into AppParam (id, Variable, value) values (4010, 'badDebtWOFCReason', 'false')")
	}

	changeSet(author: "snimavat", id: "${clid}.4") {
		modifyDataType(tableName: "AppParam", columnName: "Variable", newDataType: "varchar(100)")
	}

	changeSet(author: "snimavat", id: "${clid}.5") {
		sql("insert into AppParam (id, Variable, value) values (4011, 'multipleGlPostPeriodDontChangeGlPostDateForOpenPeriod', 'false')")
	}

}