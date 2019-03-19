#!/usr/bin/env bash

set -e

docker run --name=mysql-nine-db \
-e MYSQL_ROOT_PASSWORD=999Foobar \
-e MYSQL_ROOT_HOST=% \
-d -p 3306:3306 mysql/mysql-server:5.7
