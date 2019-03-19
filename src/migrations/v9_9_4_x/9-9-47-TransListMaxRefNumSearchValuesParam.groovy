package v9_9_x

databaseChangeLog{
    clid = '9-9-47-TransListMaxRefNumSearchValues'

    changeSet(author: "Alexey", id: "${clid}.1") {
        sql("insert into AppParam (id, Variable, value) values (4018, 'TransListMaxRefNumSearchValues', 20)")
    }

    changeSet(author: "snimavat", id: "${clid}.2") {
        sql("insert into AppParam (id, Variable, value) values (4019, 'custFamilyLimitForLowestHierarchyLevel', 'false')")
    }

    changeSet(id: "${clid}.3", author: "snimavat") {
        sql("insert into AppParam (id, Variable, value) SELECT 4020, 'useNewRefNumGenerator', VALUE from Parameters where Variable = 'useNewRefNumGenerator'")
        sql("insert into AppParam (id, Variable, value) SELECT 4021, 'defaultBusiness', VALUE from Parameters where Variable = 'defaultBusiness'")
        sql("insert into AppParam (id, Variable, value) SELECT 4022, 'denormalizeArAdjust', VALUE from Parameters where Variable = 'denormalizeArAdjust'")
    }

}
