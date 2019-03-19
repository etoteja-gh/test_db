package v9_9_3_y.dev

databaseChangeLog{
    clid = '9-9-01-ReportsIntegrated'

	changeSet(id: "${clid}.1", author: "Joanna") {
		sql("""
			insert into Report(id, name,description, FilterScreen, fileName, format, orgId)
			values (50,'Aging CustAccount','Cust Account Aging integrated report', 'CustAccount', 'CustAccountAging_int.jrxml', 'PDF', null);

			insert into Report(id, name,description, FilterScreen, fileName, format, orgId)
			values (51,'Aging Customer','Customer  Aging integrated report', 'Customer', 'CustomerAging_int.jrxml', 'PDF', null);

			insert into Report(id, name,description, FilterScreen, fileName, format, orgId)
			values (52,'By Status','ArTran by status integrated report', 'ArTran', 'ArTranByStatus_int.jrxml', 'PDF', null);

			""");
	}

}
