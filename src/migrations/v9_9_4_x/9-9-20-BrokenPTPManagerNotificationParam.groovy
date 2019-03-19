package v9_9_x

databaseChangeLog{
    clid = '9-9-20-BrokenPTPManagerNotificationParam'
    changeSet(author: "Alexey", id: "${clid}.1") {
        sql("insert into AppParam (id, Variable, value) values (106, 'brokenPTPManagerNotification', 'true')")
    }

    changeSet(author: "Joanna", id: "${clid}.2") {
        sql("""
        	insert into Report (id, name, filename, description, format, orgId) values (1, 'Invoice', 'invoicelist.jrxml', 'Invoice on demand', 'PDF', null);
			insert into Report (id, name, filename, description, format, orgId) values (2, 'Cust Statement', 'Cust OnDemand Statement.jrxml', 'Customer statement on demand', 'PDF', null);
			insert into Report (id, name, filename, description, format, orgId) values (3, 'CustAccount Statement', 'Div OnDemand Statement List.jrxml', 'CustAccount statement on demand', 'PDF', null);


        """)
    }
}
