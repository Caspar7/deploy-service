#!/usr/bin/env bash
./config.sh
serviceName=$1
version=$2
dockerfile=$3
./clear-service.sh ${serviceName}
echo "start build docker image..."
docker build -t ${serviceName}:${version} .

#echo "delete old image file"
#rm ${images_path}${serviceName}_*

echo "save images to" ${images_path}
docker save -o ${images_path}${serviceName}_${version}.tar ${serviceName}:${version}
#docker load -i ${serviceName}_${BUILD_NUMBER}.tar
