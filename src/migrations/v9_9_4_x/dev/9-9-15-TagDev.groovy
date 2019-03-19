package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-15'

	changeSet(author: "Alexey", id: "${clid}.6",  context:'dev') {
		sql("INSERT INTO Tag(id, name, entityName, createdBy, editedBy, version) values (500, 'REVIEW', 'Customer', 0, 0, 0)")
		sql("INSERT INTO Tag(id, name, entityName, createdBy, editedBy, version) values (501, 'REVIEW', 'CustAccount', 0, 0, 0)")
	}
}
