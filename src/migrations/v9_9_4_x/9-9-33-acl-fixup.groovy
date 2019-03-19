package v9_9_x

databaseChangeLog{
	clid = '9-9-33-acl-fixup'

	// See dev/9-9-04-SecRoleCleanupDev for stuff that was split off.
	/* 1 Administrator
	 * 2 Power User          (was basic)
	 * 3 Manager             (was guest)
	 * 4 Guest               (was client)
	 * 5 Customer
	 * 6 Collections         1001 (was autocash manager)
	 * 7 Collections Manager 1000 (was autocash basic)
	 * 8 Autocash            (was zero dollar batch)
	 * 9 Autocash Manager
	 * 10 Autocash Offset
	 * 11 Admin Config
	 * 12 Admin Sec
	 * 13 Sales              1002
	 * 14 Branch
	 */
	changeSet(id: "${clid}.1", author: "Ken") {
		// based on the above data, this script only moves roles which exist in dev data. Dev data has been historically what we send to the customer, so the 1000 roles are likely to exist there.
		sql "update AclAuths set RoleId=4 where RoleId=3" // moving guest
		sql "update AclAuths set RoleId=9 where RoleId=6" // moving autocash manager
		sql "update AclAuths set RoleId=8 where RoleId=7" // moving autocash basic
		sql "update AclAuths set RoleId=7 where RoleId=1000" // moving collections manager
		sql "update AclAuths set RoleId=6 where RoleId=1001" // moving collections
	}

	changeSet(id: "${clid}.2", author: "snimavat") {
		sql("""insert into AcMatchSetup (id, Variable, value, description)
			values (66, 'searchAutoPayAcrossOtherCompanies', 'false','AutoPay search in other companies')""")

		addColumn(tableName: "ArTranMatch") {
			column(name: "companyId", type: "bigint")
		}

		sql("update ArTranMatch set companyId=(select companyId from ArTran where ArTran.id=ArTranMatch.id)")
	}


	changeSet(id: "${clid}.3", author: "snimavat", context: "test") {
		//keep default behavior for tests, which is search across companies
		sql("update AcMatchSetup set value = 'true' where variable = 'searchAutoPayAcrossOtherCompanies'")
	}


}