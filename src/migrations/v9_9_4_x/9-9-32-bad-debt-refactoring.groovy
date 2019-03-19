package v9_9_x

databaseChangeLog{
	clid = "9-9-32-bad-debt-refactoring"

	changeSet(id:"${clid}.1", author: "snimavat") {
		sql("insert into AppParam (id, Variable, value) values (4000, 'badDebtWOReason', null)")
		sql("insert into AppParam (id, Variable, value) values (4001, 'badDebtWOTaxReason', null)")
	}

	changeSet(id: "${clid}.2.mysql", author: "snimavat", dbms:'mysql') {
		dropTable(tableName: "ArAction", cascadeConstraints:"true")
	}

	changeSet(id: "${clid}.2.mssql", author: "snimavat", dbms:'mssql') {
		dropTable(tableName: "ArAction")
	}

	changeSet(id: "${clid}.3", author: "joanna", context: "dev") {
		sql("""
			update AppParam set value='Bad Debt' where id=4000 ;
			update AppParam set value='Tax Charge' where id=4001;
			update ArReason set ClearAccount='24501' where id=10;
			update ArReason set ClearAccount='65101' where id=3;
		""")
	}
}