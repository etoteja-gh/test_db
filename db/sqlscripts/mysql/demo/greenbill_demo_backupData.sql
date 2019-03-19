CREATE PROCEDURE `greenbill_demo_BackupData`(IN fromDb CHAR(64), IN toDb CHAR(64))
BEGIN
/**
1. truncate data in backup
2. push data to backup
3. recreate original db
4. pull data from backup
**/

/** check if both databases exist */
DECLARE isDb varchar(10); 

SET @s = CONCAT('(SELECT IF(EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''',fromDb,
''') AND EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''',toDb,'''), ''Yes'',''No'') INTO @isDb );');
PREPARE stmt FROM @s;
EXECUTE stmt;

IF (@isDb ='Yes') THEN 

/** if both databases exist then backup data */

	SET @s = CONCAT('truncate table ' , toDb , '.CfgUsers;' );
	PREPARE stmt FROM @s;
	EXECUTE stmt;

	SET @s = CONCAT('insert into ',toDb,'.CfgUsers (oid, version, name, companyId, createdBy, CreatedDate, DealApprovalLimit, Description, EditedBy, EditedDate, Email, Email2,InActive, IsAdmin, IsBasic, IsGuest, IsManager, IsOwner, IsSuperUser, InVisible, LName, Login, ManagerId, MustChangePassword, Password, PromoApprovalLimit, Source, SourceID, UserType)',
	'select oid, version, name, companyId, createdBy, CreatedDate, DealApprovalLimit, Description, EditedBy, EditedDate, Email, Email2, InActive, IsAdmin, IsBasic, IsGuest, IsManager, IsOwner, IsSuperUser, InVisible, LName, Login, ManagerId, MustChangePassword, Password, PromoApprovalLimit, Source, SourceID, UserType from '
	,fromDb,'.CfgUsers;');

	PREPARE stmt FROM @s;
	EXECUTE stmt;

	SET @s = CONCAT('truncate table ' , toDb , '.Persons;' );
	PREPARE stmt FROM @s;
	EXECUTE stmt;

	SET @s = CONCAT('insert into ',toDb,'.Persons (oid, version, name, AddressId, Address1, Address2, CellPhone, City, Code, Comments, Country, CreatedBy, CreatedDate, DealApprovalLimit, DefaultOrgId, EditPrivilegeNeeded,',
	'EditedBy, EditedDate, Email, FName, Fax, FaxExt, HomePhone, InActive, isAdmin, isOwner,IsUser, LName, Login, MName,  ParentId, Password, PersonType,PromoApprovalLimit, Salutation, Source, SourceId, State, Status,  TimeZone,',
	'TagForReminders, Title, UseCompanyAddress, Workphone, WorkphoneExt, ZipCode, User1, User2, User3, User4)',
	'select oid, version, name, AddressId, Address1, Address2, CellPhone, City, Code, Comments, Country, CreatedBy, CreatedDate, DealApprovalLimit, DefaultOrgId, EditPrivilegeNeeded,',
	'EditedBy, EditedDate, Email, FName, Fax, FaxExt, HomePhone, InActive, isAdmin, isOwner, IsUser, LName, Login, MName,  ParentId, Password, PersonType, PromoApprovalLimit, Salutation, Source, SourceId, State, Status,  TimeZone,', 
	'TagForReminders, Title, UseCompanyAddress, Workphone, WorkphoneExt, ZipCode, User1, User2, User3, User4 from ',fromDb,'.Persons;');


	PREPARE stmt FROM @s;
	EXECUTE stmt;

	SET @s = CONCAT('truncate table ' , toDb , '.UserLoginHistory;' );
	PREPARE stmt FROM @s;
	EXECUTE stmt;

	SET @s = CONCAT('insert into ',toDb,'.UserLoginHistory (oid, version, userId, loginDate, logOutDate)',
	'select oid, version, userId, loginDate, logOutDate from ',fromDb, '.UserLoginHistory;');

	PREPARE stmt FROM @s;
	EXECUTE stmt;
	
END IF;
END;