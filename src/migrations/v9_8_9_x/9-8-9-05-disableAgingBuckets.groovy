package v9_8_9_x

databaseChangeLog{
	clid = '9-8-9-05-disalbeAgingBuckets'

    changeSet(id: "${clid}.2", author: "Sudhir") {
        sql("UPDATE ArAgingBucketSetup set IsUsed  = 0 where id not in (1,2,3,10)")
    }

    changeSet(id: "${clid}.6", author: "snimavat") {
        sql("insert into AppParam (id, Variable, value) values (281, 'ApplyOnlyWithinLowestHierarchyLevel', 'false')")
    }

}
