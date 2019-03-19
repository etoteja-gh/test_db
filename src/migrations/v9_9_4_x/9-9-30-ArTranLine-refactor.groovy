
databaseChangeLog {
	clid = '9-9-30-ArTranLine-refactor'

	property(name:"isnull", value:"isnull", dbms:"mssql")
    property(name:"isnull", value:"ifnull", dbms:"mysql")

	changeSet(id: "1", author: 'Ken') {
		sql "drop table ArTranLineType"
	}

	changeSet(id: "${clid}.2", author: 'Ken' ) {
		createTable(tableName:'ArTranLineType') {
			column(name: 'id', type: 'bigint') {
				constraints(nullable:false, primaryKey:'true')
			}
			column(name: 'code', type:'varchar(10)') {
				constraints(nullable:false)
			}
			column(name: 'name', type:'varchar(50)') {
				constraints(nullable:'false')
			}
			column(name: 'kind', type: 'varchar(10)') {
				constraints(nullable:'false')
			}
			column(name: 'glAcct', type: 'varchar(50)')
			column(name: 'sourceId', type: 'varchar(50)')
			column(name: "inactive", type: "bit", defaultValueBoolean: false) {
				constraints(nullable: "false")
			}
			column(name: "invisible", type: "bit", defaultValueBoolean: false) {
				constraints(nullable: "false")
			}
			column(name: "isSystem", type: "bit", defaultValueBoolean: false) {
				constraints(nullable: "false")
			}
			column(name: 'writeOffArReasonId', type: 'bigint')
			column(name: 'createdBy', type: 'bigint')
			column(name: 'createdDate', type: 'datetime')
			column(name: 'editedBy', type: 'bigint')
			column(name: 'editedDate', type: 'datetime')
			column(defaultValueNumeric: "0", name: "version", type: "bigint") {
				constraints(nullable: "false")
			}
		}
	}

	changeSet(id: "${clid}.3", author: 'Ken') {
		createTable(tableName:'ArTranLineItem') {
			column(name: 'id', type: 'bigint') {
				constraints(nullable:false, primaryKey:'true')
			}

			column(name: 'costAmount', type:'numeric(19,4)')
			column(name: 'qty', type: 'NUMERIC(19,4)', defaultValueNumeric: '0') {
				constraints(nullable:'false')
			}
			column(name: 'unitPrice', type: 'numeric(19,4)', defaultValueNumeric: '0') {
				constraints(nullable:'false')
			}
			column(name: 'unitOfMeasure', type:'varchar(50)')
			column(name: 'discAmount', type: 'numeric(19,4)', defaultValueNumeric: '0') {
				constraints(nullable:'false')
			}
			column(name: 'discPct', type: 'numeric(9,6)', defaultValueNumeric: '0') {
				constraints(nullable:'false')
			}
			column(name: 'orderNum', type: 'varchar(50)')
			column(name: 'itemId', type: 'bigint') {
				constraints(nullable:'false')
			}
			column(name: 'name', type:'varchar(50)')
			column(name: 'code', type:'varchar(10)')
			column(name: 'num', type:'varchar(50)')
			column(name: 'kind', type: 'varchar(10)') {
				constraints(nullable:'false')
			}
			column(name: 'createdBy', type: 'bigint')
			column(name: 'createdDate', type: 'datetime')
			column(name: 'editedBy', type: 'bigint')
			column(name: 'editedDate', type: 'datetime')
			column(defaultValueNumeric: '0', name: 'version', type: 'bigint')
		}
	}

	changeSet(id: "${clid}.4", author: 'Ken' ) {
		createTable(tableName: 'Item') {
			column(defaultValueNumeric: '0', name: 'id', type: 'BIGINT') {
				constraints(nullable: 'false', primaryKey: 'true')
			}
			column(name: 'code', type:'varchar(10)') {
				constraints(nullable:false)
			}
			column(name: 'num', type:'varchar(50)')
			column(name: 'name', type: 'VARCHAR(50)') {
				constraints(nullable:false)
			}
			column(name: 'description', type: 'VARCHAR(255)')
			column(name: 'unitPrice', type: 'numeric(19,4)', defaultValueNumeric: '0') {
				constraints(nullable:'false')
			}
			column(name: 'unitOfMeasure', type:'varchar(50)')
			column(name: 'glAcctIncome', type: 'VARCHAR(50)')
			column(name: 'glAcctExpense', type:'varchar(50)')
			column(name: 'glAcctInventory', type:'varchar(50)')
			column(name: 'kind', type:'varchar(10)') {
				constraints(nullable: false)
			}
			column(name: 'lineTypeId', type: 'bigint')
			column(name: 'createdBy', type: 'BIGINT')
			column(name: 'createdDate', type: 'DATETIME')
			column(name: 'editedBy', type: 'BIGINT')
			column(name: 'editedDate', type: 'DATETIME')
			column(defaultValueNumeric: '0', name: 'version', type: 'BIGINT')
		}
	}

	changeSet(id: "${clid}.4.1.mssql", author: 'Joanna') {
		//def sqlscript = insertSystemArTranLineItems('isnull')
		sql('''
			insert into ArTranLineItem
			(id, costAmount, qty, unitPrice, unitOfmeasure, discAmount, discPct, orderNum, itemId, name, code, num, kind,
			createdDate , editedDate, createdBy, editedBy, version)
			select l.id, 0, units, l.unitPrice, uom, discAmount, discPercent, orderNum,
			${isnull}(itemId, case when arTranLineTypeId =5 then 2
								when arTranLineTypeId =2 then 3
								when arTranLineTypeId =10 then 5 end),
			${isnull}(i.name,l.description),
			${isnull}(i.code,
				${isnull}(itemCode,
					case when l.arTranLineTypeId =5 then 'Product'
						when l.arTranLineTypeId =2 then 'Shipping'
						when arTranLineTypeId =10 then 'SvcCharge'
					end )
			),
			null,
			case when arTranLineTypeId =5 then 'Product'
				when arTranLineTypeId =2 then 'Shipping'
				when arTranLineTypeId =10 then 'SvcCharge'
			end ,
			l.createdDate , l.editedDate, l.createdBy, l.editedBy, l.version
			from ArTranLine l left outer join Item i on  l.itemId=i.id where l.arTranLineTypeId in (2,5,10)
		''')
	}

	// changeSet(id: "${clid}.4.1.mysql", dbms:'mysql', author: 'Joanna') {
	// 	sql(insertSystemArTranLineItems('ifnull'))
	// }

	changeSet(id: "${clid}.5", author: 'Ken') {
		dropColumn(tableName:'ArTranLine', columnName:'discAmount')
		dropColumn(tableName:'ArTranLine', columnName:'discPercent')
		dropColumn(tableName:'ArTranLine', columnName:'itemCode')
		dropColumn(tableName:'ArTranLine', columnName:'itemTypeId')
		dropColumn(tableName:'ArTranLine', columnName:'orderNum')
		dropColumn(tableName:'ArTranLine', columnName:'uom')
		dropColumn(tableName:'ArTranLine', columnName:'unitPrice')
		dropColumn(tableName:'ArTranLine', columnName:'units')
	}

	changeSet(id: "${clid}.6", author: 'Ken') {
		renameColumn(tableName:'ArTranLine', oldColumnName:'arTranLineTypeId', newColumnName:'lineTypeId', columnDataType:'bigint')
		renameColumn(tableName:'ArTranLine', oldColumnName:'itemId', newColumnName:'lineItemId', columnDataType:'bigint')
		renameColumn(tableName:'ArTranLineSum', oldColumnName:'discTotal', newColumnName:'discAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArTranLineSum', oldColumnName:'serviceCharge', newColumnName:'svcChargeAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArTranLineSum', oldColumnName:'shipping', newColumnName:'shippingAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArTranLineSum', oldColumnName:'taxTotal', newColumnName:'taxAmount', columnDataType:'numeric(19,4)')
	}

	changeSet(id: "${clid}.7", author: 'Ken') {
		addDefaultValue(tableName:'ArTranLine', columnName:'lineTypeId', defaultValueNumeric:'1')
		addColumn(tableName:'ArTranLine') {
			column(name: 'comments', type: 'varchar(255)')
			column(name: 'lineSequence', type:'BIGINT')
			column(name: 'taxCode', type:'varchar(10)')
			column(name: 'taxPct', type:'numeric(9,6)', defaultValueNumeric: "0")
			column(name: 'invisible', type:'bit', defaultValueBoolean:'false') {
				constraints(nullable:'false')
			}
			column(name: 'kind', type:'varchar(10)')
		}
		addColumn(tableName:'ArTranLineSum') {
			column(name:'taxCode', type:'varchar(10)')
		}
		addNotNullConstraint(tableName: 'ArTranLine', columnName: 'amount', columnDataType: 'numeric(19,4)', defaultNullValue:'0')
	}

	changeSet(id: "${clid}.8", author: 'Ken') {
		sql("update ArTranLine set taxCode='tax' where taxable=1")
	}

	changeSet(id: "${clid}.9", author: 'Ken') {
		dropDefaultValue(tableName:'ArTranLine',columnName:'taxable')
		dropDefaultValue(tableName:'ArTranLine',columnName:'taxable2')
		dropColumn(tableName:'ArTranLine', columnName:'productId')
		dropColumn(tableName:'ArTranLine', columnName:'taxable')
		dropColumn(tableName:'ArTranLine', columnName:'taxable2')
	}

	/** Two closures here to dry out the next two changesets.
	 * There is a tiny difference between mysql and mssql, the getdate() or now() functions.
	 */
	changeSet(id: "${clid}.10.mysql", author: 'Ken') {
		def sqlscript = ""
		[
			[1, 'Memo', null],
			[2, 'Item', null],
			[5, 'Tax', 3],
			[7, 'Discount', null],
			[8, 'Journal', null],
			[9, 'Comments', null]
		].each  { id, name, woReason ->
			sqlscript += """insert into ArTranLineType (id, code, name, kind, sourceId, writeOffArReasonId,
				isSystem, createdBy, createdDate) values (${id}, '${name}', '${name}', '${name}',
				'${name}', ${woReason}, 1, 1, CURRENT_TIMESTAMP);"""
		}
		sql(sqlscript)

		sqlscript = ""
		[[1, 'Service'],[2, 'Product'], [3, 'Shipping'], [5, 'SvcCharge'], [6, 'FinCharge'],[7, 'Other']]
		.each { id, name ->
			sqlscript += """insert into Item(id, code, name, kind, createdBy, createdDate)
			values (${id}, '${name}', '${name}', '${name}', 1, CURRENT_TIMESTAMP);"""
		}
		sql(sqlscript)
	}

	changeSet(id: "${clid}.11", author: 'Ken') {
		//         OLD     NEW
		// TAX     1,6     5
		// MEMO    4       1
		// ITEM    5       2
		// This is an attempt to reconcile the old ArTranLineType values to the new ones.  It's not a great fit.
		sql "update ArTranLine set lineTypeId=-999 where lineTypeId=5"
		sql "update ArTranLine set lineTypeId=5 where lineTypeId=1 or lineTypeId=6"  //TAX
		sql "update ArTranLine set lineTypeId=1 where lineTypeId=4"   //memo
		sql "update ArTranLine set lineTypeId=2 where lineTypeId=-999"  //item
	}

	changeSet(id: "${clid}.12.2", author: 'snimavat') {

		// have to drop index before changing column
   		dropIndex(tableName:"ArTranLine" , indexName:"ix_ArTranLine_arTranId")
		addNotNullConstraint(tableName: 'ArTranLine', columnName: 'kind', columnDataType: 'varchar(50)', defaultNullValue:'Memo')
		addNotNullConstraint(tableName: 'ArTranLine', columnName: 'arTranId', columnDataType: 'BIGINT')
		addNotNullConstraint(tableName: 'ArTranLine', columnName: 'lineTypeId', columnDataType: 'BIGINT')
		addNotNullConstraint(tableName: 'ArTranLine', columnName: 'amount', columnDataType: 'numeric(19,4)')
		createIndex( tableName:"ArTranLine", indexName:"ix_ArTranLine_arTranId"){
	   		column(name:"arTranId")
	   	}
	}

	changeSet(id: "${clid}.13", author: 'Ken') {
		renameColumn(tableName:'ArApi', oldColumnName:'lineSum.taxTotal', newColumnName:'lineSum.taxAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArApi', oldColumnName:'lineSum.discTotal', newColumnName:'lineSum.discAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArApi', oldColumnName:'lineSum.shipping', newColumnName:'lineSum.shippingAmount', columnDataType:'numeric(19,4)')
		renameColumn(tableName:'ArApi', oldColumnName:'lineSum.serviceCharge', newColumnName:'lineSum.svcChargeAmount', columnDataType:'numeric(19,4)')

		//remove old columns
		dropColumn(tableName:'ArApi', columnName:'line.discPercent')
		dropColumn(tableName:'ArApi', columnName:'line.discAmount')
		dropColumn(tableName:'ArApi', columnName:'line.taxable')
		dropColumn(tableName:'ArApi', columnName:'line.units')
		dropColumn(tableName:'ArApi', columnName:'line.unitPrice')
		dropColumn(tableName:'ArApi', columnName:'line.itemId')
		dropColumn(tableName:'ArApi', columnName:'line.itemType')
		dropColumn(tableName:'ArApi', columnName:'line.orderNum')
		dropColumn(tableName:'ArApi', columnName:'line.uom')
		dropColumn(tableName:'ArApi', columnName:'line.itemCode')

		//add new columns
		addColumn(tableName:'ArApi') {
			//line fields
			column(name:'line.comments', type:'VARCHAR(255)')
			column(name:'line.invisible', type:'BIT')
			column(name:'line.lineType.id', type:'BIGINT')
			column(name:'line.taxCode', type:'VARCHAR(10)')
			column(name:'line.taxPct', type:'NUMERIC(9,6)')
			column(name:'line.lineSequence', type:'INT')
			column(name:'line.kind', type:'VARCHAR(50)')

			column(name:'line.lineItem.costAmount', type:'NUMERIC(19,4)')
			column(name:'line.lineItem.qty', type:'NUMERIC(19,4)')
			column(name:'line.lineItem.unitPrice', type:'NUMERIC(19,4)')
			column(name:'line.lineItem.unitOfMeasure', type:'VARCHAR(50)')
			column(name:'line.lineItem.discAmount', type:'NUMERIC(19,4)')
			column(name:'line.lineItem.discPct', type:'NUMERIC(9,6)')
			column(name:'line.lineItem.orderNum', type:'VARCHAR(50)')
			column(name:'line.lineItem.kind', type:'VARCHAR(50)')
			column(name:'line.lineItem.name', type:'VARCHAR(50)')
			column(name:'line.lineItem.code', type:'VARCHAR(50)')
			column(name:'line.lineItem.num', type:'VARCHAR(50)')
			column(name:'line.lineItem.item.id', type:'BIGINT')
		}

	}

	changeSet(id: "${clid}.14", author: 'Ken') {
		String sqltext = ""
		['RCM', 'AutoCash', 'ERP', 'PayGateway'].each {
			sqltext += "update ArTranLine set source='${it}' where lower(ltrim(rtrim(source))) = '${it.toLowerCase()}';"
		}
		sql(sqltext.toString())
		sql("update ArTranLine set source='RCM' where source is null or (source != 'Autocash' and source != 'ERP' and source != 'PayGateway')")
	}

	changeSet(id: "${clid}.15",   author: 'Ken') {
		sql ("update ArTranLine set lineItemId=id, kind='Item' where exists (select 1 from ArTranLineItem i where i.id=ArTranLine.id)")
		sql ("update ArTranLine set kind= (select t.kind from ArTranLineType t where t.id=ArTranLine.lineTypeId) where kind ='Memo' ")

	}
	changeSet(id: "${clid}.16", author: 'Joanna') {

		sql("""
	 		update ArTranLineItem set discAmount=0 where discAmount is null;
			update ArTranLine set taxpct=0 where taxpct is null;
		""")
	}

	changeSet(id: "${clid}.17", author: 'Joanna') {

		sql("""
			insert into ArReason (id, name, description) values (10, 'Bad Debt', 'Bad Debt Write Off');
			update ArTranLineType set writeOffArReasonId=10 where writeOffArReasonId is null and name <>'Comments' ;
		""")
	}




}