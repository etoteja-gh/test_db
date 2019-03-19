package v9_9_x

databaseChangeLog{
	clid = "9-9-40-password-config"

	changeSet(id: "${clid}.1", author: "snimavat") {
		sql("insert into AppParam (id, Variable, value, version) values (4003, 'passwordMinLength', '5', 0)")
		sql("insert into AppParam (id, Variable, value, version) values (4004, 'passwordMustContainNumbers', 'true', 0)")
		sql("insert into AppParam (id, Variable, value, version) values (4005, 'passwordMustContainSymbols', 'true', 0)")
		sql("insert into AppParam (id, Variable, value, version) values (4006, 'passwordMustContainUpperaseLetter', 'true', 0)")
		sql("insert into AppParam (id, Variable, value, version) values (4007, 'passwordMustContainLowercaseLetter', 'true', 0)")
	}

	changeSet(id: "${clid}.2", author: "snimavat") {
		sql("insert into AppParam (id, Variable, value) values (4008, 'passwordHistoryEnabled', 'true')")
		sql("insert into AppParam (id, Variable, value) values (4009, 'passwordHistoryLength', '10')")

		dropTable(tableName: "SecPasswordHistory")
		createTable(tableName: "SecPasswordHistory") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}

			column(name: "userId", type: "BIGINT") {
				constraints(nullable: false)
			}

			column(name: "password", type: "varchar(60)")
			column(name: "dateCreated", type: "TIMESTAMP") {
				constraints(nullable: "false")
			}
		}

		addForeignKeyConstraint(
				constraintName: "fk_passwordhistory_user",
				baseTableName: "SecPasswordHistory",
				baseColumnNames: "userId",
				referencedTableName: "Users",
				referencedColumnNames: "id")
	}
}
