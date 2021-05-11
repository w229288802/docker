#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)

MAP_SOURCE_PORT=3306
MAP_SOURCE_HOST=mysql
MAP_TARGET_PORT=3306
MAP_NETWORK=hadoop
APP_NAME=cdh6-mysql-map

${FILE_PATH}/stop-after-build.sh

#ln -s /etc/hadoop/conf/core-site.xml /etc/impala/conf/core-site.xml
#ln -s /etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/hdfs-site.xml
#ln -s /etc/hive/conf/hive-site.xml /etc/impala/conf/hive-site.xml


println_and_run "docker build  --build-arg MAP_TARGET_PORT=${MAP_TARGET_PORT} --build-arg MAP_SOURCE_HOST=${MAP_SOURCE_HOST} --build-arg MAP_SOURCE_PORT=${MAP_SOURCE_PORT} --rm  -t ${APP_NAME}  --network=${MAP_NETWORK} ${FILE_PATH}/build-support"
println_and_run "docker rm -f ${APP_NAME} && docker run --network=hadoop -p ${MAP_TARGET_PORT}:${MAP_TARGET_PORT} -d --name=${APP_NAME} ${APP_NAME}"