

databaseChangeLog{
    clid = '9-9-02'

    changeSet(id: "${clid}.1", author: "snimavat") {
        addColumn(tableName: 'ArReason') {
            column(name:'restrictUpdate', type:'int')
        }

    }

    changeSet(id: "${clid}.2", author: "snimavat") {
        dropDefaultValue(tableName:"ArStatus",columnName:"requireBrand" )
        dropColumn(tableName:"ArStatus" , columnName:"requireBrand")
        dropColumn(tableName:"ArStatus" , columnName:"DocState")
        dropColumn(tableName:"ArStatus" , columnName:"IsClosed")
        dropColumn(tableName:"ArStatus" , columnName:"IsDisputed")
    }

    changeSet(id: "${clid}.3", author: "snimavat") {
        dropNotNullConstraint(tableName:"ArReason", columnDataType:"bigint", columnName:"groupId" )
    }


    changeSet(id: "${clid}.4", author: "snimavat") {
        dropDefaultValue(tableName:"AcCorCode",columnName:"ReasonId" )
        dropNotNullConstraint(tableName:"AcCorCode", columnDataType:"bigint", columnName:"ReasonId" )
    }
}