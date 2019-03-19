package v9_8_9_x

databaseChangeLog = {
    clid = '9-8-9-07-postPaymentWarning'

	changeSet(id: "${clid}.1", author: "Alexey") {
		sql("insert into AcSetup (id, Variable, value, description) values (65, 'postPaymentWarningForNewTransCreated', '1000', 'Warn user on post when payment has >value new transactions.')")
	}

}
