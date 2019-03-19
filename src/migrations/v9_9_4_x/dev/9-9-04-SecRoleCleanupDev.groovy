package v9_9_x.dev

databaseChangeLog{
    clid = '9-9-04'

    changeSet(id: "${clid}.3", author: "Joanna", context:'dev') {
        sql "insert into SecRole (id, name, description, inactive) values (500, 'Client', 'Greenbill access to all customers', 1)"
        sql "update SecRoleUser set SecRoleId=3 where secRoleId=1000"
        sql "update SecRoleUser set SecRoleId=6 where secRoleId=1001"
        sql "update SecRoleUser set SecRoleId=13 where secRoleId=1002"
        sql "update SecRoleUser set SecRoleId=13 where secRoleId=1003"

        sql "update SecRole set inactive=0 where id in (6,13)"
        sql "delete from SecRole where id in (1000,1001, 1002,1003)"
    }
}