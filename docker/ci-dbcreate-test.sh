#!/usr/bin/env bash

set -e

docker stop mysql-nine-db || true && docker rm mysql-nine-db || true

./docker/mysql-start.sh

docker run -it --rm --net="host" \
--name=gradle-nine-db \
-e GRGIT_USER=0305edb725e4e9e308161755e13c0dd50f1d7e9d \
-e CIRCLE_BRANCH="release/9.9.x" \
-v ${PWD}:/app \
dock9/oraclejdk8:gradle-3.5.1 

./ci-scripts/dbcreate.sh test



