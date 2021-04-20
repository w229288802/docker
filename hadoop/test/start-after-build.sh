#!/bin/bash

DOCKER_VOLUME_DIR=/var/lib/docker/volumes
if [[ ! -d ${DOCKER_VOLUME_DIR}/hadoop-rsa ]]; then
echo "==========================>>> create volume to ${FILE_DIR} <<<=========================="
docker volume create hadoop-rsa
#cp -f /etc/ssh/* /var/lib/docker/volumes/hadoop-rsa/_data/
fi

echo "==========================>>> build image to ${FILE_DIR} <<<=========================="
docker build --rm -t hadoop:v2.7.5 ./build-support
echo "==========================>>> starting <<<=========================="
docker-compose up --remove-orphans
#docker run --rm --name hadoop -it -v ${FILE_DIR}:/opt/hadoop hadoop:v2.7.5 bash