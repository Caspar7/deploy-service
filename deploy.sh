#!/usr/bin/env bash
. /opt/deploy-service/config.sh
serviceName=$1
BUILD_NUMBER=$2
env=$3
deployIp=$4
#get rand port
randPort(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

echo "deploy docker container..."
deployPort=$(randPort 10000 60000)
/opt/deploy-service/clear-service.sh ${serviceName}
/opt/deploy-service/docker-image.sh load ${serviceName} ${BUILD_NUMBER}
docker run --env env=${env} --env deployIp=${deployIp} --env deployPort=${deployPort} -it -d -p ${deployPort}:${deployPort} --name ${serviceName} ${serviceName}:${BUILD_NUMBER}
