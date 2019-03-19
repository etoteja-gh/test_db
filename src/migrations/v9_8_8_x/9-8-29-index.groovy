package v9_8_8_x

databaseChangeLog{
    clid = '9-8-29-index'

     changeSet(id: "${clid}.1", author: "Phil") {

        createIndex(indexName: 'ix_PaymentDetail_PaymentId_custNum', tableName: 'PaymentDetail') {
            column(name:'PaymentId')
            column(name: 'custNum')
        }

        createIndex(indexName: 'IX_PaymentDetailFlexId', tableName: 'PaymentDetail') {
            column(name:'flexId')
        }


        createIndex(indexName: 'ix_Payment_IsReconciled', tableName: 'Payment') {
            column(name:'IsReconciled')
        }


        createIndex(indexName: 'ix_arTranType_companyId', tableName: 'ArTranType') {
            column(name:'CompanyId')
        }

	    createIndex(indexName: 'ix_ArTranSource_sourceType', tableName: 'ArTranSource') {
            column(name:'sourceType')
	    }

	    createIndex(indexName: '_dta_index_ArTranOutApi_origArTranId_arTranId', tableName: 'ArTranOutApi') {
            column(name:'origArTranId')
            column(name:'arTranId')
	    }
	    createIndex(indexName: 'ix_ArTranOutApi_glBatchId', tableName: 'ArTranOutApi') {
            column(name:'glBatchId')
	    }

	    createIndex(indexName: 'ix_ArTranApi_arTranId', tableName: 'ArTranApi') {
            column(name:'arTranId')
	    }
	    createIndex(indexName: 'ix_ArTran_combo', tableName: 'ArTran') {
            column(name:'glBatchId')
            column(name:'statusId')
            column(name:'docType')
            column(name:'arTranSourceId')
            column(name:'editedDate')
	    }

	    createIndex(indexName: 'ix_ArTran_autoCashId', tableName: 'ArTran') {
            column(name:'autoCashId')
	    }
	    createIndex(indexName: 'ix_ArTran_closingArAdjustId', tableName: 'ArTran') {
            column(name:'closingArAdjustId')
	    }


	    createIndex(indexName: 'ix_ArTran_dueDate_state_DocType', tableName: 'ArTran') {
            column(name:'dueDate')
            column(name:'state')
            column(name:'docType')
	    }

	    createIndex(indexName: 'ix_CustMicr_RoutingNum', tableName: 'CustMicr') {
            column(name:'RoutingNum')
	    }
	    createIndex(indexName: 'ix_ArTranAutoCash_linkedDomain', tableName: 'ArTranAutoCash') {
            column(name:'linkedDomain')
	    }
	    createIndex(indexName: 'IX_ArTranOutApi_glBatchId_docTYpe_operationId_createdArBatchid', tableName: 'ArTranOutApi') {
            column(name:'glBatchId')
            column(name:'docType')
            column(name:'operationId')
            column(name:'createdArBatchId')
	    }
	    createIndex(indexName: 'ix_arPayPlan_arTranId', tableName: 'ArPayPlan') {
            column(name:'arTranId')
	    }


	    createIndex(indexName: 'ix_Payment_arTranId', tableName: 'Payment') {
            column(name:'arTranId')
	    }
    }
}



