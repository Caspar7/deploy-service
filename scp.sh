#!/usr/bin/env bash
. /opt/deploy-service/config.sh
serviceName=$1
BUILD_NUMBER=$2
env=$3

src_dir=${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar
dest_dir=${images_path}${serviceName}

echo "scp docker image to remote target server..."
if [ "uat" = "${env}" ];then
    sshpass -p $uat_pwd ssh $uat_user@${uat_host} "mkdir -p ${dest_dir}"
    /opt/deploy-service/expect_scp.sh $uat_host $uat_port $uat_user $uat_pwd $src_dir $dest_dir
fi

if [ "prod" = "${env}" ];then
    /opt/deploy-service/expect_scp.sh $prod_host $prod_port $prod_user $prod_pwd $src_dir $dest_dir
fi
 