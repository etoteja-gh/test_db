package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-34-cleanup'

    changeSet(id: "${clid}.1", author: "snimavat",  context: 'test') {
        sql """
            update ArTranOrgMember set divisionId=null where divisionId =0;
            update ArTranOrgMember set branchId=null where branchId =0;
            update ArTranOrgMember set businessId=null where businessId =0;
            update ArTranOrgMember set salesId=null where salesId =0;
            update ArTranOrgMember set regionId=null where regionId =0;
            update ArTranOrgMember set factoryId=null where factoryId =0;


            update OrgMember set divisionId=null where divisionId =0;
            update OrgMember set branchId=null where branchId =0;
            update OrgMember set businessId=null where businessId =0;
            update OrgMember set salesId=null where salesId =0;
            update OrgMember set regionId=null where regionId =0;
        """
    }

}