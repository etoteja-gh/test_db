package v9_9_x

databaseChangeLog{
	clid = '9-9-42'


	changeSet(id: "${clid}.1", author: "Alexey") {
		addColumn(tableName: 'Report') {
			column(name:'type', type:'varchar(50)'){
			}
		}

		addColumn(tableName: 'Report') {
			column(name:'json', type: "text"){}
			column(name:'rootDomain', type: "varchar(50)"){}
		}
		sql """
            update Report set type='Jasper';
        """
	}

	changeSet(id: "${clid}.2", author: "Alexey") {
		addColumn(tableName: 'Report') {
			column(name:'reportFilterId', type: "BIGINT"){
			}
		}

	}
}
