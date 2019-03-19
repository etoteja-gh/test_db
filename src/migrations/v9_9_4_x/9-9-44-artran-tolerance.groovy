package v9_9_x

databaseChangeLog {
	clid = "9-9-44-artran-tolerance"

	changeSet(id: "${clid}.1", author: "snimavat") {
		sql """insert into ArTranLineType (id, code, name, kind, glAcct) values (10, 'Balancing', 'Balancing', 'Memo', '9999')"""
		sql("insert into AppParam (id, Variable, value) values (4012, 'glValidateAmountTolerance', '0')")
	}

	changeSet(id: "${clid}.2", author: "Joanna") {
		sql("insert into AppParam (id, Variable, value) values (4013, 'glPostPeriodChangeToCurrentPeriodBegDateIfFromOldPeriod', 'false')")
		sql("insert into AppParam (id, Variable, value) values (4014, 'autoChangeGlPostDateToOpenPeriodBegOrEndDate', 'false')")
	}


}