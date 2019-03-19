#!/usr/bin/env bash

set -e

# setup variables
sqlFile="$1_$CIRCLE_BRANCH.sql"
dbName="rcm_9ci_$1"

mkdir -p build/mysqldump

mysqldump --opt --host=127.0.0.1 \
--user=root --password=999Foobar \
--routines=true \
--skip-dump-date \
$dbName > build/mysqldump/$sqlFile

