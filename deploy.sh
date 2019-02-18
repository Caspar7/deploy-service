#!/usr/bin/env bash
BUILD_NUMBER=$1
env=$2
serviceName="employee-service"
images_path="/home/docker/images/"
src_dir=${images_path}${serviceName}_${BUILD_NUMBER}.tar
dest_dir=${images_path}

host=35.220.222.101
port=22
username=root
password=root

#get rand port
randPort(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

echo "stop and delete exist docker images and container..."
running=`docker ps | grep ${serviceName} | awk '{print $1}'`
if [ ! -z "$running" ]; then
    docker stop $running
fi

container=`docker ps -a | grep ${serviceName} | awk '{print $1}'`
if [ ! -z "$container" ]; then
    docker rm $container -f
fi

imagesid=`docker images|grep -i ${serviceName}|awk '{print $3}'`
if [ ! -z "$imagesid" ]; then
    docker rmi $imagesid -f
fi


echo "deploy docker container..."
deployPort=$(randPort 10000 60000)

loadcmd="docker load -i ${images_path}${serviceName}_${BUILD_NUMBER}.tar"
runcmd="docker run --env env=${env} --env deployIp=${deployIp} --env deployPort=${deployPort} -it -d -p ${deployPort}:${deployPort} --name ${serviceName} ${serviceName}:${BUILD_NUMBER}"
if [ "local" = "${env}" ];then
    env="uat"
    ${loadcmd}
    ${runcmd}
    exit 0
fi


if [ "uat" = "${env}" ];then
    echo "scp docker image to target server"
    # scp docker file to remote server
    ./expect_scp.sh $host $port $username $password $src_dir $dest_dir
    echo "run docker to target env server"
    #yum install sshpass if not install sshpass at build server
    sshpass -p $password ssh $username@${host} ${loadcmd}
    sshpass -p $password ssh $username@${host} ${runcmd}
    exit 0
fi

