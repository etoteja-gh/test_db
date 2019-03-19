package v9_8_9_x

databaseChangeLog{
    clid = '9-8-9-02-auth'

    changeSet(id: "${clid}.1", author: "Igor") {
        modifyDataType(tableName: 'Users', columnName: 'Password', newDataType: 'varchar(60)')
    }

}