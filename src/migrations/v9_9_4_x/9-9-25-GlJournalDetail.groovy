package v9_9_x

databaseChangeLog{
	clid = '9-9-25-GlJournalDetail'
	changeSet(author: "snimavat", id: "${clid}.1") {
		renameTable(oldTableName: "GlDistribution", newTableName:"GlJournalDetail")
		addColumn(tableName: "GlJournalDetail") {
			column(name: "source", type: "VARCHAR(50)")
			column(name: "glPostDate", type: "DATETIME")
		}

		dropTable(tableName: "GlAdjustment")
		renameColumn(tableName: "GlJournalDetail", oldColumnName: "ArDocId", newColumnName: "arTranId", columnDataType: "BIGINT")
		createTable(tableName:"GlJournalSummary") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_GlJournalSummary")
			}

			column(name: "CreditAmount", type: "NUMERIC(21,6)")
			column(name: "DebitAmount", type: "NUMERIC(21,6)")
			column(name: "GlAcct", type: "VARCHAR(50)")
			column(name: "GlBatchId", type: "BIGINT")

			column(name: "Segment1", type: "VARCHAR(50)")
			column(name: "Segment2", type: "VARCHAR(50)")
			column(name: "Segment3", type: "VARCHAR(50)")
			column(name: "Segment4", type: "VARCHAR(50)")
			column(name: "Segment5", type: "VARCHAR(50)")
			column(name: "Segment6", type: "VARCHAR(50)")
			column(name: "Segment7", type: "VARCHAR(50)")
			column(name: "Segment8", type: "VARCHAR(50)")
			column(name: "Segment9", type: "VARCHAR(50)")

			column(name: "CreatedBy", type: "BIGINT")
			column(name: "CreatedDate", type: "DATETIME")
			column(name: "EditedBy", type: "BIGINT")
			column(name: "EditedDate", type: "DATETIME")
			column(defaultValueNumeric: "0", name: "version", type: "BIGINT")
		}
	}


	changeSet(author: "snimavat", id: "${clid}.2") {
		sql "update Users set login = '9ci-app' where login = 'admin@9ci.comx'"
		sql "update Users set login = 'gbcust' where login = 'gbcust@greenbill.comx'"
		sql "update Users set login = 'test' where login = 'test@green9ci.comx'"
		sql "update Users set login = 'test-contact' where login = 'testContact1@green9ci.comx'"
	}


	changeSet(author: "snimavat", id: "${clid}.3", dbms:'mysql') {
		sql "update Users set email=concat(login, '@testmeee.com') where email is null;"
	}

	changeSet(author: "snimavat", id: "${clid}.4", dbms:'mssql') {
		sql "update Users set email= login + '@testmeee.com' where email is null;"
	}

	changeSet(id: "${clid}.5", author: 'sudhir') {
        sql "ALTER TABLE Users ADD CONSTRAINT users_email_unique UNIQUE (email)"
    }

}
