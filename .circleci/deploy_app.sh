#!/bin/sh

# copy this file in /var/9ci/deploy/ninedb/ directory on your server

# parameters:
# docker_repo. default dock9/nine-db
# interval. default 10 seconds
# timeout. default 1200 seconds
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

# $1: docker_repo. default dock9/nine-db
# $2: interval. default 10 seconds
# $3: timeout. default 1200 seconds
# $4: mysql docker repo. default mysql/mysql-server:5.7
# $5: mssql docker repo. default microsoft/mssql-server-linux:2017-CU4
echo "Logining to docker hub..."
docker login -u $1 -p $2
echo "Logged in with ${1} user to docker hub..."

echo "Pulling mysql docker image from docker hub..."
# docker stop sqlserver-nine-db || true && docker rm sqlserver-nine-db || true
docker pull ${4}
# docker run --name=sqlserver-nine-db \
#     -e ACCEPT_EULA=Y \
#     -e 'SA_PASSWORD=999Foobar' \
#     -d -p 1433:1433 microsoft/mssql-server-linux:2017-CU4

echo "Pulling mssql docker image from docker hub..."
# docker stop mysql-nine-db || true && docker rm mysql-nine-db || true
docker pull ${5}
# docker run --name=mysql-nine-db \
#     -e MYSQL_ROOT_PASSWORD=999Foobar \
#     -e MYSQL_ROOT_HOST=% \
#     -d -p 3306:3306 mysql/mysql-server:5.7

echo "Pulling ${3} docker image from docker hub..."
check_docker_repo $3 10 1200

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