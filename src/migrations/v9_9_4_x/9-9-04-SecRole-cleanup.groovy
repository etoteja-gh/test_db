package v9_9_x

databaseChangeLog{
    clid = '9-9-04'

    // See dev/9-9-04-SecRoleCleanupDev for stuff that was split off.

    changeSet(id: "${clid}.1", author: "Joanna") {
        addColumn(tableName:'SecRole') {
        column(name:'inactive', type:'CHAR(1)') }
    }

    changeSet(id: "${clid}.2", author: "Joanna") {
        sql "delete from SecRole  where Name = 'Client'" //move Client to dev

        // dev data has Manager and Sales - don't delete just in case we want to review later.
        sql "update SecRole set name='SalesOld' where name='Sales' "
        sql "update SecRole set name='MangerOld' where name='Manager' "

        sql "update SecRole set Description = 'Full Access to all screens.' where Name = 'Administrator'"
        sql "update SecRole set id=9, Name = 'Autocash Manager', Description = 'Cash, can delete system data',inactive=1 where Name = 'AutoCash Manager'"
        sql "update SecRole set id=6, Name = 'Collections', Description = 'Non cash, collection screens access', inactive=1 where Name = 'Basic'"
        sql "update SecRole set description = 'Read Only' , id=4 where Name = 'Guest'"
        sql "update SecRole set id=10, Name = 'Autocash Offset', Description = 'Cash, can only do \$0 payments',inactive=1 where Name = 'ZeroDollarBatch'"
        sql "update SecRole set id=8, Name = 'Autocash', Description = 'Cash, cannot delete system data',inactive=1 where Name = 'AutoCash Basic'"

        sql "update SecRole set id=13, Name = 'Sales', Description = 'Review, approve disputes', inactive=1 where Name = 'Dispute'"
        sql "insert into SecRole (id, name, description) values (2, 'Power User', 'Default user, access to all screens,  not manager (cannot approve, view other users tasks or delete cash system data)')"
        sql "insert into SecRole (id, name, description) values (3, 'Manager', 'Access to all users tasks, approval, can delete cash system data')"
        sql "insert into SecRole (id, name, description, inactive) values (7, 'Collections Manager', 'Can see other collector tasks, approvals', 1)"
        sql "insert into SecRole (id, name, description, inactive) values (11, 'Admin Config', 'Admin setup screen', 1)"
        sql "insert into SecRole (id, name, description, inactive) values (12, 'Admin Sec', 'User sec manager', 1)"

        sql "update SecRoleUser set SecRoleId=500 where secRoleId=4"
        sql "update SecRoleUser set SecRoleId=4 where secRoleId=3"
        sql "update SecRoleUser set SecRoleId=10 where secRoleId=8"
        sql "update SecRoleUser set SecRoleId=8 where secRoleId=7"
        sql "update SecRoleUser set SecRoleId=9 where secRoleId=6"
        sql "update SecRoleUser set SecRoleId=13 where secRoleId=1003"

    }
}