#!/usr/bin/env bash
. config.sh
op=$1
serviceName=$2
BUILD_NUMBER=$3

if [ "save" = "${op}" ];then
    echo "save docker image to ${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar"
    mkdir -p ${images_path}${serviceName}/
    docker save -o ${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar ${serviceName}:${BUILD_NUMBER}
fi

if [ "load" = "${op}" ];then
    echo "start load docker image to ${serviceName}_${BUILD_NUMBER}.tar"
    docker load -i ${images_path}${serviceName}/${serviceName}_${BUILD_NUMBER}.tar
fi

