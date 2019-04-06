#!/bin/sh

###############################################################################################################################
# NOTE: Copy this file in /var/9ci/deploy/ninedb/ directory on your server.
# Add DEPLOYMENT_SCRIPT_FILE_PATH into your CircleCI environemnt variables. The value is /var/9ci/deploy/dock9ocr/deploy_app.sh
###############################################################################################################################

# Arguments
# --docker-user: $DOCKERHUB_USER.
# --docker-password: $DOCKERHUB_PASSWORD
# --docker-repo: $DOCKER_REPOSITORY:$DOCKER_REPOSITORY_TAG. default dock9/nine-db:latest
# --mysql-host=$MYSQL_SERVER_ADDRESS
# --mssql-host=$MSSQL_SERVER_ADDRESS
# --rancher-api-access-key: $RANCHER_API_ACCESS_KEY
# --rancher-api-secret-key: $RANCHER_API_SECRET_KEY
# --rancher-workload-redeployment-api: $RANCHER_WORKLOAD_REDEPLOYMENT_API
# --rancher-workload-redeployment-api-data: $RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA

# Example Command
# ./deploy_app.sh \
#  --docker-user=test \
#  --docker-password='123qwe!@#QWE' \
#  --docker-repo=dock9/ocr:latest \
#  --mysql-host=127.0.0.1 \
#  --mssql-host=127.0.0.1 \
#  --rancher-api-access-key=token-8pv6f \
#  --rancher-api-secret-key=462fwxgwhw94lsnspqmktdvnsbjr786nhfdwst5h8tlzlsp7tvkf97 \
#  --rancher-workload-redeployment-api='https://192.155.90.60:8443/v3/project/c-wmqt5:p-6qb8v/workloads/deployment:ocr:dock9ocr' \
#  --rancher-workload-redeployment-api-data='{"annotations":{"cattle.io/timestamp":"replace_with_current_time"},"baseType":"workload","containers":[{"allowPrivilegeEscalation":false,"image":"dock9/ocr","imagePullPolicy":"IfNotPresent","initContainer":false,"name":"dock9ocr","ports":[{"containerPort":5000,"dnsName":"dock9ocr","kind":"ClusterIP","name":"5000tcp50002","protocol":"TCP","sourcePort":5000,"type":"/v3/project/schemas/containerPort"}],"privileged":false,"readOnly":false,"resources":{"type":"/v3/project/schemas/resourceRequirements"},"restartCount":0,"runAsNonRoot":false,"stdin":true,"stdinOnce":false,"terminationMessagePath":"/dev/termination-log","terminationMessagePolicy":"File","tty":true,"type":"container"}],"created":"2019-02-28T08:13:27Z","createdTS":1551341607000,"creatorId":null,"deploymentConfig":{"maxSurge":0,"maxUnavailable":2,"minReadySeconds":20,"progressDeadlineSeconds":600,"revisionHistoryLimit":10,"strategy":"RollingUpdate"},"deploymentStatus":{"availableReplicas":4,"conditions":[{"lastTransitionTime":"2019-03-20T19:49:51Z","lastTransitionTimeTS":1553111391000,"lastUpdateTime":"2019-03-20T19:49:51Z","lastUpdateTimeTS":1553111391000,"message":"Deployment has minimum availability.","reason":"MinimumReplicasAvailable","status":"True","type":"Available"},{"lastTransitionTime":"2019-03-20T18:22:02Z","lastTransitionTimeTS":1553106122000,"lastUpdateTime":"2019-04-01T12:23:49Z","lastUpdateTimeTS":1554121429000,"message":"ReplicaSet \"dock9ocr-68f8b68d9c\" has successfully progressed.","reason":"NewReplicaSetAvailable","status":"True","type":"Progressing"}],"observedGeneration":71,"readyReplicas":4,"replicas":4,"type":"/v3/project/schemas/deploymentStatus","unavailableReplicas":0,"updatedReplicas":4},"dnsPolicy":"ClusterFirst","hostIPC":false,"hostNetwork":false,"hostPID":false,"id":"deployment:ocr:dock9ocr","labels":{"workload.user.cattle.io/workloadselector":"deployment-ocr-dock9ocr"},"name":"dock9ocr","namespaceId":"ocr","paused":false,"projectId":"c-wmqt5:p-6qb8v","publicEndpoints":[{"addresses":["192.155.90.60"],"allNodes":true,"hostname":"ln02.9ci.com","ingressId":"ocr:dock9ocr-loadbalancer","nodeId":null,"path":"/","podId":null,"port":80,"protocol":"HTTP","serviceId":"ocr:ingress-5e69fa4991fefc8c9f475b9daf76b038","type":"publicEndpoint"}],"restartPolicy":"Always","scale":4,"schedulerName":"default-scheduler","selector":{"matchLabels":{"workload.user.cattle.io/workloadselector":"deployment-ocr-dock9ocr"},"type":"/v3/project/schemas/labelSelector"},"state":"active","terminationGracePeriodSeconds":30,"transitioning":"no","transitioningMessage":"","type":"deployment","uuid":"ba049cae-3b30-11e9-872b-6a920e85bd35","workloadAnnotations":{"deployment.kubernetes.io/revision":"34","field.cattle.io/creatorId":"user-v2pfp"},"workloadLabels":{"cattle.io/creator":"norman","workload.user.cattle.io/workloadselector":"deployment-ocr-dock9ocr"}}'
DOCKERHUB_USER=""
DOCKERHUB_PASSWORD=""
DOCKER_REPOSITORY=""
MYSQL_SERVER_ADDRESS="127.0.0.1"
MSSQL_SERVER_ADDRESS="127.0.0.1"
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
                -e MYSQL_SERVER_ADDRESS=${MYSQL_SERVER_ADDRESS} \
                -e MSSQL_SERVER_ADDRESS=${MSSQL_SERVER_ADDRESS} \
                -e DOCKERHUB_USER=${DOCKERHUB_USER} \
                -e DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD} \
                -p 3306:3306 -p 1433:1433 \
                ${DOCKER_REPOSITORY} 

            # # To redeploy workload, call Rancher API.
            # CURRENT_TIME=$(date +"%Y-%m-%dT%H:%M:%SZ")
            # ORIGIN_API_DATA=$RANCHER_WORKLOAD_REDEPLOYMENT_API_DATA
            # ORIGIN_TEXT="replace_with_current_time"
            # REPLACE_TEXT="${CURRENT_TIME}"
            # RANCHER_API_DATA=${ORIGIN_API_DATA//$ORIGIN_TEXT/$REPLACE_TEXT}

            # curl -u "${RANCHER_API_ACCESS_KEY}:${RANCHER_API_SECRET_KEY}" \
            # -k \
            # -X PUT \
            # -H 'Accept: application/json' \
            # -H 'Content-Type: application/json' \
            # -d "${RANCHER_API_DATA}" \
            # ${RANCHER_WORKLOAD_REDEPLOYMENT_API}

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
    --mysql-host=*)
    MYSQL_SERVER_ADDRESS="${i#*=}"
    shift
    ;;
    --mssql-repomssql-repo=*)
    MSSQL_REPOSITORY="${i#*=}"
    shift
    ;;
    --mssql-host=*)
    MSSQL_SERVER_ADDRESS="${i#*=}"
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

# docker volume prune << EOF
# y
# EOF

# docker rmi $(docker images -f "dangling=true" -q)

echo "done"