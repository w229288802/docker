#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
APP_NAME=mock-db
HADOOP_HOME_VOLUME=hadoop-opt
FILE_PATH=$(cd $(dirname $0); pwd)

if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/mock-db ]]; then
mkdir ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/mock-db
fi

println_and_run "\\cp -rf ${FILE_PATH}/build-support/* ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/mock-db"

println_and_run "docker build --rm -t ${APP_NAME} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker rm -f ${APP_NAME} && docker run --name=${APP_NAME} -v hadoop-opt:/opt ${APP_NAME}"