package v9_9_x

databaseChangeLog{
    clid = '9-9-21-TimeZoneServerParam'
    changeSet(author: "Alexey", id: "${clid}.1") {
        sql("insert into AppParam (id, Variable, value) values (49, 'timeZoneServer', 'UTC')")
    }

    changeSet(author: "Joanna", id: "${clid}.2") {
        sql("update AppParam set value='company' where variable='segmentationOrgType' and (value is null or value='') ")
    }
}
