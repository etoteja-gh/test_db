#!/usr/bin/env bash

set -e

# setup variables
ver="${CIRCLE_BRANCH#release/}"
#sqlFile="test_$ver.sql"
sqlFile="test_$ver.sql"
echo $sqlFile
dbName="rcm_9ci_test"
gitBranch="9.9.x"

env="test"

if test $1 ; then
  env=$1
fi

echo "Running on $env mode"

# run through all of them to test mysql by default
gradle -Penv=$env -PmysqlHost="${MYSQL_SERVER_ADDRESS}" db-create
gradle -DDBMS=mssql -Penv="$env" -PmssqlHost="${MSSQL_SERVER_ADDRESS}" db-create
#grails -DB=$dbName $1 db-create

# dump the mysql test data for other projects
mkdir -p build/mysqldump

# if the CIRCLE_BRANCH starts with release/ then do the dump and publish
if [ "${CIRCLE_BRANCH#release/}" != "${CIRCLE_BRANCH}" ]; then
   echo Dumping $dbName to $sqlFile
  ./ci-scripts/gitpush-sqldump.sh $dbName build/mysqldump/$sqlFile
else
   echo Not dumping circle branch $CIRCLE_BRANCH
fi
