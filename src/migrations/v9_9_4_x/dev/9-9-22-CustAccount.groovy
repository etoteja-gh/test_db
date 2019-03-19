package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-22-CustAccount'

    changeSet(id: "${clid}.1", author: "Joanna", context:'dev') {
        [44573724:9920 , 46823704:9921, 2963634:9922,
             8648365:9923, 32725102:9933, 46823706:9934, 46823704:9924,
             4174970:9925,4174957:9926, 4174956:9927,4174952:9928,
             4174950:9929, 4174946:9930, 4174936:9931, 4174729:9932
             ].each { old1, new1 ->
                    sql """
                        update Customer set id=$new1, acSetupId=$new1, relatedId=$new1, setupId=$new1 where id=$old1;
                        update Org  set id=$new1, calcid=$new1, infoId=$new1,  orgSourceid=$new1, memberid=$new1 where id=$old1;

                        update CustAcSetup set Id=$new1 where id=$old1;
                        update CustRelated set Id=$new1 where id=$old1;
                        update CustSetup set Id=$new1 where id=$old1;
                        update OrgCalc set Id=$new1 where id=$old1;
                        update OrgInfo set Id=$new1 where id=$old1;
                        update OrgMember set Id=$new1 where id=$old1;
                        update OrgSource set Id=$new1, orgId=$new1 where id=$old1;
                        update Location set orgId=$new1 where orgId=$old1;
                        update ArTran set custId=$new1 where custId=$old1;
                        update ArTranMatch set custId=$new1 where custId=$old1;
                        update CustAccount set custId=$new1 where custId=$old1;
                        update Payment set custId=$new1 where custId=$old1;
                        update PaymentDetail set custId=$new1 where custId=$old1;
                        update Activity set orgId=$new1 where orgId=$old1;
                        update ArScoreCard set orgId=$new1 where orgId=$old1;
                        update Contact set orgId=$new1 where orgId=$old1;
                        update CustMicr set  custId=$new1 where custId=$old1;
                        update CustMicr set orgId=$new1 where orgId=$old1;
                        update OrgCalc set orgId=$new1 where orgId=$old1;
                        update OrgSource set orgId=$new1 where orgId=$old1;
                        update ArTranOrgMember set salesId=$new1 where salesId=$old1;
                        update OrgMember set salesId=$new1 where salesId=$old1;
                        """
        }
        sql """
        update Org set locationId=128 where id=127;
        update Org set orgtypeId=1, memberId=id where id in (5790, 8024, 5993);
        insert into OrgMember (id, branchId, divisionId, businessId, salesId, factoryId) values (5790, null, 40,50,null, null);
        insert into OrgMember (id, branchId, divisionId, businessId, salesId, factoryId) values (8024, null, 40,50,null, null);
        insert into OrgMember (id, branchId, divisionId, businessId, salesId, factoryId) values (5993, null, 40,50,null, null);
    """
    }
    changeSet(id: "${clid}.2", author: "Joanna", context:'dev', dbms:'mysql') {
        sql """
        	insert into CustAccount(id, num, name,custId, relatedId, typeId) select id +10000, concat(num ,'-1'), concat(name , ' Job'), id ,id +10000, 100 from Customer where not exists (select 1 from CustAccount c where c.custId=Customer.id);
        """
    }

    changeSet(id: "${clid}.3", author: "Joanna", context:'dev', dbms:'mssql') {
        sql """
            insert into CustAccount(id, num, name,custId, relatedId, typeId) select id +10000, num +'-1',  name + ' Job', id ,id +10000, 100 from Customer where not exists (select 1 from CustAccount c where c.custId=Customer.id);
        """
    }

    changeSet(id: "${clid}.4", author: "Joanna", context:'dev') {
        sql """
            insert into Org(id, num, name,orgTYpeId, memberId, companyId, orgSourceId) select ac.id , ac.num, ac.name , 2, ac.id, c.companyId, ac.id from CustAccount ac, Customer c  where ac.custid=c.id and not exists (select 1 from Org o where o.id=ac.id);
            update Org set orgSourceId =id where orgTypeId=2;

            insert into OrgSource (id, orgId, originator, sourceId, sourceType, source, orgTypeId)
            select id, id, 1, num, 'Erp', 'Friedman', 2 from Org where orgTYpeId=2 and not exists (select 1 from OrgSource s where s.id=orgSourceId);

            insert into OrgMember (id, branchId, divisionId, businessId, salesId, factoryId) select ac.id, branchId, divisionId, businessId, salesId, factoryId from CustAccount ac, OrgMember where OrgMember.id=ac.custId
            and not exists (select 1 from OrgMember o2 where o2.id=ac.id);

            insert into CustRelated (id, cashUserId, collectorId, disputeResolverId, salesPersonId)
            select ac.id, cashUserId, collectorId, disputeResolverId, salesPersonId from CustAccount ac, CustRelated where CustRelated.id = ac.custId
            and not exists (select 1 from CustRelated o2 where o2.id=ac.id);

            update CustAccount set relatedId = null where not exists (select 1 from CustRelated r where r.id=CustAccount.relatedid) ;
            update ArTran set custAccountId=(select min(c.id) from CustAccount c where c.custId=ArTran.custId) where custAccountId is null;
            update ArTranMatch set custAccountId = (select custAccountId from ArTran a where a.id=ArTranMatch.id);
            update PaymentDetail set custAccountId = (select custAccountId from ArTran a where a.id=PaymentDetail.custAccountId);

            insert into ArTranOrgMember (id, branchId, divisionid, businessId, salesId, regionId, factoryId)
            select a.id, branchId, divisionid, businessId, salesId, regionId, factoryId from ArTran a, OrgMember o where o.id=a.custAccountId and not exists (select 1 from ArTranOrgMember atom where atom.id = a.orgMemberId);
            update ArTran set orgMemberId = id where exists (select 1 from ArTranOrgMember atom where atom.id=ArTran.id);


        """
    }
    changeSet(id: "${clid}.5", author: "Joanna", context:'dev') {
        sql """
            update ArTranMatch set origAmount=(select origAmount from ArTran t where t.id=ArTranMatch.id);
            update Task set userId=306 where userId=105;

            update ArAgingBucketSetup set month=null;
            update ArAgingBucketSetup set isUsed=0;
            update ArAgingBucketSetup set isUsed=1 where id in (1,2,3,10);

            update Contact set name =(select name from Users u where u.id=Contact.id) where exists (select 1 from Users u where u.id=Contact.id);
            update Task  set  priority=20  where   priority is null;
            update Task  set taskTYpeId=2  where   exists (select 1 from Activity t where t.taskId=Task.id and t.summary like '%call%');
            update Task  set  priority=30  where id in (1107,1002);
        """
    }
    changeSet(id: "${clid}.6", author: "Joanna", context:'dev') {
        sql """
        insert into Activity (id,Kind, OrgId, Summary, Title, TaskId, VisibleTo, createdDate , createdBy) values(83,'Todo', 9923, 'Broken Promise on Ref# 9018012 Amount: 245.09', 'Broken Promise',83, 'Everyone', '2008-12-24 00:00:01.0', 1) ;
        insert into Task (id, priority,taskTypeId, userId , DueDate, createdDate, StatusId) values (83, 10, 1, 306, '2008-12-24 00:00:01.0','2008-12-24 00:00:01.0',0);
        insert into ActivityLink (activityId, linkedId, LinkedEntity)  values (83, 42717452, 'ArTran');

        insert into Activity (id,Kind, OrgId, Summary, Title, TaskId, VisibleTo, createdDate , createdBy) values(84,'Todo', 5850, 'Broken Promise on 3 invoices for 7,248.02', 'Broken Promise',84, 'Everyone','2008-12-24 00:00:01.0', 1) ;
        insert into Task (id, priority,taskTypeId, userId , DueDate, createdDate, StatusId) values (84, 10, 1, 306, '2008-12-24 00:00:01.0', '2008-12-24 00:00:01.0',0);
        insert into ActivityLink (activityId, linkedId, LinkedEntity)  values (84, 44522699, 'ArTran');
        insert into ActivityLink (activityId, linkedId, LinkedEntity)  values (84, 44575575, 'ArTran');
        insert into ActivityLink (activityId, linkedId, LinkedEntity)  values (84, 44575657, 'ArTran');

        insert into Activity (id,Kind, OrgId, Summary, Title, TaskId, VisibleTo, createdDate, createdBy ) values(-85,'Todo', 4620, 'Broken Promise', 'Broken Promise',-85, 'Everyone','2008-12-24 00:00:01.0', 1) ;
        insert into Task (id, priority,taskTypeId, userId , DueDate, createdDate, StatusId) values (-85, 10, 1, 306, '2008-12-24 00:00:01.0', '2008-12-24 00:00:01.0',0);
        insert into ActivityLink (activityId, linkedId, LinkedEntity)  values (-85, 45142633, 'ArTran');
        """
    }

    changeSet(id: "${clid}.7", author: "Joanna", context:'dev') {
        sql """
                update OrgMember set branchId=30 where branchId is null and divisionId=40 and exists (
            select 1 from CustAccount t where t.id=OrgMember.id);
            update OrgMember set branchId=31 where branchId is null and divisionId=41 and exists (
            select 1 from CustAccount t where t.id=OrgMember.id);
            update OrgMember set branchId=32 where branchId is null and divisionId=42 and exists (
            select 1 from CustAccount t where t.id=OrgMember.id);
            update OrgMember set branchId=33 where branchId is null and divisionId=43 and exists (
            select 1 from CustAccount t where t.id=OrgMember.id);


            update ArTranOrgMember set branchId = (select branchId from OrgMember m, ArTran t where t.id=ArTranOrgMember.id and t.custAccountId=m.id);
        """
    }


}
