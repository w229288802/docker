#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_DIR=$(cd $(dirname $0); pwd)

if [[ ! -f ${FILE_DIR}/hadoop-2.7.5.tar.gz ]];then
echo -e "${S}downloading hadoop to ${FILE_DIR}${E}"
wget http://archive.apache.org/dist/hadoop/core/hadoop-2.7.5/hadoop-2.7.5.tar.gz -P ${FILE_DIR}/
fi

if [[ ! -d ${FILE_DIR}/hadoop-2.7.5 ]];then
echo -e "${S}expressing hadoop to ${FILE_DIR}${E}"
tar -xvf hadoop-2.7.5.tar.gz -C ${FILE_DIR}/
fi


if [[ ! -d ${DOCKER_VOLUME_DIR}/hadoop_opt ]]; then
echo -e "${S}creating volume to ${FILE_DIR}${E}"
docker volume create hadoop_opt
cp  -R ${FILE_DIR}/hadoop-2.7.5 ${DOCKER_VOLUME_DIR}/hadoop_opt/_data/
fi

echo -e "${S}\cp  -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/hadoop_opt/_data/hadoop-2.7.5/${E}"
cp  -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/hadoop_opt/_data/hadoop-2.7.5/



echo -e "${S}building image to ${FILE_DIR}${E}"
docker build --rm -t hadoop:v2.7.5 ${FILE_DIR}/build-support
echo -e "${S}starting hadoop docker-compose${E}"
docker-compose -p hadoop up --remove-orphans
#docker run --rm --name hadoop -it -v ${FILE_DIR}:/opt/hadoop hadoop:v2.7.5 bash