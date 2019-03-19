package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-99-demoData'
/*
    changeSet(id: "${clid}.1", author: "Joanna ", context:'dev') {
        // PUMA DEMO
        sql """

update AppParam set value='false' where variable='custAccountActive';

update Customer set name='Macys' where id=4303;
update Customer set name='Foot Locker' where id=5835;
update Customer set name='Bloomingdale' where id=7705;
update Customer set name='Finish Line' where id=8029;
update Customer set custFamilyType='Parent' where id=4303;
update Customer set name='Lord & Taylor' where id=568;
update Customer set name='Champs Sports' where id=5850;
update Customer set name='Zappos.com' where id=4620;
update Customer set name='Pair of Shoes' where id=9982;

insert into CustFamily(childId, parentId) values (7705, 4303);

"""
}
*/
    changeSet(id: "${clid}.2", author: "Joanna", context:'dev') {
        sql """
update AppParam set value='false' where variable='custAccountActive';


INSERT INTO CustReasonMap (id, CreatedBy, CreatedDate, CustReasonCode, EditedBy, EditedDate, custId, ReasonId, version)
VALUES
    (1000,NULL,NULL,'56',NULL,NULL,4303,2,0),
    (1001,NULL,NULL,'78',NULL,NULL,4303,4,0),
    (1002,NULL,NULL,'P12',NULL,NULL,4303,5,0),
    (1003,NULL,NULL,'87',NULL,NULL,4303,7,0),
    (1004,NULL,NULL,'R90',NULL,NULL,4303,8,0),
    (1005,NULL,NULL,'33',NULL,NULL,4303,22,0);

update SecRole set inactive=0 where id=7;
delete from SecRoleUser where userId=107 and secRoleid=6;
insert into SecRoleUser(secroleid, userId) values(7,107);
update Task set UserId=107 where UserId<>302;

delete from ArTranSource where not exists (select 1 from ArTran where id=ArTranSource.arTranId);
delete from ArTranExt where not exists (select 1 from ArTran where id=ArTranExt.id);
delete from ArTranFlex where not exists (select 1 from ArTran where id=ArTranFlex.Id);
delete from ArTranLine where not exists (select 1 from ArTran where id=ArTranLine.arTranId);

update OrgType set inactive=1;
update OrgType set inactive=0 where id in (1,6,8,10);


update Org set name =(select name from Customer where Org.id=Customer.id) where orgTYpeId=1;


update Activity set kind='Todo', summary='Review pending write offs', title='write off review' where id=1012;
update Task set userId=307 ,priority=20, TaskTypeId=1 where id=1217;
update Notes set note='Review pending write offs.' where id=1012;

    update Activity set Title='Check promo terms',
        summary='Check promo terms', createddate='2008-12-24 11:00:00' where id=2;
        update Task set tasktypeid=1, priority=10,createddate='2008-12-24 11:00:00', duedate='2008-12-24 00:00:00'  where id=1000;
        update Task set priority=30 where id in (-85,83,84);
               update ArTranFlex set text6='Call' where id in (45835056, 7316732, 7316394);
                update ArTranFlex set text5='Resend request for supported documentation.' where id =7316732;
                    update ArTranFlex set text7='Critical', num6=30 where id in (7316258,7316394, 7316732);

  INSERT INTO Activity (id, NoteId, Kind, OrgId, ParentId, Summary, Title, TaskId, TemplateId, VisibleTo, VisibleId, Source, SourceEntity, SourceId, CreatedBy, CreatedDate,EditedBy, EditedDate, ForCustomer, ForCompany, ForProspect, ForOrg, version)
        VALUES
        (1022, NULL, 'Call', 4303, NULL, 'Joe should be back from vacation.', 'Joe should be back from vacation.', 1022, NULL, 'Everyone', NULL, NULL, NULL, NULL, 1, '2008-12-24 11:31:39', 1, '2008-12-24 11:31:39', NULL, NULL, NULL, NULL, 0);
        INSERT INTO Task (id, CompletedBy, CompletedDate, DocTag, DueDate, Priority, State, StatusId, TaskTypeId, UserId, CreatedBy, CreatedDate, EditedBy, EditedDate, version)
        VALUES
        (1022, NULL, NULL, NULL, '2008-12-24 00:00:00', 10, 0, 0, 2, 107, 1, '2008-12-24 01:31:39', 1, '2008-12-24 01:31:39', 0);

        INSERT INTO ActivityLink (ActivityId, LinkedId, LinkedEntity)
            VALUES (1022, 7316732, 'ArTran');


        INSERT INTO Activity (id, NoteId, Kind, OrgId, ParentId, Summary, Title, TaskId, TemplateId, VisibleTo, VisibleId, Source, SourceEntity, SourceId, CreatedBy, CreatedDate, EditedBy, EditedDate, ForCustomer, ForCompany, ForProspect, ForOrg, version)
        VALUES
        (1020, NULL, 'Todo', 4303, NULL, 'Validate return', 'Validate return', 1020, NULL, 'Everyone', NULL, NULL, NULL, NULL, 1, '2008-12-24 11:31:39', 1, '2008-12-24 11:31:39', NULL, NULL, NULL, NULL, 0);
        INSERT INTO Task (id, CompletedBy, CompletedDate, DocTag, DueDate, Priority, State, StatusId, TaskTypeId, UserId, CreatedBy, CreatedDate, EditedBy, EditedDate, version)
        VALUES
        (1020, NULL, NULL, NULL, '2008-12-24 00:00:00', 20, 0, 0, 2, 107, 1, '2008-12-24 01:31:39', 1, '2008-12-24 01:31:39', 0);
        insert into ActivityLink (ActivityId, LinkedId, LinkedEntity) values (1020, 7316765, 'ArTran');



        INSERT INTO Activity (id, NoteId, Kind, OrgId, ParentId, Summary, Title, TaskId, TemplateId, VisibleTo, VisibleId, Source, SourceEntity, SourceId, CreatedBy, CreatedDate, EditedBy, EditedDate, ForCustomer, ForCompany, ForProspect, ForOrg, version)
        VALUES
        (1021, NULL, 'Call', 4303, NULL, 'Check promo terms', 'Check promo terms', 1021, NULL, 'Everyone', NULL, NULL, NULL, NULL, 1, '2008-12-24 11:31:39', 1, '2008-12-24 11:31:39', NULL, NULL, NULL, NULL, 0);
        INSERT INTO Task (id, CompletedBy, CompletedDate, DocTag, DueDate, Priority, State, StatusId, TaskTypeId, UserId, CreatedBy, CreatedDate, EditedBy, EditedDate, version)
        VALUES
        (1021, NULL, NULL, NULL, '2008-12-24 00:00:00', 20, 0, 0, 2, 107, 1, '2008-12-24 01:31:39', 1, '2008-12-24 01:31:39', 0);
        insert into ActivityLink (ActivityId, LinkedId, LinkedEntity) values (1021, 45835056, 'ArTran');

        insert into ActivityLink (ActivityId, LinkedId, LinkedEntity) values (1000, 7316732, 'ArTran');

        update ArTranDispute set reasonid=5  where id=45835056;
        update ArTran set statusId=11 where id = 45835056;
        update ArTranDispute set reasonid=38  where id=7316765;
        update ArTran set statusId=11 where id = 7316765;

                    update ArTranFlex set text6='Todo' where id in (7316745,7316765);
            update ArTranFlex set text6='Call' where id in (45835056, 7316732, 7316394);
             update ArTranFlex set text7='Critical', num6=10 where id in (7316745,45835056, 7316394 );
             update ArTranFlex set text7='High', num6=20 where id in (7316765, 7316732);
             update ArTranFlex set text5='Check promo terms.' where id =7316745;
             update ArTranFlex set text5='Validate return' where id =7316765;
             update ArTranFlex set text5='Check promo terms' where id =45835056;
              update ArTranFlex set text5='Follow up after appeal.' where id =7316394;
             update ArTranFlex set text5='Joe should be back form vacation.' where id =7316732;
             update ArTranFlex set date3='2018-01-31 00:00:00' where id in (7316745,45835056,7316732 );
             update ArTranFlex set date3='2017-01-31 00:00:00' where id in (7316765);
             update ArTranFlex set date3='2017-01-30 00:00:00' where id in (7316394);

        update Payment set imageFileName='check 5689745.png' where id=1407;
        update ArTran set doctype='DD', trantypeId=50 where id=45835056
 """
    }
    changeSet(id: "${clid}.3", author: "Joanna", context:'dev') {
        sql """

insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87327394','Benton, John B Jr','6649 N Blue Gum St','New Orleans','LA','70116','Orleans','http://www.bentonjohnbjr.com','506 S Hacienda Dr','Atlantic City','Atlantic','609-228-5265','609-854-7156');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87327395','Chanay, Jeffrey A Esq','4 B Blue Ridge Blvd','Brighton','MI','48116','Livingston','http://www.chanayjeffreyaesq.com','3732 Sherman Ave','Bridgewater','Somerset','908-722-7128','908-670-4712');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87329000','Chemel, James L Cpa','8 W Cerritos Ave #54','Bridgeport','NJ','8014','Gloucester','http://www.chemeljameslcpa.com','25657 Live Oak St','Brooklyn','Kings','718-560-9537','718-280-4183');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87329151','Feltz Printing Service','639 Main St','Anchorage','AK','99501','Anchorage','http://www.feltzprintingservice.com','4923 Carey Ave','Saint Louis','Saint Louis City','314-787-1588','314-858-4832');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87329435','Printing Dimensions','34 Center St','Hamilton','OH','45011','Butler','http://www.printingdimensions.com','3196 S Rider Trl','Stockton','San Joaquin','209-317-1801','209-242-7022');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87333119','Chapman, Ross E Esq','3 Mcauley Dr','Ashland','OH','44805','Ashland','http://www.chapmanrosseesq.com','3 Railway Ave #75','Little Falls','Passaic','973-936-5095','973-822-8827');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87333707','Morlong Associates','7 Eads St','Chicago','IL','60632','Cook','http://www.morlongassociates.com','87393 E Highland Rd','Indianapolis','Marion','317-578-2453','317-441-5848');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87333774','Commercial Press','7 W Jackson Blvd','San Jose','CA','95111','Santa Clara','http://www.commercialpress.com','67 E Chestnut Hill Rd','Seattle','King','206-540-6076','206-295-5631');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87334023','Truhlar And Truhlar Attys','5 Boston Ave #88','Sioux Falls','SD','57105','Minnehaha','http://www.truhlarandtruhlarattys.com','33 Lewis Rd #46','Burlington','Alamance','336-822-7652','336-467-3095');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('87334135','King, Christopher A Esq','228 Runamuck Pl #2808','Baltimore','MD','21224','Baltimore City','http://www.kingchristopheraesq.com','8100 Jacksonville Rd #7','Hays','Ellis','785-629-8542','785-616-1685');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('99161672','Dorl, James J Esq','2371 Jerrold Ave','Kulpsville','PA','19443','Montgomery','http://www.dorljamesjesq.com','7 W Wabansia Ave #227','Orlando','Orange','407-471-6908','407-429-2145');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('99316796','Rangoni Of Florence','37275 St  Rt 17m M','Middle Island','NY','11953','Suffolk','http://www.rangoniofflorence.com','25 Minters Chapel Rd #9','Minneapolis','Hennepin','612-508-2655','612-664-6304');
insert into ArTranBillShip (id, billName, billStreet1, billCity, billState, billZipCode, billCounty, shipName, ShipStreet1, ShipCity, shipCountry, shipPhone, billIns1) values ('99316898','Feiner Bros','25 E 75th St #69','Los Angeles','CA','90034','Los Angeles','http://www.feinerbros.com','6882 Torresdale Ave','Columbia','Richland','803-352-5387','803-975-3405');

update ArTranAutoCash set imageFileName='check 5689745.png' where id=4145836;
update ArTranAutoCash set createdByPayNum='606191872', createdByPayId=4145836 where id=45835056;
update ArAdjustLine set amount=1560.64+6849.5200 where arTranId=7318166;
insert into ArAdjustLine (id, aradjustId, amount, arTranId) select -97334417, 97334418, -1560.64, 45835056;


update ArTran set billShipId =id where exists (select 1 from ArTranBillShip p where p.id=ArTran.id);
update ArTranBillShip set
    shipname =(select comments from ArTran p  where p.id=ArTranBillShip.id);


update Activity set Kind='Todo' where id in (1021,1022);
update ArTran set origAmount=8410.16 where id=7318166  ;

update AcCorCode set id=168 , description='Different customer' where id=108;

            update Customer set commentsCollector =
            '1.Check website   <a  target="_blank" href="https://demo.logmeIn.com">demo.logmeIn.com</a>
login: testme
pw: 123@sed

2.Contact bill review (Alpha only)  800-55-1212 X123 Select 1-2

3. They will only pay invoices on the 5th and 20th' where id=4303;

    """
    }

    changeSet(id: "${clid}.4", author: "Nikita",  context:'dev') {
        sql "update ArTran set statsId = 42717452  where id = 42717452"
        sql "update ArTran set statsId = 44522699  where id = 44522699"
        sql "update ArTran set statsId = 45142633  where id = 45142633"
        sql "update ArTran set statsId = 44575575  where id = 44575575"
        sql "update ArTran set statsId = 44575657  where id = 44575657"
        sql "update ArTran set statsId = 45142633  where id = 45142633"
    }

    changeSet(id: "${clid}.5", author: "Alexey", context:'dev') {
        sql """update FileData set data = "<div>\${companyLogo}</div><div>\${company.info.phone}</div><div><br></div><div>\${customer.name}</div><div>\${customer.keyContact.phone}</div><div>\${customer.keyContact.email}</div><div><br></div><div><br></div><div>To Whom It May Concern:</div><div><br></div><div>We have received insufficient or no payment for one or more changes billed on the attached.</div><div><br></div><div>It is our understanding that these charges are billed so that they detail the service and amounts as they were authorized or negotiated. We request that you reconsider these charges for payment of the balance due.</div><div><br></div><div>We appreciate your business. If payment has already been sent please disregard this reminder.</div><div><br></div><div>Sincerely,</div><div><br></div>"  where id = 11"""
        sql """update Attachment set contentLength = 1084  where id = 17"""
        sql("""update Attachment set contentLength=11364 where id=3;""")

    }

    changeSet(id: "${clid}.6", author: "Joanna", context:'dev') {
        sql """
            update ArBatch set companyId=2;
            update Lockbox set orgId=2;
            update ArBatch set isPosted=0, ArPostedDate=(select max(arPostedDate) from Payment
            where arBatchid=ArBatch.id) where id=1200;

        """

    }

    changeSet(id: "${clid}.7", author: "Joanna", context:'dev') {
        sql """

        insert into Attachment (id, Name, Description, Location,Extension,  contentLength)
        values( 111, 'demoMerge.xls', 'Attachment from email bob123@bob123.com',
        'demoMerge.xls' , 'xls', 27648);
        
        insert into Activity (id, NoteId, Kind, Summary, Title, VisibleTo)
        values (111, 111, 'Note', 'Attachment from email bob123@bob123.com', 'Attachment from email bob123@bob123.com','Everyone');
        
        """

    }

// cash apply demo
    changeSet(id: "${clid}.8", author: "Joanna", context:'dev' ,dbms:'mysql'){
        sql """
        update Payment set imageFileName='check 5689745.png' where arbatchId=1303 and imageFileName is null;

        update Payment set applyComments='Customer match on micr \nAutopay match on single arTran' where id=1304;

        update Payment set applyComments='Customer lookup via OCR \nAutopay match on total due with disc' where id=1405;

        update Payment set applyComments='Customer match on micr \nAutopay match on sliding window' where id=1407;

        update Payment set applyComments='Customer assigned from phone number \nAuto pay found on bucket match. \nAccept or deny' , errorDesc='Verify customer lookup' where id=1423;

        update Payment set applyComments='Customer not found through OCR' where id=1410;

        update Payment set applyComments='Customer match on micr \nOCR low confidence \nAutoPay found more than one hit \nAccept or deny' where id=1623;

        update Payment set applyComments='Customer match on micr \nMerged from remittance payment' where id=1622;

        update Payment set applyComments='Customer match on micr \nRemittance imported from check' where id=1424;

        update Payment set applyComments='Customer match on micr \nRemittance imported from check face' where id=1521;

        update Payment set applyComments='RATF', applyCode='RATF' where id=1303;

        update Payment set applyComments='Customer match on micr \nMatch on invoice but customer out of family \nAccept or deny'
        where id=1419;

        update Payment set applyComments='Customer match on micr \nMissing payment detail'
        where id=1421;

        update Payment set applyComments='Remittance batch extracted from email \nPayment not found, waiting for payment' where id=1621;

        update Payment set applyComments='' where applyComments is null;

        update Payment set isreconciled=0 where id=1303;

        update ArBatch set batchType='Edi820' where id=1404;


        update ArTranMatch set trandate = DATE_ADD(trandate, INTERVAL 28 DAY) where refnum in ('597447','597543');
        
        insert into ArTranPending(id, arTranId, amount) select  arTranId, arTranId, max(amount) from PaymentDetail where  arTranid is not null and 
        arTranId not in  (select id from ArTranPending p2  ) group by arTranid;

        insert into PaymentMultiHit (id,version, paymentId, corCodeId, isGross, createdBy, createdDate, editedBy, editedDate )
        values (1002, 0, 1623, 183, 1, 107, '2018-12-10 00:22:44.000000',107, '2018-12-10 00:22:44.000000');
        
        insert into PaymentMultiHit (id,version, paymentId, corCodeId, isGross, createdBy, createdDate, editedBy, editedDate )
        values (1003, 0, 1623, 183, 1, 107, '2018-12-10 00:22:44.000000',107, '2018-12-10 00:22:44.000000');

        insert into PaymentMultiHitArTrans (id, paymentmultiHitId, arTranid, version) values (1000,1002, 67333469,0);
        insert into PaymentMultiHitArTrans (id, paymentmultiHitId, arTranid, version) values (1001,1003, 77317586,0);

        update Payment set attachmentIds='[904175409]' where id=1621;
        update Payment set attachmentIds='[904175410]' where id=1622;

    """
    }

}