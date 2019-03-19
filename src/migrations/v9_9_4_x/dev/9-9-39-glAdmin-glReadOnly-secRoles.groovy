package v9_9_x.dev

databaseChangeLog{
	clid = '9-9-39-glAdmin-glReadOnly-secRoles'

	changeSet(id: "${clid}.1", author: "Nikita", context:'dev') {
		sql "insert into SecRole (id, name, description, inactive) values (15, 'GL Admin', 'GL Admin', 0)"
		sql "insert into SecRole (id, name, description, inactive) values (16, 'GL Read Only', 'GL Read Only', 0)"
	}
	changeSet(id: "${clid}.2", author: "Joanna", context:'dev') {
		sql "update AppParam set value='false' where variable='custAccountReqOnArTran'; "
	}
}