package v9_9_x

databaseChangeLog{
	clid = "9-9-33-glbatch-refactoring"

	changeSet(id: "${clid}.1", author: "snimavat") {

		renameColumn(tableName: "ArTran", oldColumnName: "glBatchId", newColumnName: "outBatchId", columnDataType: "bigint")
		addColumn(tableName: "ArTran") {
			column(name: "glPostBatchId", type: "bigint")
			column(name: "inBatchId", type: "bigint")
		}

		//ArAdjust changes
		renameColumn(tableName: "ArAdjust", oldColumnName: "glBatchId", newColumnName: "outBatchId", columnDataType: "bigint")
		addColumn(tableName: "ArAdjust") {
			column(name: "glPostBatchId", type: "bigint")
		}

		//journal changes
		renameColumn(tableName: "ArTranJournal", oldColumnName: "glBatchId", newColumnName: "glPostBatchId", columnDataType: "bigint")
		renameColumn(tableName: "ArAdjustJournal", oldColumnName: "glBatchId", newColumnName: "glPostBatchId", columnDataType: "bigint")
		renameColumn(tableName: "GlJournal", oldColumnName: "glBatchId", newColumnName: "glPostBatchId", columnDataType: "bigint")

		// grailsChange {
		// 	change {
		// 		sql.execute("insert into GlBatch (id, glPostPeriod, BatchStatusId, CreatedDate, source) values (-1, null, 1, ?, 'Autocash')", [new java.sql.Date(new Date().time)])
		// 	}
		// }
	}

	changeSet(id: "${clid}.2", author: "snimavat",  context: "test") {
		sql("update ArTran set outBatchId = 3 where outBatchId is not null and not exists(select 1 from GlBatch where id = ArTran.outBatchId)")
	}
}