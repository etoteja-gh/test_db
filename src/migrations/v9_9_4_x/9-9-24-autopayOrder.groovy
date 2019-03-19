package v9_9_x

databaseChangeLog{
	clid = '9-9-24-autopayOrder'
	changeSet(author: "Joanna", id: "${clid}.1") {

		modifyDataType(tableName:'AcMatchSetup', columnName:'value', newDataType:'varchar(500)')


		sql """insert into AcMatchSetup (id, value, variable, description)
		values (65, '', 'autopayMethodsOrder',  'reorder autopay methods (case sensitive): TotalDue,SingleArTran,BucketMatch,ATOB,SumUp');
		 """
	}


}
