# How to create database upgrade script

## Overview

This document describes how to programmatically generate an incremental database upgrade script 
for any 9ci application database.  This does not include load databases but does include history 
databases.

Note that history databases are rarely updated because so little of the structure is used, so the
script built using the technique described here will probably be very different than for the main
database.  Because of this a separate but identical process should be used for the history 
database.

## Details

<a name="getTargetChangelog"/>
### Get the target changelog

The changelog is held in a table in any 9ci database.  We're interested in the __id__ column.

If the target database and the desired version are not the same major number (9.7 and 9.8 for 
example) then you want to read [this](#majorUpgradesNote).

The query you need is as follows:

    select id from DATABASECHANGELOG where id like '9-%' order by id

where '9-%' is the database major version, and we're assuming Microsoft SQL Server.  Different 
databases may need changes to the query.

Once this is done, select the id column and copy the entire result set.  Get it into a text file 
on your reference database server.

<a name="convertTargetChangelog"/>
### Convert target changelog to list

The file you got from the target changlog needs to be suitable for use in 
a query.  It needs to be a comma-separated list of quoted strings.  It will be referenced as 
{LIST} below.

<a name="deleteUnwantedRefDbEntries"/>
### Delete unwanted entries in reference database

Note that this needs to be done on the __reference__ database, not the __target__ database.

> delete from DATABASECHANGELOG where id like '9-%' and id not in ({LIST})

<a name="generateUpgradeScript"/>
### Generate upgrade script

In a command-line terminal in your grails environment, nine-db project:

    grails -DBMS=ms prod dbm-update-sql --contexts='prod' update.sql

where:

1. -DBMS=ms means use Microsoft SQL Server
2. prod means use the production database and environment.
3. dbm-update-sql is the command that tells grails to build an update script
4. update.sql is the file the changes will be written to.

<a name="majorUpgradesNotes"/>
### Major upgrades notes

Presumably the target database is the same version as the reference database.  It's possible to 
do an upgrade when this is not the case but the more intervening changes the less likely the 
process will generate a valid database.

To use this process to upgrade major versions, first you want to follow this document to bring 
the database to the latest version of its current version, and then again for each successive 
major version.

Note that it may be faster and easier to introduce a new database of the desired version and copy 
data over.
