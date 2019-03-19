package v9_9_x

databaseChangeLog{
    clid = '9-9-07'

    changeSet(id: "${clid}.1", author: "Sudhir") {
        addColumn(tableName: 'OrgType') {
            column(name: 'inactive', defaultValueBoolean: false, type:'bit'){
                constraints(nullable:"false")
            }
        }
    }

    changeSet(id: "${clid}.2", author: "Sudhir") {
        sql "update OrgType set name='Cust Account' where id=2"
    }

}