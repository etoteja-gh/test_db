package v9_9_x

databaseChangeLog{
	clid = '9-9-12'

	changeSet(id: "${clid}.1", author: "Alexey") {
		createTable(tableName: "OrgMember") {
			column(defaultValueNumeric: "0", name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}
			column(name: "branchId", type: "BIGINT")
			column(name: "divisionId", type: "BIGINT")
			column(name: "businessId", type: "BIGINT")
			column(name: "salesId", type: "BIGINT")
			column(name: 'regionId', type: 'bigint')
			column(name: 'factoryId', type: 'bigint')

			column(defaultValueNumeric: "0", name: "CreatedBy", type: "BIGINT")
			column(name: "CreatedDate", type: "DATETIME")
			column(defaultValueNumeric: "0", name: "EditedBy", type: "BIGINT") {
				constraints(nullable: "false")
			}
			column(name: "EditedDate", type: "DATETIME")
			column(defaultValueNumeric: "0", name: "version", type: "BIGINT")
		}
	}

	changeSet(id: "${clid}.2", author: "Alexey") {
		addColumn(tableName: 'Org') {
			column(name: 'memberId', type: 'bigint')
		}
	}

	changeSet(id: "${clid}.3", author: "Alexey", dbms: "mssql") {
		sql("INSERT INTO OrgMember (version, 			createdBy, 				editedBy, 	   createdDate,    editedDate,    id,    branchId,    divisionId,    businessId,    salesId) " +
				         "SELECT cr.version, ISNULL(cr.createdBy,1), ISNULL(cr.editedBy,1), cr.createdDate, cr.editedDate, cr.id, cr.branchId, cr.divisionId, cr.businessId, cr.salesOrgId FROM CustRelated cr where cr.id > -1 ")
	}
	changeSet(id: "${clid}.3.1", author: "Alexey", dbms: "oracle") {
		sql("INSERT INTO OrgMember (version, 			createdBy, 				editedBy, 	   createdDate,    editedDate,    id,    branchId,    divisionId,    businessId,    salesId) " +
				         "SELECT cr.version, nvl(cr.createdBy,1), nvl(cr.editedBy,1), cr.createdDate, cr.editedDate, cr.id, cr.branchId, cr.divisionId, cr.businessId, cr.salesOrgId FROM CustRelated cr where cr.id > -1 ")
	}
	changeSet(id: "${clid}.3.2", author: "Alexey", dbms: "mysql") {
		sql("INSERT INTO OrgMember (version, createdBy, editedBy, createdDate, editedDate, id, branchId, divisionId, businessId, salesId) " +
				"SELECT cr.version, IFNULL(cr.createdBy,1), IFNULL(cr.editedBy,1), cr.createdDate, cr.editedDate, cr.id, cr.branchId, cr.divisionId, cr.businessId, cr.salesOrgId FROM CustRelated cr where cr.id > -1 ")
	}


	changeSet(id: "${clid}.4", author: "Alexey",  ) {
		// take from rootOrgId for branch (division) and division (business)
		sql """ insert into OrgMember (id) select id from Org where rootOrgId is not null
				and not exists (select 1 from OrgMember om where om.id=Org.id)"""

		sql """update OrgMember set
			divisionId = (select o.rootOrgId from Org o  where   o.orgtypeId=3 and OrgMember.id=o.id)
			where exists (select 1 from Org o  where   o.orgtypeId=3 and OrgMember.id=o.id)     """
		sql """update OrgMember set businessId = (select o.rootOrgId from Org o where  o.orgtypeId=4 and OrgMember.id=o.id)
				where exists (select 1 from Org o  where  o.orgtypeId=4 and OrgMember.id=o.id) """
	}

	changeSet(id: "${clid}.5", author: "Alexey",  ) {
		sql "UPDATE Org  set memberId =  (select id from OrgMember cr WHERE Org.id=cr.id)"
	}


	changeSet(author: "Alexey", id: "${clid}.6") {
		dropIndex(indexName: "IX_CustRelated_divisionId", tableName: "CustRelated")
		dropIndex(indexName: "ix_CustRelated_salesOrgId", tableName: "CustRelated")
		dropColumn(tableName:"CustRelated" , columnName:"branchId")
		dropColumn(tableName:"CustRelated" , columnName:"divisionId")
		dropColumn(tableName:"CustRelated" , columnName:"businessId")
		dropColumn(tableName:"CustRelated" , columnName:"salesOrgId")
	}

	changeSet(author: "Alexey", id: "${clid}.7") {
		createIndex(tableName:"OrgMember", indexName:"IX_OrgMember_divisionId"){
	   		column(name:"divisionId")
		}
		createIndex(tableName:"OrgMember", indexName:"IX_OrgMember_branchId"){
	   		column(name:"branchId")
		}
		createIndex(tableName:"Org", indexName:"IX_Org_memberId"){
	   		column(name:"memberId")
		}
	}


	changeSet(id: "${clid}.8", author: "Joanna" ) {
		sql """
			INSERT INTO OrgType (id, 	name, description) values (10, 'Factory', 'Factory');
			INSERT INTO OrgType (id, 	name, description) values (11, 'Region', 'Region');
			update OrgType set description='Sales' where name='Sales';
		"""

	}
}
