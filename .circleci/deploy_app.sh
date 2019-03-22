#!/bin/sh

# copy this file in /var/9ci/deploy/ninedb/ directory on your server

# parameters:
# docker_repo. default dock9/nine-db
# interval. default 10 seconds
# timeout. default 1200 seconds
# mysql_host. default 127.0.0.1
# mssql_host. default 127.0.0.1
function check_docker_repo () {
    prev_image_state=$(docker images | grep ${1})
    echo ${prev_image_state}
    previous_time=$(date +%s)
    echo ${prev_image_state} ${previous_time}

    while true ; do
        docker pull $1

        current_image_state=$(docker images | grep ${1})

        currenttime=$(date +%s)
        duration=$(( $currenttime - $previous_time ))

        echo ${current_image_state} ${currenttime} ${duration}
        echo ${prev_image_state} ${previous_time}
        if [[ ${prev_image_state} == "" ]]; then
            echo "success: ${1} was pulled with lateast version from docker hub."
            echo "backing up database: "
            docker run -e MYSQL_SERVER_ADDRESS=${4} -e MSSQL_SERVER_ADDRESS=${5} ${1} 
            return 1
        elif [[ "${prev_image_state}" != "${current_image_state}" ]]; then
            echo "success: ${1} was already updated with lateast version from docker hub."
            return 1
        elif [[ "$currenttime" > "${3}" ]]; then
            break
        else
            echo "processing: wating until ${1} will be completed to build on docker hub..."
        fi
        sleep ${2}
    done

    echo "failed: timed out to pull ${1} from docker hub."
    return 0
}

# Arguments
# $1: $DOCKERHUB_USER.
# $2: $DOCKERHUB_PASSWORD
# $3: $DOCKER_REPOSITORY:$DOCKER_REPOSITORY_TAG. default dock9/nine-db:latest
# $4: mysql/mysql-server:5.7
# $5: $MYSQL_SERVER_ADDRESS. default 127.0.0.1
# $6: microsoft/mssql-server-linux:2017-CU4
# $7: $MSSQL_SERVER_ADDRESS. default 127.0.0.1
# $8: $CIRCLE_BRANCH

echo "Logining to docker hub..."
docker login -u $1 -p $2
echo "Logged in with ${1} user to docker hub..."

# echo "Pulling mysql docker image from docker hub..."
# # docker stop sqlserver-nine-db || true && docker rm sqlserver-nine-db || true
# docker pull ${4}
# docker run --name=sqlserver-nine-db \
#     -e ACCEPT_EULA=Y \
#     -e 'SA_PASSWORD=999Foobar' \
#     -d -p 1433:1433 ${4}

# echo "Pulling mssql docker image from docker hub..."
# docker stop mysql-nine-db || true && docker rm mysql-nine-db || true
# docker pull ${6}
# docker run --name=mysql-nine-db \
#     -e MYSQL_ROOT_PASSWORD=999Foobar \
#     -e MYSQL_ROOT_HOST=% \
#     -d -p 3306:3306 ${6}

echo "Pulling ${3} docker image from docker hub..."
check_docker_repo $3 10 1200 $5 $7

echo "Removing every gabage docker images..."
docker container prune << EOF
y
EOF

docker image prune << EOF
y
EOF

docker network prune << EOF
y
EOF

docker volume prune << EOF
y
EOF

# docker rmi $(docker images -f "dangling=true" -q)

echo "done"