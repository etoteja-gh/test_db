package v9_9_x

databaseChangeLog{
    clid = '9-9-08'

    // See dev/9-9-08-usersDevData.groovy for stuff that was split off.

    changeSet(id: "${clid}.3.5", author: 'Ken') {
        dropDefaultValue(tableName:"Users", columnName:"IsManager" )
        dropDefaultValue(tableName:"Users", columnName:"InVisible" )
        dropDefaultValue(tableName:"Users", columnName:"IsSuperUser" )
        // dropDefaultValue(tableName:"Users", columnName:"ManagerId" )

        dropDefaultValue(tableName:"Users", columnName:"UserType" )
        dropDefaultValue(tableName:"Users", columnName:"IsAdmin" )
        dropDefaultValue(tableName:"Users", columnName:"IsBasic" )
        dropDefaultValue(tableName:"Users", columnName:"IsGuest" )
    }

    changeSet(id: "${clid}.4", author: "Sudhir") {
        dropColumn(tableName:"Users" , columnName:"DealApprovalLimit")
        dropColumn(tableName:"Users" , columnName:"Description")
        dropColumn(tableName:"Users" , columnName:"Email2")
        dropColumn(tableName:"Users" , columnName:"IsManager")
        dropColumn(tableName:"Users" , columnName:"IsSuperUser")
        dropColumn(tableName:"Users" , columnName:"InVisible")
        dropColumn(tableName:"Users" , columnName:"LName")
        // dropColumn(tableName:"Users" , columnName:"ManagerId")
        dropColumn(tableName:"Users" , columnName:"PromoApprovalLimit")
        dropColumn(tableName:"Users" , columnName:"Source")
        dropColumn(tableName:"Users" , columnName:"SourceId")

        dropColumn(tableName:"Users" , columnName:"UserType")
        dropColumn(tableName:"Users" , columnName:"IsAdmin")
        dropColumn(tableName:"Users" , columnName:"IsBasic")
        dropColumn(tableName:"Users" , columnName:"IsGuest")

        sql "update Users set email = 'sachin@sachin.com' where email = 'sachin@sachin.comx'"
        sql "update Users set email = null where id in (1,2)"
    }

    changeSet(id: "${clid}.5", author: 'sudhir') {
        sql """
            update SecRoleUser set secRoleid=2 where exists (select 1 from SecRole r where r.name='Client' and r.id= SecRoleUser.secRoleId)
            """
        sql "delete from SecRole where name = 'Client'"
    }

    changeSet(id: "${clid}.6", author: 'sudhir') {
        sql "insert into SecRole (id, Name, Description) values (14, 'Branch',  'branch users / store users')"
    }



}