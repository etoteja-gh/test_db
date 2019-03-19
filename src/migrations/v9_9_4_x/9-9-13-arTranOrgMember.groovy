package v9_9_x

databaseChangeLog{
	clid = '9-9-13'

	changeSet(id: "${clid}.1", author: "Alexey") {
		createTable(tableName: "ArTranOrgMember") {
			column(defaultValueNumeric: "0", name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true")
			}
			column(name: "branchId", type: "BIGINT")
			column(name: "divisionId", type: "BIGINT")
			column(name: "businessId", type: "BIGINT")
			column(name: "salesId", type: "BIGINT")
			column(name: 'regionId', type: 'BIGINT')
			column(name: 'factoryId', type: 'BIGINT')

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
		addColumn(tableName: 'ArTran') {
			column(name: 'orgMemberId', type: 'bigint')
		}
	}

	changeSet(id: "${clid}.3", author: "Alexey" ) {
		// insert based on custAccount or customer OrgMember
		sql("""
			INSERT INTO ArTranOrgMember (version,	createdBy, 	editedBy, 	createdDate,	editedDate,    id,    branchId,    divisionId,    businessId,    salesId)
				SELECT om.version, om.createdBy, om.editedBy, om.createdDate, om.editedDate, t.id, om.branchId, om.divisionId, om.businessId, om.salesId
				FROM OrgMember om, ArTran t where om.id=t.custAccountId and custAccountId is not null;

			INSERT INTO ArTranOrgMember (version,	createdBy, 	editedBy, 	createdDate,	editedDate,    id,    branchId,    divisionId,    businessId,    salesId)
				SELECT om.version, om.createdBy, om.editedBy, om.createdDate, om.editedDate, t.id, om.branchId, om.divisionId, om.businessId, om.salesId
				FROM OrgMember om, ArTran t where om.id=t.custId and custAccountId is  null
				and not exists (select 1 from ArTranOrgMember am where am.id=t.id)

		""")

	}
	changeSet(id: "${clid}.4", author: "Alexey",  ) {
		sql "UPDATE ArTran set orgMemberId =  (select id from ArTranOrgMember cr WHERE ArTran.id=cr.id)"
	}

	changeSet(author: "Alexey", id: "${clid}.5") {
		dropIndex(tableName: 'ArTranRelated', indexName: 'ix_ArTranRelated_salesOrgId')
		dropColumn(tableName:"ArTranRelated" , columnName:"branchId")
		dropColumn(tableName:"ArTranRelated" , columnName:"divisionId")
		dropColumn(tableName:"ArTranRelated" , columnName:"businessId")
		dropColumn(tableName:"ArTranRelated" , columnName:"salesOrgId")
	}

	changeSet(author: "Alexey", id: "${clid}.6") {
		createIndex(tableName:"ArTranOrgMember", indexName:"IX_ArTranOrgMember_divisionId"){
	   		column(name:"divisionId")
		}
		createIndex(tableName:"ArTranOrgMember", indexName:"IX_ArTranOrgMember_branchId"){
	   		column(name:"branchId")
		}
		createIndex(tableName:"ArTran", indexName:"IX_ArTran_orgMemberId"){
	   		column(name:"orgMemberId")
		}
	}
}
