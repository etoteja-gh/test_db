#!/bin/sh

###############################################################################################################################
# NOTE: Copy this file in /var/9ci/deploy/ninedb/ directory on your server.
# Add DEPLOYMENT_SCRIPT_FILE_PATH into your CircleCI environemnt variables. The value is /var/9ci/deploy/dock9ocr/deploy_app.sh
###############################################################################################################################

# Arguments
# --docker-user: $DOCKERHUB_USER.
# --docker-password: $DOCKERHUB_PASSWORD
# --docker-repo: $DOCKER_REPOSITORY:$DOCKER_REPOSITORY_TAG. default dock9/nine-db:latest
# --mysql-repo=$MYSQL_REPOSITORY
# --mssql-repo=$MSSQL_REPOSITORY
# --gradle-jdk-repo=$GRADLE_JDK_REPOSITORY
# --rancher-api-access-key: $RANCHER_API_ACCESS_KEY
# --rancher-api-secret-key: $RANCHER_API_SECRET_KEY
# --rancher-workload-redeployment-api: $RANCHER_WORKLOAD_REDEPLOYMENT_API
# --rancher-workload-redeployment-api-data: $RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA

# Example Command
# ./deploy_app.sh \
#  --docker-user=test \
#  --docker-password='123qwe!@#QWE' \
#  --docker-repo=dock9/ocr:latest \
#  --mysql-repo=mysql/mysql-server:5.7 \
#  --mssql-repo=microsoft/mssql-server-linux:2017-CU4 \
#  --gradle-jdk-repo=dock9/oraclejdk8:gradle-3.5.1 \
#  --rancher-api-access-key=token-8pv6f \
#  --rancher-api-secret-key=462fwxgwhw94lsnspqmktdvnsbjr786nhfdwst5h8tlzlsp7tvkf97 \
#  --rancher-workload-redeployment-api='https://ln02.9ci.com:8443/v3/project/c-wmqt5:p-6qb8v/workloads/deployment:demo-9ci-com:nine-db \
#  --rancher-workload-redeployment-api-data='{"annotations":{"cattle.io/timestamp":"2019-04-10T03:20:51Z"},"baseType":"workload","containers":[{"allowPrivilegeEscalation":true,"environment":{"DOCKERHUB_PASSWORD":"123qwe!@#QWE","DOCKERHUB_USER":"radikkaviev83","DOCKER_REPOSITORY":"dock9/nine-db","GRADLE_JDK_REPOSITORY":"dock9/oraclejdk8:gradle-3.5.1","MSSQL_REPOSITORY":"microsoft/mssql-server-linux:2017-CU4","MYSQL_REPOSITORY":"mysql/mysql-server:5.7"},"image":"dock9/nine-db","imagePullPolicy":"IfNotPresent","initContainer":false,"name":"nine-db","ports":[{"containerPort":3306,"dnsName":"nine-db-hostport","kind":"HostPort","name":"3306tcp33060","protocol":"TCP","sourcePort":3306,"type":"/v3/project/schemas/containerPort"},{"containerPort":1433,"dnsName":"nine-db-hostport","kind":"HostPort","name":"1433tcp14330","protocol":"TCP","sourcePort":1433,"type":"/v3/project/schemas/containerPort"}],"privileged":true,"readOnly":false,"resources":{"type":"/v3/project/schemas/resourceRequirements","requests":{},"limits":{}},"restartCount":0,"runAsNonRoot":false,"stdin":true,"stdinOnce":false,"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","tty":true,"type":"container","capAdd":[],"capDrop":[]}],"created":"2019-03-19T21:10:41Z","createdTS":1553029841000,"creatorId":null,"deploymentConfig":{"maxSurge":0,"maxUnavailable":1,"minReadySeconds":0,"progressDeadlineSeconds":600,"revisionHistoryLimit":10,"strategy":"RollingUpdate"},"deploymentStatus":{"availableReplicas":1,"conditions":[{"lastTransitionTime":"2019-04-10T00:47:32Z","lastTransitionTimeTS":1554857252000,"lastUpdateTime":"2019-04-10T00:47:32Z","lastUpdateTimeTS":1554857252000,"message":"Deployment has minimum availability.","reason":"MinimumReplicasAvailable","status":"True","type":"Available"},{"lastTransitionTime":"2019-03-19T21:10:41Z","lastTransitionTimeTS":1553029841000,"lastUpdateTime":"2019-04-10T03:18:58Z","lastUpdateTimeTS":1554866338000,"message":"ReplicaSet \"nine-db-7d4654db65\" has successfully progressed.","reason":"NewReplicaSetAvailable","status":"True","type":"Progressing"}],"observedGeneration":45,"readyReplicas":1,"replicas":1,"type":"/v3/project/schemas/deploymentStatus","unavailableReplicas":0,"updatedReplicas":1},"dnsPolicy":"ClusterFirst","hostIPC":false,"hostNetwork":false,"hostPID":false,"id":"deployment:demo-9ci-com:nine-db","labels":{"workload.user.cattle.io/workloadselector":"deployment-demo-9ci-com-nine-db"},"name":"nine-db","namespaceId":"demo-9ci-com","paused":false,"projectId":"c-wmqt5:p-6qb8v","publicEndpoints":[{"addresses":["192.155.90.60"],"allNodes":false,"ingressId":null,"nodeId":"c-wmqt5:m-a641f76c8758","podId":null,"port":1433,"protocol":"TCP","serviceId":null,"type":"publicEndpoint"},{"addresses":["192.155.90.60"],"allNodes":false,"ingressId":null,"nodeId":"c-wmqt5:m-a641f76c8758","podId":null,"port":3306,"protocol":"TCP","serviceId":null,"type":"publicEndpoint"}],"restartPolicy":"Always","scale":1,"schedulerName":"default-scheduler","selector":{"matchLabels":{"workload.user.cattle.io/workloadselector":"deployment-demo-9ci-com-nine-db"},"type":"/v3/project/schemas/labelSelector"},"state":"active","terminationGracePeriodSeconds":30,"transitioning":"no","transitioningMessage":"","type":"deployment","uuid":"739d3674-4a8b-11e9-872b-6a920e85bd35","workloadAnnotations":{"deployment.kubernetes.io/revision":"20","field.cattle.io/creatorId":"user-v2pfp"},"workloadLabels":{"cattle.io/creator":"norman","workload.user.cattle.io/workloadselector":"deployment-demo-9ci-com-nine-db"}}'


# Set default values. These variables will be replaced from arguments.
DOCKERHUB_USER=""
DOCKERHUB_PASSWORD=""
DOCKER_REPOSITORY="dock9/nine-db:latest"
MYSQL_REPOSITORY="mysql/mysql-server:5.7"
MSSQL_REPOSITORY="microsoft/mssql-server-linux:2017-CU4"
GRADLE_JDK_REPOSITORY="dock9/oraclejdk8:gradle-3.5.1"
RANCHER_API_ACCESS_KEY=""
RANCHER_API_SECRET_KEY=""
RANCHER_WORKLOAD_REDEPLOYMENT_API=""
RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA=""


# Function: check_docker_repo
# Feature: pull docker. if need to wait for compiling on docker hub, this function check every 'interval' seconds till 'timeout' seconds.
# parameters:
#   --interval: default 10 seconds
#   --timeout: default 1200 seconds

function check_docker_repo () {
    # Check parameters
    for i in "$@"
    do
    case $i in
        --interval=*)
        INTERVAL="${i#*=}"
        shift
        ;;
        --timeout=*)
        TIMEOUT="${i#*=}"
        shift
        ;;
        --default)
        DEFAULT=YES
        shift # past argument
        ;;
        *)    # unknown option
    esac
    done
    prev_image_state=$(docker images | grep ${DOCKER_REPOSITORY})
    echo ${prev_image_state}
    previous_time=$(date +%s)
    echo ${prev_image_state} ${previous_time}

    while true ; do
        docker pull ${DOCKER_REPOSITORY}

        current_image_state=$(docker images | grep ${DOCKER_REPOSITORY})

        currenttime=$(date +%s)
        duration=$(( $currenttime - $previous_time ))

        echo ${current_image_state} ${currenttime} ${duration}
        echo ${prev_image_state} ${previous_time}

        if [[ ${prev_image_state} == "" ]]; then
            echo "success: ${DOCKER_REPOSITORY} was pulled with lateast version from docker hub."
            echo "backing up database ..."
            docker run --privileged -d \
                --rm --name=nine-db \
                -e DOCKER_DAEMON_ARGS="-D" \
                -e MYSQL_REPOSITORY=${MYSQL_REPOSITORY} \
                -e MSSQL_REPOSITORY=${MSSQL_REPOSITORY} \
                -e GRADLE_JDK_REPOSITORY=${GRADLE_JDK_REPOSITORY} \
                -e DOCKERHUB_USER=${DOCKERHUB_USER} \
                -e DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD} \
                -p 3306:3306 -p 1433:1433 \
                ${DOCKER_REPOSITORY}

            # To redeploy workload, call Rancher API.
            CURRENT_TIME=$(date +"%Y-%m-%dT%H:%M:%SZ")
            ORIGIN_API_DATA=$RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA
            ORIGIN_TEXT="replace_with_current_time"
            REPLACE_TEXT="${CURRENT_TIME}"
            RANCHER_API_DATA=${ORIGIN_API_DATA//$ORIGIN_TEXT/$REPLACE_TEXT}

            curl -u "${RANCHER_API_ACCESS_KEY}:${RANCHER_API_SECRET_KEY}" \
            -k \
            -X PUT \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            -d "${RANCHER_API_DATA}" \
            ${RANCHER_WORKLOAD_REDEPLOYMENT_API}

            return 1
        elif [[ "${prev_image_state}" != "${current_image_state}" ]]; then
            echo "success: ${DOCKER_REPOSITORY} was already updated with lateast version from docker hub."
            return 1
        elif [[ "$currenttime" > "${TIMEOUT}" ]]; then
            break
        else
            echo "processing: wating until ${DOCKER_REPOSITORY} will be completed to build on docker hub..."
        fi
        sleep $INTERVAL
    done

    echo "failed: timed out to pull ${DOCKER_REPOSITORY} from docker hub."
    return 0
}

# Check arguments of shell script
for i in "$@"
do
case $i in
    --docker-user=*)
    DOCKERHUB_USER="${i#*=}"
    shift
    ;;
    --docker-password=*)
    DOCKERHUB_PASSWORD="${i#*=}"
    shift
    ;;
    --docker-repo=*)
    DOCKER_REPOSITORY="${i#*=}"
    shift
    ;;
    --mysql-repo=*)
    MYSQL_REPOSITORY="${i#*=}"
    shift
    ;;
    --mssql-repo=*)
    MSSQL_REPOSITORY="${i#*=}"
    shift
    ;;
    --gradle-jdk-repo=*)
    GRADLE_JDK_REPOSITORY="${i#*=}"
    shift
    ;;
    --rancher-api-access-key=*)
    RANCHER_API_ACCESS_KEY="${i#*=}"
    shift
    ;;
    --rancher-api-secret-key=*)
    RANCHER_API_SECRET_KEY="${i#*=}"
    shift
    ;;
    --rancher-workload-redeployment-api=*)
    RANCHER_WORKLOAD_REDEPLOYMENT_API="${i#*=}"
    shift
    ;;
    --rancher-workload-redeployment-api-data=*)
    RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA="${i#*=}"
    shift
    ;;
    --circl-branch=*)
    CIRCLE_BRANCH="${i#*=}"
    shift
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
esac
done


echo "Logining to docker hub..."
docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASSWORD
echo "Logged in with ${DOCKERHUB_USER} user to docker hub..."

# echo "Pulling mysql docker image from docker hub..."
# # docker stop sqlserver-nine-db || true && docker rm sqlserver-nine-db || true
# docker pull ${MYSQL_REPOSITORY}
# docker run --name=sqlserver-nine-db \
#     -e ACCEPT_EULA=Y \
#     -e 'SA_PASSWORD=999Foobar' \
#     -d -p 1433:1433 ${MYSQL_REPOSITORY}

# echo "Pulling mssql docker image from docker hub..."
# docker stop mysql-nine-db || true && docker rm mysql-nine-db || true
# docker pull ${MSSQL_REPOSITORY}
# docker run --name=mysql-nine-db \
#     -e MYSQL_ROOT_PASSWORD=999Foobar \
#     -e MYSQL_ROOT_HOST=% \
#     -d -p 3306:3306 ${MSSQL_REPOSITORY}

echo "Pulling ${DOCKER_REPOSITORY} docker image from docker hub..."
check_docker_repo --interval=10 --timeout=1200

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