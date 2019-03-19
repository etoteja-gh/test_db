// this is a cookbook for our common liquibase database refactorings -->
// see http://www.liquibase.org/manual/refactoring_commands

/****ADDING Columns****/
	//see http://www.liquibase.org/manual/column for column options 
	addColumn(tableName:'ApiLayouts') {
		column(name:'LookupBatchType', type:'varchar(255)')
	}
	//common column types
	column(name:'someAmount', type:'numeric(19,4)') //this is our money type
	column(name:'somePercent', type:'numeric(9,6)') //this is our percent type
	column(name:'someInt', type:'int')
	column(name:'someId', type:'bigint')
	column(name:'someDate', type:'DATETIME')
	column(name:'sombool', type:'BOOLEAN')
	column(name:'sombTEXT', type:'TEXT')
	column(name:'sombTEXT', type:'VARCHAR')
	//WITH CONSTRAINTS
	addColumn(tableName:'ApiLayouts') {
		column(name:'LookupBatchType', type:'varchar(255)'){
		    constraints(primaryKey:"true",nullable:"false")
		}
	}

/** RENAMING **/
    renameTable(oldTableName:"CfgUsers", newTableName:"Users")
	
	//columnDataType is the current datatype of the column and is required for mysql (I think)-->
    renameColumn(tableName: "SecRoleUser", oldColumnName: "PersonId", newColumnName: "userId", columnDataType: "bigInt")
    
/** Modify **/	
	dropTable(tableName:"SecRoleUser")
    dropColumn(tableName:"SecRoleUser" , columnName:"SystemRow")
    addDefaultValue(tableName:"SomeTable",columnName:"XCol" ,defaultValue:"blah")
    dropDefaultValue(tableName:"SomeTable",columnName:"XCol" )
    modifyDataType(tableName:'ArTranAging', columnName:'Aging1', newDataType:'numeric(19,4)')

    //columnDataType is the current datatype of the column and is required for mysql (we think)
    dropNotNullConstraint(tableName:"Employee",columnName:"employerId",columnDataType:"int")
    
    /* old xml, replace as we modify
	<addNotNullConstraint tableName="Employee" columnName="employerId" defaultNullValue="1" /><!--defaultNullValue is what to set it to if its null. only done once and is not the same as column default-->
	
	<addUniqueConstraint tableName="Person" columnNames="Login,Email" constraintName="UX_Person_Unique_LoginAndEmail"/>
	<dropUniqueConstraint tableName="Person" constraintName="UX_Person_Unique_LoginAndEmail"/>

	<modifyColumn tableName="Person">
	    <column name="Firstname" type="VARCHAR(4000)"/>
	</modifyColumn>
	*/

//INDEXES
    createIndex(tableName:"Persons", indexName:"IX_Persons_Names"){
	   column(name:"col1")
	   column(name:"col1")
	}
	//UNIQUE
	createIndex(unique:"true", tableName:"Roles", indexName:"IX_Role_Names"){
	   column(name:"name")
	   column(name:"col1")
	}
	
    dropIndex(tableName:"SecRoleUser" , indexName:"AclRoles_Name")

//SQL
	sql("insert into ...")
    
//checking if its a certain DB version
//see http://www.liquibase.org/manual/preconditions	-- NO!  BROKEN!
// preCondition FAILS during export of sql.  
// Use dbms:'mysql' or dbms:'mssql' in the changeSet as shown below.
//NOTE: The precondition exports everything and then you need to go modify the sql afterward.
	preConditions(onFail:"CONTINUE"){
		dbms(type:"mssql")
    } //or
    preConditions(onFail:"MARK_RAN"){ dbms(type:"mysql") }

// INSTEAD OF PRECONDITIONS YOU SHOULD SPECIFY dbms IN changeSet.
// This way the changeset only exports to sql if you are connecting to the appropriate brand of server.
	//changeSet(id:"${clid}.5", dbms:'mysql', ...)
	//changeSet(id:"${clid}.6", dbms:'mssql', ...)
changeSet(id:"${clid}.5", dbms:'mysql')
changeSet(id:"${clid}.6", dbms:'mssql')
	
//Creating a table
createTable(tableName: 'PaymentsDeleted') {
	column(name:'OID', type:'bigint' ) { constraints(primaryKey:true, nullable:false) }
	column(name:'ArBatchId', type:'bigint')
	column(name:'Amount', type:'numeric(19,4)', defaultValueNumeric:0)
	column(name:'CreatedDate', type:'timestamp')
	column(name:'CustSourceId', type:'VARCHAR(50)')
	column(name:'DeletedBy', type:'bigint', defaultValue:0) { constraints(nullable:false) }
	column(name:'DeletedDate', type:'timestamp')
	column(name:'DocDate', type:'timestamp')
	column(name:'RefNum', type:'varchar(50)')
}

//SQL SERVER NUGGETS 
//Dropping a primary key constraint
sql("""
SET @SQL = 'ALTER TABLE **TABLENAME** DROP CONSTRAINT |ConstraintName| '
SET @SQL = REPLACE(@SQL, '|ConstraintName|', 
    ( SELECT name FROM sysobjects WHERE xtype = 'PK' AND parent_obj = OBJECT_ID('**TABLENAME**'))
)
EXEC (@SQL)
""")


// SPECIFY environment (dev.test,base)
//valids are: development, dev, test , base
changeSet(id: "${clid}.1", author: "xyz", description: 'desc', context:'dev') {}



