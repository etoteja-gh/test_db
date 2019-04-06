databaseChangeLog {
    clid = '9-9-03-PayApi'
    changeSet(id: "${clid}.1", author: "alexey") {
        addColumn(tableName: "PaymentsApi") {
            column(name: "custName", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "text1", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "text2", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "text3", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "num1", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "num2", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "num3", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "date1", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "date2", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "date3", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "editedDate", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "createdBy", type: "numeric") {
                constraints(nullable: "true")
            }
            column(name: "editedBy", type: "numeric") {
                constraints(nullable: "true")
            }
        }
    }

    changeSet(id: "${clid}.2", author: "alexey") {
        addColumn(tableName: "PaymentDetailApi") {
            column(name: "comments", type: "text") {
                constraints(nullable: "true")
            }
            column(name: "text1", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "text2", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "text3", type: "char(50)") {
                constraints(nullable: "true")
            }
            column(name: "num1", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "num2", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "num3", type: "DECIMAL(19, 4)") {
                constraints(nullable: "true")
            }
            column(name: "date1", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "date2", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "date3", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "editedDate", type: "datetime(6)") {
                constraints(nullable: "true")
            }
            column(name: "createdBy", type: "numeric") {
                constraints(nullable: "true")
            }
            column(name: "editedBy", type: "numeric") {
                constraints(nullable: "true")
            }
        }
    }

    changeSet(id: "${clid}.3", author: "alexey") {
        dropNotNullConstraint(tableName:"PaymentDetailApi", columnDataType:"bigint", columnName:"recordNum" )
    }
}