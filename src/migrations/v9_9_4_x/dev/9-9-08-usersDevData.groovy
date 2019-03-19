package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-08'

    changeSet(id: "${clid}.1", author: "Sudhir", context:'dev') {

        sql "update Org set name='Client' where id=1"
        sql "update Customer set name='Client' where id=1"

        sql "INSERT INTO Org (id, name, num, orgtypeId) VALUES (111, 'West Region', 'West', 11)"
        sql "INSERT INTO Org (id, name, num, orgtypeId) VALUES (112, 'East Region', 'East', 11)"

        sql "INSERT INTO Org (id, name, num, orgtypeId) VALUES (101, 'Hong Kong Factory', 'HongKong', 10)"
        sql "INSERT INTO Org (id, name, num, orgtypeId) VALUES (102, 'Shanghei Factory', 'Shanghei', 10)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (301, 'Julia','Brown', 'Administrator', '301', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (301, 301, 'Julia Brown', 'Administrator', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (301, 1)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (302, 'Mary','Smith','Power User', '302', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (302, 302, 'Mary Smith', 'PowerUser', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (302, 2)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (303, 'Anne','Johnson','Manager', '303', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (303, 303, 'Anne Johnson', 'Manager', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (303, 3)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (304, 'Barbara','Williams','Guest', '304', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (304, 304, 'Barbara Williams', 'Guest', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (304, 4)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (306, 'Andrea','Miller','Collections', '306', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (306, 306, 'Andrea Miller', 'Collections', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (306, 6)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (307, 'Tammy','Davis','Collections Manager', '307', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (307, 307, 'Tammy Davis', 'CollectionsManager', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (307, 7)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (308, 'Nancy','Jackson','Autocash', '308', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (308, 308, 'Nancy Jackson', 'Autocash', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (308, 8)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (309, 'Angela','Young','Autocash Manager', '309', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (309, 309, 'Angela Young', 'AutocashManager', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (309, 9)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (310, 'Jessica','Clark','Autocash Offset', '310', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (310, 310, 'Jessica Clark', 'AutocashOffset', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (310, 10)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (311, 'Lori','Wilson','Admin Config', '311', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (311, 311, 'Lori Wilson', 'AdminConfig', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (311, 11)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (312, 'Kathy', 'Garcia','Admin Sec', '312', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (312, 312, 'Kathy Garcia', 'AdminSec', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (312, 12)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (313, 'Sarah','Anderson','Sales', '313', 1)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (313, 313, 'Sarah Anderson', 'Sales', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (313, 13)"

        //users for orgtypes  -- no sales, because they are SecRole.
        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (315, 'Mark','Russell','Company', '315', 2)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (315, 315, 'Mark Russell', 'Company', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (315, 2)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (316, 'Charles','Fisher', 'Business', '316', 50)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (316, 316, 'Charles Fisher', 'Business', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (316, 2)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (317, 'Joseph','Coleman','Division', '317', 40)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (317, 317, 'Joseph Coleman', 'Division', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (317, 2)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (318, 'Robert','Graham','Branch', '318', 30)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (318, 318, 'Robert Graham', 'Branch', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (318, 6)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (319, 'Michael','Cole','Customer', '319', 4303)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (319, 319, 'Michael Cole', 'Customer', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (319, 5)"

        sql "INSERT INTO Contact(id, name, firstName,lastName, num, orgId) VALUES (320, 'Lee','West','Region', '320', 111)"
        sql "INSERT INTO Users (id, contactId, Name, Login, Password) VALUES (320, 320, 'Lee West', 'Region', '\$2a\$10\$QZn.9nm6xZBdGzRxMQb2HuXwmAijYb945qjudid4Lmhu2X8u4V30G')"
        sql "INSERT INTO SecRoleUser(userId, secRoleId) VALUES (320, 2)"

    }

    changeSet(id: "${clid}.2.mysql", author: "Joanna",  context:'dev', dbms:'mysql') {
        sql "update Org org set flexId = null where not exists (select 1 from OrgFlex f where f.id=org.Id);"
    }

    changeSet(id: "${clid}.2.mssql", author: "Joanna",  context:'dev', dbms:'mssql') {
        sql "update O set O.flexId = null from Org O where not exists (select 1 from OrgFlex f where f.id=O.id);"
    }

    changeSet(id: "${clid}.2.common", author: "Joanna",  context:'dev') {
        sql """
            update Org set id=50 , calcid=50, flexId=null, rootOrgId=2 where id=5290;
            update Org set id=51, calcid=51, flexId=null, rootOrgId=4  where id=6212;
            update Org set id=50 where id=5290;
            update Org set id=51 where id=6212;
            update OrgFlex set id=50 where id=5290;
            update OrgFlex set id=51 where id=6212;
            update OrgCalc set id=50 where id=5290;
            update OrgCalc set id=51 where id=6212;
            update OrgInfo set id=50 where id=5290;
            update OrgInfo set id=51 where id=6212;
            update ArScoreCard set orgId=50 where orgId=5290;
            update ArScoreCard set orgId=51 where orgId=6212;
            update Location set orgId=50 where orgId=5290;
            update Location set orgId=51 where orgId=6212;
            update Contact set orgId=50 where orgId=5290;
            update Contact set orgId=51 where orgId=6212;
            update CustRelated set businessid=50 where businessId=5290;
            update CustRelated set businessid=51 where businessId=6212;
            update ArTranRelated set businessid=50 where businessId=5290;
            update ArTranRelated set businessid=51 where businessId=6212;
            update ArTranApi set businessid=50 where businessId=5290;
            update ArTranApi set businessid=51 where businessId=6212;
            update ArTranOutApi set businessid=50 where businessId=5290;
            update ArTranOutApi set businessid=51 where businessId=6212;
            update PaymentDetail set businessid=50 where businessId=5290;
            update PaymentDetail set businessid=51 where businessId=6212;
            update PaymentDetail set businessid=null where businessId=0;
        """
    }

    changeSet(id: "${clid}.3", author: "Joanna",  context:'dev') {
        sql """
        insert into CustStats (id, lastInTranId, lastPaTranId, lastShipTranId) values (4303, 45845523,99316898, 45804018);
        update Customer set statsId=id where id=4303;
            """
    }

    changeSet(id: "${clid}.4", author: 'sudhir', context:"dev") {
        sql "update SecRoleUser set secRoleId=14 where userId=318"
    }


}