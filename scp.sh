#!/usr/bin/env bash
. /opt/deploy-service/config.sh
serviceName=$1
BUILD_NUMBER=$2
src_dir=${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar
dest_dir=${images_path}${serviceName}
echo "scp docker image to remote target server..."
/opt/deploy-service/expect_scp.sh $uat_host $uat_port $uat_user $uat_pwd $src_dir $dest_dir