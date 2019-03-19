#!/usr/bin/env bash

set -e

docker stop sqlserver-nine-db || true && docker rm sqlserver-nine-db || true

docker run --name=sqlserver-nine-db \
-e ACCEPT_EULA=Y \
-e 'SA_PASSWORD=999Foobar' \
-d -p 1433:1433 microsoft/mssql-server-linux:2017-CU4

# sleep 10

# docker exec -it sqlserver-nine-db \
# /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 123Foobarbaz! \
# -Q "CREATE DATABASE rcm_9ci_test;"

# docker exec -it sqlserver-nine-db \
# /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 123Foobarbaz! \
# -Q "use rcm_9ci_test; \
# create synonym trace_xe_event_map for sys.trace_xe_event_map; \
# create synonym trace_xe_action_map for sys.trace_xe_action_map;"



# docker run -it --rm --net="host" \
# --name=grails-nine-db \
# -e GRGIT_USER=0305edb725e4e9e308161755e13c0dd50f1d7e9d \
# -v ${PWD}:/app \
# dock9/oraclejdk8:grails-2.5.6 ./ci-scripts/dbcreate-mssql.sh test