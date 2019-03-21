#!/usr/bin/env bash

set -e

# setup variables
gitBranch=db-create-sql
# MYSQL_SERVER_ADDRESS=192.168.0.121
echo "backing up $1 > $2 "

mysqldump --opt --host=${MYSQL_SERVER_ADDRESS} \
--user=root --password=999Foobar \
--routines=true \
--skip-dump-date \
$1 > $2

rm -rf build/$gitBranch

git config --global user.name "9cibot"
git config --global user.email "9cibot@9ci.com"

git clone -b $gitBranch --single-branch --depth 1 \
https://${GRGIT_USER}@github.com/9ci/nine-db.git build/$gitBranch

mkdir -p build/$gitBranch/mysql

cp $2 build/$gitBranch/mysql

cd build/$gitBranch

git add .
git commit -a -m "CI built and pushed $2 [skip ci]"
git push origin HEAD

