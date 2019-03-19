package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-18-Lockbox'
    changeSet(author: "Alexey", id: "${clid}.1", context:'dev') {
        sql("update AppParam set value='company' where variable='segmentationOrgType'")
    }
    changeSet(id: "${clid}.2", author: "Alexey", context:'dev') {
        sql "update Lockbox set orgId=2 where orgId is not null;"
    }

    changeSet(id: "${clid}.3", author: "Joanna", context:'dev') {
        sql """
        	update ArTranMatch set custAccountId =(select custAccountId from ArTran t where t.id=ArTranMatch.id);
			update AcMatchSetup set value='true' where variable in ('autoPayMatchPerCustAccountInCustomer', 'AutoPayMatchSingleArDoc', 'AutoPayMatchTotalDue', 'AutoPaySumUp');
--			insert into Payment (id, refnum, custNum, arBatchId, amount, payDate, comments, ReasonId) values (1420, '142911', 'K14700', 1303, 5532.45, '2008-12-24', 'cust account total due', null);
			update ArBatch set controlAmount= (select sum(amount) from Payment p where p.arBatchid = ArBatch.id);
			update ArBatch set companyId = 2 where id =1303;
			update Customer set companyId =2 where id in (568, 1352,7705);
			update Customer set companyId =4 where id in (10230, 5993);
			update Org set companyId =2 where id in (568, 1352,7705);
			update Org set companyId =4 where id in (10230, 5993);
			update ArTran set companyId =2 where custId in (568, 1352,7705);
			update ArTran set companyId =4 where custId in (10230, 5993);

        """
    }
}
