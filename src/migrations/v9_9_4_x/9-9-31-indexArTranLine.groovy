package v9_9_x

databaseChangeLog{
    clid = '9-9-31-indexArTranLine'

     changeSet(id: "${clid}.1", author: "Joanna") {

        createIndex(indexName: 'ix_ArTranLine_lineTypeId', tableName: 'ArTranLine') {
            column(name:'lineTypeId')
        }

        createIndex(indexName: 'ix_ArTranLine_lineItemId', tableName: 'ArTranLine') {
            column(name:'lineItemId')
        }


        createIndex(indexName: 'ix_ArTranLine_flexId', tableName: 'ArTranLine') {
            column(name:'flexId')
        }


        createIndex(indexName: 'ix_ArTranLine_kind', tableName: 'ArTranLine') {
            column(name:'kind')
        }

	    createIndex(indexName: 'ix_ArTranLineItem_kind', tableName: 'ArTranLineItem') {
            column(name:'kind')
        }
        createIndex(indexName: 'ix_ArTranLineItem_itemId', tableName: 'ArTranLineItem') {
            column(name:'itemId')
        }

    }

    changeSet(id: "${clid}.2", author: "snimavat") {
        addColumn(tableName: "GlBatch") {
            column(name: "arBatchId", type: "bigint") {
                constraints(nullable: "true")
            }
        }
    }

    changeSet(id: "${clid}.3", author: "snimavat") {
        createTable(tableName: "GlJournalFlex") {
            column(name: "id", type: "BIGINT") {
                constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_GlJournalFlex")
            }
            column(name: "text1", type: "VARCHAR(255)")
            column(name: "text2", type: "VARCHAR(255)")
            column(name: "text3", type: "VARCHAR(255)")
            column(name: "text4", type: "VARCHAR(255)")
            column(name: "text5", type: "VARCHAR(255)")
            column(name: "text6", type: "VARCHAR(255)")
            column(name: "text7", type: "VARCHAR(255)")
            column(name: "text8", type: "VARCHAR(255)")
            column(name: "text9", type: "VARCHAR(255)")
            column(name: "text10", type: "VARCHAR(255)")
            column(name: "num1", type: "NUMERIC(19,4)")
            column(name: "num2", type: "NUMERIC(19,4)")
            column(name: "num3", type: "NUMERIC(19,4)")
            column(name: "num4", type: "NUMERIC(19,4)")
            column(name: "num5", type: "NUMERIC(19,4)")
            column(name: "num6", type: "NUMERIC(19,4)")
            column(name: "date1", type: "DATETIME")
            column(name: "date2", type: "DATETIME")
            column(name: "date3", type: "DATETIME")
            column(name: "date4", type: "DATETIME")
            column(name: "createdBy", type: "BIGINT")
            column(name: "createdDate", type: "DATETIME")
            column(name: "editedBy", type: "BIGINT")
            column(name: "editedDate", type: "DATETIME")
            column(defaultValueNumeric: "0", name: "version", type: "BIGINT") {
                constraints(nullable: "false")
            }
        }
    }

    changeSet(id: "${clid}.4", author: "snimavat") {
        addColumn(tableName: "ArAdjust") {
            column(name: "source", type: "varchar(50)", defaultValue: "RCM") {
                constraints(nullable: "false")
            }
        }

        sql("update ArAdjust set source = 'RCM' where source is null or source='' ")
    }

}



