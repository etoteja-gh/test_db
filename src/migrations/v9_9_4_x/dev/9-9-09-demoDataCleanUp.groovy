package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-09'

    changeSet(id: "${clid}.1", author: "Joanna", context:'dev') {

        sql """

            insert into CustAccount (id, name, num, relatedId, typeId, custId) values (127, 'Belk Job #1', 'K14700-1', 127, 100, 4303);
            insert into Org (id, name, num, orgTYpeId, companyId) values (127, 'Belk Job #1', 'K14700-1', 2, 2);
            insert into CustRelated (id, branchId) values (127, 33);

            insert into CustAccount (id, name, num, relatedId, typeId, custId) values (128, 'Belk Job #2', 'K14700-2', 128, 100, 4303);
            insert into Org (id, name, num, orgTYpeId, companyId) values (128, 'Belk Job #2', 'K14700-2', 2, 2);
            insert into CustRelated (id, branchId) values (128, 33);

            update ArTran set custAccountId=127 where custId=4303 and id<45835158;
            update ArTran set custAccountId=128 where custId=4303 and id>45835157;
        """
    }

    changeSet(id: "${clid}.2", author: "Joanna", context:'dev') {

        sql """
            update PayGatewayParam set putInAutoCash=1 , typeName='AutoCash' where id=4;
            insert into BankRouting (id, routingNum) values (1, '111111111');
        """
    }

    changeSet(id: "${clid}.3", author: "Joanna", context:'dev') {

        sql """
            insert into ArAdjust (id, arBatchid, arTranId, createdDate, editedDate, glPostDate, glPostPeriod) values(104, 1,77333953,  '2010-11-09','2010-11-09','2010-11-09','201011');
            update ArTran set origAmount=-117900.9100, closedDate='2010-11-09' ,trandate='2010-11-09' ,glPostDate='2010-11-09' , editedDate='2010-11-09', closingArAdjustId=104 where id=77333953;
            insert into ArAdjustLine (id, arAdjustId, amount, arTranId ) select id*(-1), 104, origAmount, id from ArTran where state=1 and doctype<>'PA' and not exists (select 1 from ArAdjustLine l where l.arTranId=ArTran.id );
            update ArTran set closingArAdjustId=(select arAdjustId from ArAdjustLine l where l.arTranId=ArTran.id) where closingArAdjustId is null and amount=0;
            update ArTran set closedDate=(select createddate from ArAdjust l where l.id=closingArAdjustId) where closingArAdjustId is not null and amount=0;

            update ArTran set trandate='2008-12-02', createddate='2008-12-02', glPostDate='2008-12-02' where id in (7316765, 45835056);
            update ArScoreCard set newPa=-9656.89, newIn=8255.28, newDD=2013.99, totalDue=16460.28, beginBal=16068.75, curBal=8608.2, aging1=3209.88   , aging2=2203.2, aging3=1314, aging10=1125, aging4=0, aging5=0,aging6=0, pastDue=7852.08 where id=205;

            insert into ArTranStats (id, arTranid,bucketLastNight) select id, id, 'aging8' from ArTran where id in (7316765,45835056,45845523,7334006);
            insert into ArTranStats (id, arTranid,bucketLastNight) select id, id, 'aging1' from ArTran where id in (7316732,7316745,7316741,4019799,99161672);
            insert into ArTranStats (id, arTranid,bucketLastNight) select id, id, 'aging2' from ArTran where id in (45834812);
            insert into ArTranStats (id, arTranid,bucketLastNight) select id, id, 'aging3' from ArTran where id in (45834972);
            insert into ArTranStats (id, arTranid,bucketLastNight) select id, id, 'aging10' from ArTran where id in (45831365);
            update ArTran set statsid=id where exists (select 1 from ArTranStats s where s.id=ArTran.id);
            Update CustStats set lastShipTranId=45835056 where id=4303;

            update ArTranExt set shipDate= (select trandate+2 from ArTran t where doctype='IN' and  t.id=ArTranExt.id);

        """

    }
    //     changeSet(id: "${clid}.4", author: "Joanna", context:'dev') {
    //     sql """
    //         insert into CustPaymentToken (id, custId, contactid, name, paymentType, accountNum, routingNum ,   editedby, createdby, editeddate, createddate)
    //         values (1, 4303, 4162471, 'Bus. Checking', 'ACH', '1234567', '111111111', 4162471, 4162471, '2008-11-01','2008-11-01')
    //     """
    // }

    changeSet(id: "${clid}.5", author: "Joanna",  context: 'dev') {
            sql """
                update CustSetup set class1Id=1 where class1id=4171823;
                update CustSetup set class1Id=2 where class1id=4171822;

            """
        }
    changeSet(id: "${clid}.6", author: "snimavat",  context: "dev") {
        sql "update CustAccount set custId = 568 where custId = 101"
    }

}