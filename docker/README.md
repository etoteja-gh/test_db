## MS Sql Server



Install client to inspect the docker instance https://docs.microsoft.com/en-us/sql/sql-operations-studio/download


## Refs
https://github.com/mysql/mysql-docker

https://github.com/oracle/docker-images/blob/master/OpenJDK/java-8/Dockerfile

https://github.com/airdock-io/docker-oracle-jdk/blob/master/jdk-1.8/Dockerfile

https://github.com/mozart-analytics/grails-docker

connecting 2 dockers together
https://rominirani.com/docker-tutorial-series-part-8-linking-containers-69a4e5bf50fb
https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach#24326540

## running it

*build* `docker build -t nine-db .` from docker dir
*run* `docker run --name=nine-db -v ${PWD}:/app -e MYSQL_ROOT_PASSWORD=999plazadrive -e MYSQL_ROOT_HOST=% -d -p 3307:3306 nine-db` from root project dir
*exec* `docker exec -it nine-db grails test db-create`
*mysqldump* `mysqldump rcm-9ci-test > docker/data/rcm-9ci-test.sql`

from outside can be connected to 3307 now. can also be changed above to 3306:3306 if no other mysql is running.

runs with defaults
`docker run --name=nine-db -d -p 3306:3306 nine-db`

creates database and loads sql data file
`docker run --name=nine-db -v ${PWD}:/app -v ${PWD}/docker/data:/docker-entrypoint-initdb.d -e MYSQL_DATABASE=rcm-9ci-test -e MYSQL_ROOT_PASSWORD=999plazadrive -e MYSQL_ROOT_HOST=% -d -p 3307:3306 grails-mysql`