package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-17'

    changeSet(id: "${clid}.1", author: "Joanna", context:'dev') {
        sql """
        truncate table OrgMember;
        insert into OrgMember(id) select id from Org where orgTYpeId not in (6,9,7,11,10);
        update Org set memberId=id where orgTYpeId not in (6,9,7,11,10);

        -- first do company
        delete from Org where id =46823702;
        update Org set name ='Canadian Company', num='Canada' where id=4;
        update Org set id=3,companyId=null, infoId=null ,name ='Bad Debt Company', num='BD' where id=46823698;
        update Org set  name ='US Company', num='US', companyId=null where id=2;

        delete from Company where id =46823702;
        update Company set name ='Canadian Company', num='Canada' where id=4;
        update Company set id=3, name ='Bad Debt Company', num='BD' where id=46823698;
        update Company set  name ='US Company', num='US' where id=2;
        update Org set companyId=4 where id in (126,1352);
        update Org set companyId=4 where companyid not in (2,4);
        update Customer set companyId = (select companyId from Org where Org.id=Customer.id);
        update ArTran set companyId = (select companyId from Customer where Customer.id=ArTran.custId);

        -- Business
        update Org set name='Entertainment Goods', num='EntBus50' where id=50;
        update Org set name='Household Goods', num='HouseBus51' where id=51;

        -- division
        update Org set name='Great Lakes', num='Div40' where id=40;
        update Org set name='Pacific', num='Div41' where id=41;

        update OrgMember set businessId=50 where id=40;
        update OrgMember set businessId=51 where id=41;

        -- sales
        update OrgMember set regionId=111 where id in (2700, 594,557,522,509,4724,2701, 2787, 4727);
        update OrgMember set regionId=112 where regionId is null and id in (select id from Org where orgTYpeId=8);

        -- branches
        update Org set name='Chicago Area', num='Ch30' where id=30;
        update Org set name='Wisconsin', num='Wi31' where id=31;
        update Org set name='Indiana', num='In32' where id=32;
        update Org set name='California', num='Ca33' where id=33;

        update OrgMember set businessId=50, divisionId=40 where id in (30,31,32);
        update OrgMember set businessId=51, divisionId=41 where id in (33);
        update OrgMember set salesId=2700 where id in (30,31);
        update OrgMember set salesId=2701 where id =32;
        update OrgMember set salesId=2787 where id =33;

        update OrgMember set regionId=111, divisionId=40 where id in (30,31,32);
        update OrgMember set  regionId=112, divisionId=41 where id in (33);


        -- customer
        update OrgMember set branchid=33, regionId=112, divisionId=41, businessId=51 where id in (7705,3684,2543,1663,568, 1352);
        update OrgMember set branchid=32, regionId=111, divisionId=40, businessId=50 where id in (345020,10230, 568);
        update OrgMember set branchid=31, regionId=111, divisionId=40, businessId=50 where id in (9982,9829 );
        update OrgMember set branchid=30, regionId=111, divisionId=40, businessId=50 where branchId is null and exists (select 1 from Org o where o.id=OrgMember.id and OrgTypeId=1);
        update OrgMember set branchid =null where exists (select 1 from Org o where o.id=OrgMember.id and OrgTypeId=1);


        -- custAccounts
        update OrgMember set branchId=30, regionId=111, divisionId=40, businessId=50 where id in (127,128);
        update OrgMember set branchid=32, regionId=111, divisionId=40, businessId=50 where id in (125, 124);
        update OrgMember set branchid=33, regionId=112, divisionId=41, businessId=51 where id in (126);

        -- arTran
        truncate table ArTranOrgMember;
        insert into ArTranOrgMember (id) select id from ArTran;
        update ArTran set orgMemberid=id;

        """
    }

    changeSet(id: "${clid}.2", author: "Joanna", context:'dev', dbms:'mysql') {
        sql """
        update OrgMember mb, OrgMember m set m.salesId=mb.salesId   where  m.branchId=mb.id ;

        update ArTran a, ArTranOrgMember t,  OrgMember m set t.branchId=m.branchId, t.divisionId=m.divisionId,
            t.businessId=m.businessId, t.regionId=m.regionId, t.salesId=m.salesId
            where  m.id=a.custAccountId and t.id=a.id ;
        update ArTran a, ArTranOrgMember t, OrgMember m set t.branchId=m.branchId, t.divisionId=m.divisionId,
            t.businessId=m.businessId, t.regionId=m.regionId, t.salesId=m.salesId
            where  m.id=a.custId and custAccountId is null and t.id=a.id ;
        update ArTran a, ArTranOrgMember t set factoryId=101 where t.id<46666935 and origAmount>0  and t.id=a.id ;
        update ArTran a, ArTranOrgMember t  set factoryId=102 where t.id>46673348 and origAmount>0  and t.id=a.id ;
        """

    }


    changeSet(id: "${clid}.3", author: "Joanna", context:'dev', dbms:'mssql') {
        sql """
        -- mssql
        update m  set salesId=mb.salesId  from OrgMember mb, OrgMember m where  m.branchId=mb.id;
        update t set branchId=m.branchId, divisionId=m.divisionId, businessId=m.businessId, regionId=m.regionId, salesId=m.salesId  from  ArTran a, ArTranOrgMember t, OrgMember m where  m.id=a.custAccountId and t.id=a.id ;
        update t set branchId=m.branchId, divisionId=m.divisionId, businessId=m.businessId, regionId=m.regionId, salesId=m.salesId from  ArTran a, ArTranOrgMember t, OrgMember m  where  m.id=a.custId and custAccountId is null and t.id=a.id ;
        update t set factoryId=101 from  ArTran a, ArTranOrgMember t where t.id<46666935 and origAmount>0  and t.id=a.id ;
        update t set factoryId=102 from  ArTran a, ArTranOrgMember t  where t.id>46673348 and origAmount>0  and t.id=a.id ;

        """
    }


    changeSet(id: "${clid}.4", author: "snimavat") {
        sql """
            update OrgMember set branchId = NULL where not exists(select 1 from Org o where o.id = OrgMember.branchId) and branchId is not NULL ;
            update OrgMember set divisionId = NULL where not exists(select 1 from Org o where o.id = OrgMember.divisionId) and divisionId is not NULL ;
            update OrgMember set businessId = NULL where not exists(select 1 from Org o where o.id = OrgMember.businessId) and businessId is not NULL ;
            update OrgMember set salesId = NULL where not exists(select 1 from Org o where o.id = OrgMember.salesId) and salesId is not NULL ;
            update OrgMember set regionId = NULL where not exists(select 1 from Org o where o.id = OrgMember.regionId) and regionId is not NULL ;
            update OrgMember set factoryId = NULL where not exists(select 1 from Org o where o.id = OrgMember.factoryId) and factoryId is not NULL ;
        """
    }

}