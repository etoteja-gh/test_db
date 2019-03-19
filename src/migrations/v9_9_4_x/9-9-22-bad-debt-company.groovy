package v9_9_x

databaseChangeLog{
	clid = '9-9-22-bad-debt-company'
	changeSet(author: "snimavat", id: "${clid}.1", context: "dev") {
		sql "delete from Company where id = 3"
		sql "delete from Org where id = 3"
	}

	changeSet(author: "snimavat", id: "${clid}.2") {
		sql "insert into Company(id, name, num, version) values (5, 'Bad Debt Company', 'BD', 0)"
		sql "insert into Org(id, name, num, orgTypeId, version) values (5, 'Bad Debt Company', 'BD', 6, 0)"
		sql "update Org set companyId=id where companyId is null and orgTypeId=6"
		sql "update Org set companyId =(select c.companyId from Customer c, CustAccount ca where c.id=ca.custId and ca.id=Org.id) where orgTYpeId=2 and companyId is null;"
		sql "update Org set companyId=2 where companyId is null"
		sql "update Customer set companyId=2 where companyId is null"

		sql("insert into AppParam (id, Variable, value) values (1395, 'allowSwitchCompany', 'false')")
		sql("insert into AppParam (id, Variable, value) values (1396, 'companyAccessRestriction', 'false')")
	}

	changeSet(author: "snimavat", id: "${clid}.3") {
		sql """
              update ArTran
              SET companyId = (select c.companyId FROM  Customer c WHERE ArTran.custId = c.id);
        """
	}


	changeSet(id: "${clid}.4", author: "snimavat") {
		createTable(tableName: "SpringSecurityEvent") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}
			column(name: "username", type: "VARCHAR(255)")
			column(name: "sessionId", type: "VARCHAR(255)")
			column(name: "eventName", type: "VARCHAR(255)")
			column(name: "remoteAddress", type: "VARCHAR(255)")
			column(name: "switchedUsername", type: "VARCHAR(255)")
			column(name: "dateCreated", type: "DATETIME")
		}
	}

	changeSet(author: "Joanna", id: "${clid}.5") {
		sql """
		update ArStatus set closingCmArTrantypeId=31, closingDmArTranTypeId=41 where id=4;
		 """
	}
	changeSet(author: "Joanna", id: "${clid}.6") {
		sql """
		delete from Company where id = 2 and num in ('US', 'Comp1');
		delete from Org where id = 2 and num in ('US', 'Comp1');

		insert into Company(id, name, num, version) values (2, 'Main Company', 'Main', 0);
		insert into Org(id, name, num, orgTypeId,companyId, version) values (2, 'Main Company', 'Main', 6,2, 0);

		update Org set calcId=id where exists (select 1 from OrgCalc c where c.id=Org.id);
		update Org set infoId=id where exists (select 1 from OrgInfo f where f.id=Org.id);
		update Org set locationId=id where exists (select 1 from Location f where f.id=Org.id);

		delete from Company where id = 4 and num='app';
		delete from Org where id = 4 and num='app';

		update ArTran set companyId=2 where not exists (select 1 from Org c where c.id=ArTran.companyId);
		update Org set companyId=2 where not exists (select 1 from Company c where c.id=Org.companyId);
		update Customer set companyId=2 where not exists (select 1 from Company c where c.id=Customer.companyId);
		"""
	}


}
