#!/bin/bash

DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_DIR=$(cd $(dirname $0); pwd)

if [[ ! -f ${FILE_DIR}/hadoop-2.7.5.tar.gz ]];then
echo "==========================>>> download hadoop to ${FILE_DIR} <<<=========================="
wget http://archive.apache.org/dist/hadoop/core/hadoop-2.7.5/hadoop-2.7.5.tar.gz -P ${FILE_DIR}/
fi

if [[ ! -d ${FILE_DIR}/hadoop-2.7.5 ]];then
echo "==========================>>> express hadoop to ${FILE_DIR} <<<=========================="
tar -xvf hadoop-2.7.5.tar.gz -C ${FILE_DIR}/
fi


if [[ ! -d ${DOCKER_VOLUME_DIR}/hadoop-opt ]]; then
echo "==========================>>> create volume to ${FILE_DIR} <<<=========================="
docker volume create hadoop-opt
fi

cp  -R ${FILE_DIR}/hadoop-2.7.5 ${DOCKER_VOLUME_DIR}/hadoop-opt/_data/
cp  -R ${FILE_DIR}/etc ${DOCKER_VOLUME_DIR}/hadoop-opt/_data/hadoop-2.7.5/

echo "==========================>>> build image to ${FILE_DIR} <<<=========================="
docker build --rm -t hadoop:v2.7.5 ${FILE_DIR}/build-support
echo "==========================>>> starting <<<=========================="
docker-compose up --remove-orphans
#docker run --rm --name hadoop -it -v ${FILE_DIR}:/opt/hadoop hadoop:v2.7.5 bash