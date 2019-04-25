databaseChangeLog {
    clid = '9-9-04-CustStats'
    changeSet(id: "${clid}.1", author: "alexey") {
        addColumn(tableName: "CustStats") {
            column(name: 'hasArTransInHistory', defaultValueBoolean: false, type:'bit'){
                constraints(nullable:"false")
            }
            column(name: "historyMessage", type: "char(50)") {
                constraints(nullable: "true")
            }
        }
    }
}