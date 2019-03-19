package v9_9_x

databaseChangeLog{
    clid = '9-9-10'

    changeSet(id: "${clid}.1", author: "Joanna") {
        addDefaultValue(tableName:"CustAccount",columnName:"inactive" ,defaultValueBoolean: false)
    }

    changeSet(id: "${clid}.2", author: "snimavat") {
        sql "update CustAccount SET inactive = 0 where inactive is NULL;"
    }

    // See dev/9-9-10-custAccountDev.groovy for stuff that was split off.

}