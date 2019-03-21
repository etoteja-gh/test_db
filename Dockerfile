# MYSQL_DATABASE=test
# MYSQL_USERNAME=rcm_9ci_test
# MYSQL_ROOT_PASSWORD=999Foobar
# MYSQL_ROOT_HOST=%
# MYSQL_PORT=3306
# ACCEPT_EULA=Y
# SA_PASSWORD=999Foobar
# GRGIT_USER=0305edb725e4e9e308161755e13c0dd50f1d7e9d
# CIRCLE_BRANCH=release/9.9.x
# PWD=123456

FROM dock9/oraclejdk8:gradle-3.5.1
# GRGIT_USER=0305edb725e4e9e308161755e13c0dd50f1d7e9d
# CIRCLE_BRANCH=release/9.9.x
# PWD=123456

RUN apk update && apk add bash

WORKDIR /var/lib/nine-db

RUN mkdir -p /var/lib/nine-db

COPY . /var/lib/nine-db/

RUN ls /var/lib/nine-db/

# FROM microsoft/mssql-server-linux:2017-CU4
# # ACCEPT_EULA=Y
# # SA_PASSWORD=999Foobar
# EXPOSE 1433

# FROM mysql/mysql-server:5.7
# # MYSQL_DATABASE=test
# # MYSQL_USERNAME=rcm_9ci_test
# # MYSQL_ROOT_PASSWORD=999Foobar
# # MYSQL_ROOT_HOST=%
# # MYSQL_PORT=3306
# EXPOSE 3306

# COPY . /var/lib/nine-db/

# RUN ls /var/lib/nine-db/

RUN /var/lib/nine-db/ci-scripts/dbcreate.sh dev
# CMD ["ci-scripts/dbcreate.sh", "dev"]