package v9_9_x

databaseChangeLog{
    clid = '9-9-17-Lockbox'
    changeSet(author: "Alexey", id: "${clid}.1") {
        dropColumn(tableName:"Lockbox" , columnName:"isCross")
        dropColumn(tableName:"Lockbox" , columnName:"isDefault")
        dropColumn(tableName:"Lockbox" , columnName:"isTransfer")
    }
    changeSet(id: "${clid}.2", author: "Alexey") {
        addColumn(tableName: 'Lockbox') {
            column(name: 'orgId', type: 'BIGINT')
        }
        sql "update Lockbox set orgId=divisionId where divisionId is not null;"
        sql "update Lockbox set orgId=businessId where businessId is not null;"
        sql "update Lockbox set orgId=companyId where companyId is not null;"
    }
    changeSet(author: "Alexey", id: "${clid}.3") {
        dropColumn(tableName:"Lockbox" , columnName:"divisionId")
        dropColumn(tableName:"Lockbox" , columnName:"businessId")
        dropColumn(tableName:"Lockbox" , columnName:"companyId")
    }
    changeSet(author: "Joanna", id: "${clid}.4") {
        sql("update AppParam set value='true' where variable='generateCustNum' ")
    }
}
