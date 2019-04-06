
databaseChangeLog{
    clid = '9-9-02-PaymentOcr'
    changeSet(id: "${clid}.1", author: "alexey") {
        createTable(tableName: "PaymentOcr") {
            column(name: "id", type: "BIGINT") {
                constraints(nullable: "false", primaryKey: "true")
            }

            column(name: "paymentId", type: "BIGINT") { constraints(nullable: "false") }
            column(name: "fileName", type: "VARCHAR(50)")
            column(name: "status", type: "BIGINT")
            column(name: 'receivedDate', type: 'datetime')
            column(name: 'json', type: 'text')

            column(name: "version", type: "bigint")
            column(name: 'createdBy', type: 'bigint')
            column(name: 'createdDate', type: 'datetime')
            column(name: 'editedBy', type: 'bigint')
            column(name: 'editedDate', type: 'datetime')
        }
    }
}