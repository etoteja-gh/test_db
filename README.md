[![CircleCI](https://circleci.com/gh/9ci/nine-db/tree/release%2F9.9.x.svg?style=svg&circle-token=e6f75c367d32019a33e949acf47d5be09fef49f5)](https://circleci.com/gh/9ci/nine-db/tree/release%2F9.9.x)

**Note: Do not use Master branch release/9.9.x is used as main branch**

This project builds the database for 9ci software. Base on the [liquibase-gradle-plugin](https://github.com/liquibase/liquibase-gradle-plugin) which basically fires the commands through to the [Liquibase Command Line](http://www.liquibase.org/documentation/command_line.html)

These are the main types of databases we build:

1. Test -- for automated testing of the app.
2. Development -- For demos and general human app testing.
3. Seed -- This is base line db. It has settings, status codes etc that our app depends on.

## Database Changelogs

the db-create script will call the tasks 'create-db', 'init-db', 'migrations'
* **create-db** drops and creates the database
* **init-db** creates the tables based on initial-state/schema.yml
* **migrations** creates the loadData-${env}.yml in initial-state which loads the csv data in the corresponding dir

### db-create

- `./gradlew db-create` builds test on mysql
- `./gradlew -DBMS=mssql db-create` builds test on sql server
- `./gradlew db-create -Penv=seed` build the seed database
- `./gradlew db-create -Penv=dev` build the dev database

- `./gradlew -DB=fooDev db-create -Penv=dev` builds the dev db with a name of fooDev

### update

To just run a liquibase update without a full rebuild do `gradle migrations`

### Exporting the schema and data

The same flags for dbms, db and env can be used as above

- `./gradlew export-schema` dumps the shema.yml into the build/initial-state
- `./gradlew export-data` dumps the loadData-$env.yml and the csv

For example to generate the seed
`./gradlew export-schema export-data -Penv=seed`

## Using Docker

There are some docker scripts to light up db server to test against in the docker dir.
`mysql-start` will start a mysql on default 3606
`mssql-start` will light up a sql server on 1433

## Circle CI
Project is built on circle ci. See the .circleci/config.yml file for reference.
```ci-scripts/dbcreate.sh``` is called during the build, which runs the migrations to load the data into database.
The script checks if it is a release branch, and if it is, it will dump the mysql database into an sql file
and then checkout the db-create-sql branch and move the mysql dump file under ```mysq/test_release_version.sql``` (eg test_9.9.x.xql)
This ```db-create-sql``` branch is then used by other projects to load the data into database during circleci build.

See scripts under /ci-scripts directory for reference.


## Migration scripts

TODO UPDATE THE DOCS HERE

See [Liquibase Anatomy](docs/LiquibaseAnatomy.md) to see how the database is stored. The end of this document
describes how to name your migration scripts and how to execute them.

See [CookBook.groovy](docs/CookBook.groovy) to see examples of migration script fragments.

## Editing old scripts.

Each script can have multiple __changeSets.__ Each changeSet should consist of changes which are related to each
other. Likewise each changeSet should have some relation to the named purpose of the script.

__Once a script has been committed and pushed, any changeSet which has already been created should be immutable.__

TODO add notes about setting to runAlways

__Liquibase adds a checksum for each changeSet.__ If __ANY__ change is made to that changeSet, __including the nature
and amount of white space__, that checksum will change and all subsequent migrations to that any database which
ran the original version of the changeSet will fail due to that fact.

If a script is recent and a new changeSet fits into the scheme of the script, then it's OK to add the changeSet to the end of the script.  However if the script has spent more than a week or so pushed to a non-developer branch of the github repository, it should be considered off-limits and a new script file created.

## Update scripts for a specific environment

To specify changeSet to be applied for specific env add `context` property, value should be an environment, instead
of `development` use `dev` all other as is: `test`, `base`

	changeSet(id: "${clid}.1", author: "xyz", context:'dev') {}

Will be applied all `changeSet`s with this context and all that has no context.

For migration plugin updates use `grails dbm-update --contexts='dev'`

