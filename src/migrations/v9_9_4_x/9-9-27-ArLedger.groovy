package v9_9_x

databaseChangeLog{
	clid = '9-9-27-ArLedger'

	changeSet(id: "${clid}.1", author: "snimavat") {
		sql("insert into AppParam (id, Variable, value) values (1397, 'arLedgerEnabled', 'false')")

		createTable(tableName:"ArTranJournal") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_ArTranJournal")
			}

			column(name: "arTranId", type: "BIGINT") {
				constraints(nullable: "false")
			}

			column(name: "GlAcct", type: "VARCHAR(50)")
			column(name: "glBatchId", type: "BIGINT")
			column(name: "credit", type: "NUMERIC(21,6)")
			column(name: "debit", type: "NUMERIC(21,6)")

		}

		createTable(tableName:"ArAdjustJournal") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_ArAdjustJournal")
			}

			column(name: "aradjustId", type: "BIGINT") {
				constraints(nullable: "false")
			}

			column(name: "GlAcct", type: "VARCHAR(50)")
			column(name: "glBatchId", type: "BIGINT")
			column(name: "credit", type: "NUMERIC(21,6)")
			column(name: "debit", type: "NUMERIC(21,6)")
		}
	}

	changeSet(id: "${clid}.2", author: "snimavat") {
		renameTable(oldTableName: "GlJournalDetail", newTableName:"GlJournal")
		addColumn(tableName: 'GlJournal') {
			column(name: "glPostPeriod", type: "varchar(10)")
		}

		renameColumn(tableName:"GlJournal", columnDataType:"NUMERIC(21,6)", newColumnName:"credit", oldColumnName:"creditAmount")
		renameColumn(tableName:"GlJournal", columnDataType:"NUMERIC(21,6)", newColumnName:"debit", oldColumnName:"debitAmount")

		dropColumn(tableName:"GlJournal" , columnName:"linkedId")
		dropColumn(tableName:"GlJournal" , columnName:"arTranId")

		dropColumn(tableName:"GlJournal" , columnName:"segment1")
		dropColumn(tableName:"GlJournal" , columnName:"segment2")
		dropColumn(tableName:"GlJournal" , columnName:"segment3")
		dropColumn(tableName:"GlJournal" , columnName:"segment4")
		dropColumn(tableName:"GlJournal" , columnName:"segment5")
		dropColumn(tableName:"GlJournal" , columnName:"segment6")
		dropColumn(tableName:"GlJournal" , columnName:"segment7")
		dropColumn(tableName:"GlJournal" , columnName:"segment8")
		dropColumn(tableName:"GlJournal" , columnName:"segment9")

		addColumn(tableName: 'GlBatch') {
			column(name: "controlAmount", type: "NUMERIC(21,6)")
		}

		createTable(tableName:"GlJournalMember") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_GlJournalMember")
			}

			column(name: "journalId", type: "BIGINT") {
				constraints(nullable: "false")
			}

			column(name: "branchId", type: "BIGINT")
			column(name: "divisionId", type: "BIGINT")
			column(name: "businessId", type: "BIGINT")
			column(name: "salesId", type: "BIGINT")
			column(name: "regionId", type: "BIGINT")
			column(name: "factoryId", type: "BIGINT")
			column(name: "version", type: "BIGINT")
		}

	}

	changeSet(id: "${clid}.3", author: "joanna") {

		addColumn(tableName: 'ArAdjustJournal') {
			column(name: "arAdjustLineId", type: "BIGINT")
		}
	}

	changeSet(id: "${clid}.4", author: "snimavat") {
		sql "INSERT INTO ArReason (id, Name) VALUES (9, 'Discount')"
	}

}