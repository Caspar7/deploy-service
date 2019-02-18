#!/usr/bin/env bash
. /opt/deploy-service/config.sh
serviceName=$1
BUILD_NUMBER=$2
env=$3
#get rand port
randPort(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

echo "deploy docker container..."
deployPort=$(randPort 10000 60000)

clearCmd="/opt/deploy-service/clear-service.sh ${serviceName}
loadCmd="/opt/deploy-service/docker-image.sh load ${serviceName} ${BUILD_NUMBER}"
runCmd="docker run --env env=${env} --env deployIp=${deployIp} --env deployPort=${deployPort} -it -d -p ${deployPort}:${deployPort} --name ${serviceName} ${serviceName}:${BUILD_NUMBER}"
if [ "local" = "${env}" ];then
    env="uat"
    ${clearCmd}
    ${loadCmd}
    ${runCmd}
    exit 0
fi

src_dir=${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar
dest_dir=${images_path}
if [ "uat" = "${env}" ];then
    echo "scp docker image to target server"
    # scp docker file to remote server
    /opt/deploy-service/expect_scp.sh $host $uat_port $uat_user $uat_pwd $src_dir $dest_dir
    echo "run docker to target env server"
    #yum install sshpass if not install sshpass at build server
    sshpass -p $uat_pwd ssh $uat_user@${host} ${clearCmd}
    sshpass -p $uat_pwd ssh $uat_user@${host} ${loadcmd}
    sshpass -p $uat_pwd ssh $uat_user@${host} ${runcmd}
    exit 0
fi

