package v9_9_x

databaseChangeLog{
	clid = '9-9-41'

	changeSet(id: "${clid}.1", author: "Alexey") {
		createTable(tableName: "ReportFilter") {
			column(defaultValueNumeric: "0", name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}
			column(name: "name", type: "VARCHAR(50)")
			column(name: "description", type: "VARCHAR(250)")
			column(name: "rootDomain", type: "VARCHAR(50)")
			column(name: "json", type: "VARCHAR(5000)")
			column(name: "version", type: "BIGINT")

			column(name: "CreatedDate", type: "DATETIME")
			column(defaultValueNumeric: "0", name: "EditedBy", type: "BIGINT") {
				constraints(nullable: "false")
			}
			column(name: "EditedDate", type: "DATETIME")
		}
	}

	changeSet(author: "Alexey", id: "${clid}.2") {
		createIndex(indexName: "ix_ReportFilter_name", tableName: "ReportFilter", unique: "true") {
			column(name: "name")
		}
	}

    changeSet(author: "Alexey", id: "${clid}.3") {
        sql("""insert into ReportFilter (id, name, rootDomain, json, version) values (1, 'Dispute Filter', 'ArTran' , '{"state":[0],"status":["9","11","21"]}', 0)""")
    }

    changeSet(author: "Joanna", id: "${clid}.4") {
		createIndex(indexName: "ix_ArAdjust_arTranId", tableName: "ArAdjust" ) {
			column(name: "arTranId")
		}
	}
}
