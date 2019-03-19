package v9_9_x

databaseChangeLog{
	clid = '9-9-23-bad-debt-tran-type'
	changeSet(author: "Alexey", id: "${clid}.1") {
		sql "insert into ArTranType(id, name, description, version, baseTranTypeId,isOpposingTran, newRefnumGeneratorId) values (60, 'WOCBD', 'write off credit bad debt', 0, 31, 0, 1)"
		sql "insert into ArTranType(id, name, description, version, baseTranTypeId,isOpposingTran, newRefnumGeneratorId) values (61, 'WODBD', ' write off debit bad debt', 0, 41, 0, 1)"
	}
	changeSet(id: "${clid}.2", author: "Alexey") {
		addColumn(tableName: 'ArTranLineType') {
			column(name:'writeOffArReasonId', type: 'BIGINT')
		}

	}
	changeSet(id: "${clid}.3", author: "Alexey") {
		sql "update ArTranLineType SET writeOffArReasonId = 3 where name='Tax' "
		sql "update ArTranLineType SET writeOffArReasonId = 3 where name='Tax2'"
		sql "update ArTranLineType SET writeOffArReasonId = 4 where name='Shipping';"
		sql "update ArTranLineType SET writeOffArReasonId = 4 where name='Handling';"
		sql "update ArTranLineType SET writeOffArReasonId = 5 where name='Revenue';"
		sql "update ArTranLineType SET writeOffArReasonId = 5 where name='Return';"

	}

}
