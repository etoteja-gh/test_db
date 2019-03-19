package v9_9_3_y

databaseChangeLog{
	clid = '9-9-3-02-AppParam-NewRefnumGenerator'

	changeSet(id: "${clid}.1", author: 'Ken') {
		sql("""
			insert into AppParam(id, Variable, CreatedBy, EditedBy, Value)
			select 108, 'generateRefnumsFromArTranTypeRanges', 0, 0, Value from Parameters where id=112
		""")
	}

	changeSet(id: "${clid}.2", author: 'Ken') {
		sql("update Parameters set Category='deprecated', Description='Deprecated - use AppParam.generateRefnumsFromArTranTypeRanges' where id=112")
	}
}