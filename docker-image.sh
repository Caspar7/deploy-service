#!/usr/bin/env bash
./config.sh
op=$1
serviceName=$2
BUILD_NUMBER=$3

if [ "save" = "${op}" ];then
    docker save -o ${images_path}${serviceName}_${BUILD_NUMBER}.tar ${serviceName}:${BUILD_NUMBER}
fi

if [ "load" = "${op}" ];then
    docker load -i ${serviceName}_${BUILD_NUMBER}.tar
fi

