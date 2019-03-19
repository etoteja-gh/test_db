package v9_9_x

databaseChangeLog{
	clid = "9-9-35-GlPostPeriod"

	changeSet(id: "${clid}.1", author: "alexey") {

		addColumn(tableName: "GlPostPeriod") {
			column(name: "statementDate", type: "DATETIME")
		}
	}

	changeSet(id: "${clid}.2", author: "snimavat") {
		dropTable(tableName: "GlDistributionHistory")
		dropTable(tableName: "GlJournalSummary")
	}
}