#!/usr/bin/env bash
. /opt/deploy-service/config.sh
serviceName=$1
BUILD_NUMBER=$2
env=$3

src_dir=${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar
dest_dir=${images_path}${serviceName}

echo "deploy docker image to remote server..."
if [ "uat" = "${env}" ];then
    sshpass -p $uat_pwd ssh $uat_user@${uat_host} "/opt/deploy-service/deploy.sh ${serviceName} ${BUILD_NUMBER} ${env} ${uat_host}"
fi

if [ "prod" = "${env}" ];then
    sshpass -p $prod_pwd ssh $prod_user@${prod_host} "/opt/deploy-service/deploy.sh ${serviceName} ${BUILD_NUMBER} ${env} ${prod_host}"
fi
 