package v9_9_x

databaseChangeLog{
	clid = "9-9-48-JobWorkflow"

	changeSet(id: "${clid}.1", author: "alexey") {
		createTable(tableName:'JobWorkflow') {
			column(name: 'id', type: 'bigint') {
				constraints(nullable:false, primaryKey:'true')
			}
			column(name: 'name', type:'varchar(50)') {
				constraints(nullable:'false')
			}
			column(name: 'description', type: 'varchar(500)')
			column(name: 'masterJobId', type: 'bigint')
			column(name:'seq', type:'int')
			column(name: "isStopOnFailure", type: "bit", defaultValueBoolean: false) {
				constraints(nullable: "false")
			}
			column(name: 'paramToRun', type: 'varchar(1000)')

			column(name: 'createdBy', type: 'bigint')
			column(name: 'createdDate', type: 'datetime')
			column(name: 'editedBy', type: 'bigint')
			column(name: 'editedDate', type: 'datetime')
			column(defaultValueNumeric: "0", name: "version", type: "bigint") {
				constraints(nullable: "false")
			}
		}
	}

	changeSet(id: "${clid}.2", author: "Alexey") {

		addColumn(tableName: 'JobWorkflow') {
			column(name: "inactive", type: "bit", defaultValueBoolean: false)
		}
	}

	changeSet(id: "${clid}.3", author: "Alexey") {
		modifyDataType(columnName:"name", tableName:"JobWorkflow", newDataType:"VARCHAR(512)")
	}

	changeSet(id: "${clid}.4", author: "snimavat") {
		renameColumn(tableName: "PaymentSetting", newColumnName:"id", oldColumnName:"PaymentId", columnDataType:"bigint(20)")
	}
	changeSet(id: "${clid}.5", author: "joanna") {
		sql """
		insert into AcCorCode (id, name, arTranType, corcodetype, corcodetypeDesc, description, reasonId)
 		values (355, 355, 'WOC', 3, 'Credit memo', 'Auto pay subset sum seq penny off/close enough', null);

		insert into AcCorCode (id, name, arTranType, corcodetype, corcodetypeDesc, description, reasonid)
 		values (455, 455, 'WOD', 4, 'Debit memo', 'Auto pay subset sum seq penny off/close enough', null);
		"""
	}

	changeSet(id: "${clid}.6", author: "joanna") {
		sql """
	INSERT INTO AcMatchSetup (id, Variable, value, GroupId, Description, CreatedBy, CreatedDate, EditedBy, EditedDate, version)
VALUES
	(67, 'runAutoPayIfCorrectionFailedOnUserRows', 'false', 0, NULL, 0, NULL, 0, NULL, 0);
	"""
	}
	
}
