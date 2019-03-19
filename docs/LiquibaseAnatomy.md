# Liquibase anatomy of nine-db

This document describes in moderate detail how liquibase and the database migration plugin are used to create the 
database.

# Components

The standard databases are created from these sources:

* __grails-app/migrations/schema.groovy__ contains structure.
* __grails-app/migrations/changelog.groovy__ contains incremental changes to schema.groovy
* __db/data/*__ contains xml data to be inserted into the database.
* __db/sqlscripts/*__ contains functions and stored procedures.

* __db/data/base/*.xml__ contains base data included with every database.
* __db/data/test/*.xml__ contains data for test databases.
* __db/data/demo/*.xml__ contains data for development and demos.

## schema.groovy

grails-app/migrations/schema.groovy is a structural snapshot of the database at the moment the new version was 
created. It is one giant Liquibase file containing the changeSets necessary to convert an empty database into a 
bare table structure with indexes.

## changelog.groovy

grails-app/migrations/changelog.groovy is the master migration script. Individual migration scripts in 
grails-app/migrations contain changeSets which alter the database structure, indexes, programmability or data. This
file defines the order those migration scripts are executed.

## db/data/*

The db/data directory contains data sets for production, development and testing, and a few others. Each direct
child of db/data maps to a grails environment in the nine-db project.

The __base__ directory is unique in that most grails environments will pull in base data first, and then the demo
or test data on top of it.  This data is what is supplied to a new customer. It contains basic default settings and
configuration data, anything that will make setting up the customer easier.

The __test__ directory contains data specific to testing. This data is appended to the base data in order to make a
test database.

The __demo__ directory contains a basic demo system, also used for development.

The __history__ directory contains just a few rows of data to illustrate how a separate history database works.

## db/sqlscripts

The db/sqlscripts directories contain stored procedures and functions for the database.

# Editing rules

All the files mentioned in this document have rules regarding when and how they can be edited.

The __schema.groovy__ file, the files in __db/data__ and in __db/sqlscripts__ can be directly changed ONLY when 
creating a new database version. Even then, there are conditions which must be met. For schema.groovy:

* Any change which will affect the function of the app against the database must be done in a migration script
as direct edits will break customer upgrades.
	* DECIMAL to NUMERIC is OK. NUMERIC to VARCHAR is not OK.
	* Changing precision or type to something incompatible with the original column is not OK.
* The edits must improve the reliability of the file
	* Adding mysql, mssql and oracle changeSets to achieve the same result on all databases is OK.

For xml data files:
* Data can be moved from one group to another as appropriate:
	* It must be done during a version upgrade.
	* Moving a row from demo or test to base data, or vice versa as appropriate is OK.
	* Adding rows or deleting them is not OK and must be handled in a change script.

# changelog.groovy

Changelog.groovy specifies which migration scripts are pulled in, in what order.  It is the master migration script.

When you make a migration script, you need to add it to the changelog.groovy file before it will be seen.

Edit rules:
* When you create a migration script and want it included in the basic database structure.

# db/data/\*/\*.xml files

Test and development data are stored in db/data/. Each direct subdirectory has a different purpose. 

# Naming conventions

Scripts go into the __grails-app/migrations__ directory. We use a naming convention to put them in the correct order.

	9-9-01-ArTranOutApi-branchSourceId.groovy
	9-9-02-ArReason.groovy
	9-9-03-Report.groovy

In addition to naming the files in order, they need to be placed into changelog.groovy as well:

	databaseChangeLog = {
		include(file: '9-9-01-ArTranOutApi-branchSourceId.groovy')
		include(file: '9-9-02-ArReason.groovy')
		include(file: '9-9-03-Report.groovy')
		...
	}
