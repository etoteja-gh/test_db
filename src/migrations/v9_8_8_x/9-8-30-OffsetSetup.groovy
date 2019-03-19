package v9_8_8_x

databaseChangeLog{
    clid = '9-8-30-OffsetSetup'

    changeSet(id: "${clid}.1.1", author: "Sudhir") {
        sql "INSERT INTO AcOffsetSetup (id, variable, value, description) values (45, 'enableManualOffset', 'false', 'Enable manual offset of arTrans')"
    }

    changeSet(id: "${clid}.2", author: "Joanna") {
     sql """ INSERT INTO ArStatus (id, name, baseStatusId, closingCmArTranTypeId, ClosingDmArTranTypeId, Description, DocState, InSearch, IsClosed, isDisputed)
			values (12, 'Offset', 12, 33, 43, 'Offset transaction',1, 1, 1, 0 )
		"""
    }

}
