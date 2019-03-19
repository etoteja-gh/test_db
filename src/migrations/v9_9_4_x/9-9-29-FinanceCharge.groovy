package v9_9_x

databaseChangeLog{
	clid = '9-9-29-FinanceCharge'


	changeSet(id: "${clid}.2", author: "Alexey") {
		renameColumn(tableName: "CustSetup", oldColumnName: "serviceChargePct", newColumnName: "financeChargePct", columnDataType: 'DECIMAL(8,6)')
	}

	changeSet(id: "${clid}.3", author: "Alexey") {
		createTable(tableName: "ArUsStateRate") {
			column(defaultValueNumeric: "0", name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}
			column(name: "StateCode", type: "VARCHAR(2)")
			column(name: "StateName", type: "VARCHAR(50)")
			column(name: "FinanceChargePct", type: "DECIMAL(8,6)")
			column(name: "TaxPct", type: "DECIMAL(8,6)")
			column(name: "CreatedBy", type: "BIGINT")
			column(name: "CreatedDate", type: "DATETIME")
			column(name: "EditedBy", type: "BIGINT")
			column(name: "EditedDate", type: "DATETIME")
			column(defaultValueNumeric: "0", name: "version", type: "BIGINT")
		}
	}

	changeSet(author: "Alexey", id: "${clid}.4") {
		createIndex(indexName: "ix_ArUsStateRate_stateCode", tableName: "ArUsStateRate", unique: "true") {
			column(name: "StateCode")
		}
		addDefaultValue(tableName:"ArUsStateRate",columnName:"FinanceChargePct" ,defaultValue:"0")
	}

	changeSet(author: "Alexey", id: "${clid}.5") {
		sql "UPDATE CustSetup  set financeChargePct =  financeChargePct where financeChargePct >=1"
	}

	changeSet(author: "Alexey", id: "${clid}.6") {
		addColumn(tableName: "ArUsStateRate") {
			column(name: "FinanceChargePctMax", type: "DECIMAL(8,6)")
		}
	}

}
