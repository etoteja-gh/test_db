package v9_9_3_y

databaseChangeLog{
    clid = '9-9-3-04-OrgIdChanges'


    changeSet(id: "${clid}.1", author: "Alexey") {
        addColumn(tableName: 'OrgType') {
            column(name: "NewRefnumGeneratorId", type: "BIGINT")
        }

    }
    changeSet(id: "${clid}.2", author: "Joanna") {
        addColumn(tableName: 'Org') {
        	column(defaultValueBoolean: false, name: "inactive", type: "BIT") {
				constraints(nullable: "false")
			}
        }

    }

    changeSet(id: "${clid}.3", author: 'Joanna') {
        sql("""
            insert into AcSetup(id, Variable, CreatedBy, EditedBy, Value)
            select 64, 'requireSplitBalancingMemo', 0, 0, 'true'
        """)
    }



}