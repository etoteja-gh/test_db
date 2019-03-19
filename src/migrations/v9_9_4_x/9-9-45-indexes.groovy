package v9_9_x

databaseChangeLog {
	clid = "9-9-45-indexes"

	changeSet(id: "${clid}.1", author: "joanna") {
		 createIndex(tableName:"ArTran", indexName:"IX_ArTran_custAccountId_state_refnum_trandate"){
	   		column(name:"custAccountId")
	   		column(name:"state")
	   		column(name:"refnum")
	   		column(name:"tranDate")
		}
		createIndex(tableName:"ArTranJournal", indexName:"IX_ArTranJournal_arTranid"){
	   		column(name:"arTranId")	   		
		}
		createIndex(tableName:"ArTranJournal", indexName:"IX_ArTranJournal_arTranid_glAcct"){
	   		column(name:"arTranId")
	   		column(name:"GlAcct")
		}
		createIndex(tableName:"ArTran", indexName:"IX_ArTran_origArTranId"){
	   		column(name:"origArTranId")
	   		
	   		
		}
		createIndex(tableName:"ArAdjustJournal", indexName:"IX_ArAdjustJournal_arAdjustId"){
	   		column(name:"arAdjustId")

		}
		createIndex(tableName:"ArTran", indexName:"IIX_ArTran_custId_state_duedate"){
	   		column(name:"custId")
	   		column(name:"state")
	   		column(name:"dueDate")
	   		
		}
		createIndex(tableName:"ArTranOrgMember", indexName:"IX_ArTranOrgMember_divisionId_branchId"){
	   		column(name:"divisionId")
	   		column(name:"branchId")
	   		
		}
		createIndex(tableName:"ArTran", indexName:"ix_ArTran_glPostPeriod"){
	   		column(name:"glPostPeriod")
	   		
		}
		createIndex(tableName:"ArTranJournal", indexName:"IX_ArTranJournal_glPostBatchId_glAcct_arTranid"){
	   		column(name:"glPostBatchId")
	   		column(name:"GlAcct")
	   		column(name:"arTranId")
	   		
		}
		createIndex(tableName:"ArTranJournal", indexName:"IX_ArTranJournal_glAcct"){
	   		column(name:"GlAcct")
		}
		createIndex(tableName:"ArAdjust", indexName:"IX_ArAdjust_source_arBatchId_artranId"){
	   		column(name:"source")
	   		column(name:"arBatchId")
	   		column(name:"arTranId")
	   		
		}
		
	}


	changeSet(id: "${clid}.2", author: 'snimavat') {
		sql("insert into AcSetup(id, Variable, CreatedBy, EditedBy, Value) values (66, 'searchInAllTabAccrossCustomersForRefNum', 0, 0, 'true')")
	}

	changeSet(id: "${clid}.3", author: 'alexey') {
		sql("insert into AcSetup(id, Variable, CreatedBy, EditedBy, Value) values (67, 'searchInAllTabNoCustomerFilter', 0, 0, 'true')")
	}
}

  
