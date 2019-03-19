package v9_9_x.dev

databaseChangeLog{
	clid = '9-9-10'

	changeSet(id: "${clid}.3.mysql", author: "Joanna", context:'dev', dbms:'mysql') {
		sql """
			insert into ArScoreCard (id, orgId, glpostperiod, totaldue, pastDue, aging1, aging2, aging3, aging4, aging8, aging10, curBal, beginBal, newIn, newPa, newDD, newDm, newCM)
			values(226,127, '200812', 100,100,100,100,100,100,100,100,100,100, 10, -5, 2, 0,0) ;

			insert into ArScoreCard (id, orgId, glpostperiod, totaldue, pastDue, aging1, aging2, aging3, aging4, aging8, aging10, curBal, beginBal, newIn, newPa, newDD, newDm, newCM)
			values(227,128, '200812', 200,200,200,200,200,200,200,200,200,200, 20, -10, 4, 0,0) ;


			insert into  CustStats (id, lastInTranId, lastPaTranid, lastShipTranId )  values (127, 45804018, 7318033, 45835056);
			insert into  CustStats (id, lastInTranId, lastPaTranid, lastShipTranId )  values (128, 45845523, 45838932, 45835158);
		"""
	}

	changeSet(id: "${clid}.3.mssql", author: "Joanna", context:'dev', dbms:'mssql') {
		sql """
			set identity_insert ArScoreCard on;
			insert into ArScoreCard (id, orgId, glpostperiod, totaldue, pastDue, aging1, aging2, aging3, aging4, aging8, aging10, curBal, beginBal, newIn, newPa, newDD, newDm, newCM)
			values(226,127, '200812', 100,100,100,100,100,100,100,100,100,100, 10, -5, 2, 0,0) ;

			insert into ArScoreCard (id, orgId, glpostperiod, totaldue, pastDue, aging1, aging2, aging3, aging4, aging8, aging10, curBal, beginBal, newIn, newPa, newDD, newDm, newCM)
			values(227,128, '200812', 200,200,200,200,200,200,200,200,200,200, 20, -10, 4, 0,0) ;
			set identity_insert ArScoreCard off;

			insert into  CustStats (id, lastInTranId, lastPaTranid, lastShipTranId )  values (127, 45804018, 7318033, 45835056);
			insert into  CustStats (id, lastInTranId, lastPaTranid, lastShipTranId )  values (128, 45845523, 45838932, 45835158);
		"""
	}

	changeSet(id: "${clid}.4", author: "Joanna", context:'dev') {
		sql """
			update Contact set orgId=127, email='wibanyacki@belk.com', isLocationDifferent=0 where id=4160363;
			update Contact set orgId=128, email='krparker@belk.com', isLocationDifferent=0  where id=4160370;

			insert into Location (id, orgId, contactId, street1, street2, city, state, zipCode, country)
			values (128, 128, 4160370, '567 Thorndale Rd','Unit 300', 'Wallton', 'IL', '60468', 'US' );

			update Org set LocationId=128 where id=128;
			update Org set LocationId=127 where id=127;

			update CustAccount set keyContactid=4160363, isLocationDifferent=0 where id=127;
			update CustAccount set keyContactid=4160370, isLocationDifferent=1 where id=128;
			"""
	}
	changeSet(id: "${clid}.5", author: "Joanna", context:'dev') {
		sql """
			insert into Contact (id, email, phone, firstName, name, orgId, isprimary)
			values (110, 'info@virginGalactic.comx', '888-123-4567', 'Customer Service', 'Customer Service',1,1);
			update Location set contactId=110 where id=1;
			"""
	}

    changeSet(id: "${clid}.6", author: "Joanna", context:'dev') {
        sql """
            update AcLayoutImport set ScanDirectory='bai' where name='BAI2';
            update AcLayoutImport set ScanDirectory='spreadsheet' where name='9ci Rapid Key Spreadsheet';
            """
    }





}