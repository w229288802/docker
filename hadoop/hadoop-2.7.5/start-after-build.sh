#!/bin/bash

DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_DIR=$(cd $(dirname $0); pwd)

if [[ ! -f ${FILE_DIR}/hadoop-2.7.5.tar.gz ]];then
echo "download hadoop to ${FILE_DIR}..."
wget http://archive.apache.org/dist/hadoop/core/hadoop-2.7.5/hadoop-2.7.5.tar.gz -P ${FILE_DIR}/
fi

if [[ ! -d ${FILE_DIR}/hadoop-2.7.5 ]];then
tar -xvf hadoop-2.7.5.tar.gz -C ${FILE_DIR}/
fi


if [[ ! -d ${DOCKER_VOLUME_DIR}/hadoop-bin ]]; then
docker volume create hadoop-bin
cp ./hadoop-2.7.5 /var/lib/docker/volumes/hadoop-bin/_data/
fi

docker build --rm -t hadoop:v2.7.5 ${FILE_DIR}/build-support
echo "===>>> starting <<<==="
docker-compose up
#docker run --rm --name hadoop -it -v $(cd $(dirname $0); pwd)/hadoop-2.7.5:/opt/hadoop hadoop:v2.7.5 bash