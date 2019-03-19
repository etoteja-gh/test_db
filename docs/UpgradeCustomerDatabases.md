# Upgrade customer databases to current version

This document describes how to generate and apply migration scripts to a database with which we cannot
directly connect a grails environment.

Note that this document does not mention obvious shit, like backups on production data.

# Major vs Minor

A minor database upgrade means that the customer database is already approximately the same version as the target 
version. For example, the customer is using a 9.9.x app and you are just adding a few changes to the structure in
order to bring them new functionality.

A major upgrade is when the customer is on a previous version (e.g. 9.8.8.x) and will upgrade to a newer number.

The difference in terms of this document is that the same steps need to be repeated more than once.

For example, to get from 9.8.8.x to 9.9.x, you need first to ensure that the customer database is at the very end of 9.8.8.x before proceding to 9.9.x changes.

# The process

1. Create a new local database from the HEAD of the customer's current branch.
	* `grails -DBMS=ms -Dgrails.env=base db-create`
2. Get onto the customer's database system and export the results of the following to a file:
	* `select id from DATABASECHANGELOG where id like '9-%' order by id`
3. Transfer the file to your development box, changing the extension to `.sql`.
4. With a text editor, convert the id column into a comma-separated list of strings.
	* Hint: use regular expressions in the search and replace.
5. Surround the list with the following query:
	* `select id from DATABASECHANGELOG where id like '9-%' and id not in (<your list>)`
	* Note that the base schema will have many id's not created by our changesets.
	* We don't want to touch those.
6. Run the query against the local database you built in step 1 by directly connecting to the db.
7. Sanity check the list.
8. Replace `select id` with `delete` in the query.
9. Run the delete statement against your local database.
10. Generate a changelog script.
	* `grails -DBMS=ms -Dgrails.env=base dbm-update-sql upgrade.sql`
11. Run the script against your local database to test it.
12. Run an update again, without specifying the filename.
	* `grails -DBMS=ms -Dgrails.env=base dbm-update-sql`
13. Ensure than no sql is printed to the console.
14. Transfer the script to the target database.
15. Run the script on the target database.
	* Note: Sometimes a change will be applied directly to the customer database without inserting an entry in DATABASECHANGELOG. In this case there may be an error indicating that the change is already in place. This is not a problem.

At this point your target database is at the same version as your local database.

You can, if necessary, switch branches on your local project and run the above steps again, as many times as 
necessary to get to the desired database version.