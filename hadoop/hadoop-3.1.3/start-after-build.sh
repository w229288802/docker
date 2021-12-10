#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_HOME_VOLUME=hadoop-opt
HADOOP_VERSION=3.1.3
HADOOP_DIR=hadoop-${HADOOP_VERSION}
FILE_PATH=$(cd $(dirname $0); pwd)

${FILE_PATH}/stop-after-build.sh

# 下载hadoop包
if [[ ! -f ${FILE_PATH}/${HADOOP_DIR}.tar.gz ]];then
yum install -y wget
println_and_run "wget http://archive.apache.org/dist/hadoop/core/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz -P ${FILE_PATH}/"
fi

# 解压hadoop包
if [[ ! -d ${FILE_PATH}/${HADOOP_DIR} ]];then
println_and_run "tar -xvf ${FILE_PATH}/${HADOOP_DIR}.tar.gz -C ${FILE_PATH}/"
fi

# 创建hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME} ]]; then
println_and_run "docker volume create ${HADOOP_HOME_VOLUME} >/dev/null"
fi

if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR} ]];then
println_and_run "cp -r ${FILE_PATH}/${HADOOP_DIR} ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/"
fi

# 创建网络 docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
exist_hadoop_net=`docker network ls |grep -E "\s+hadoop\s+" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/16
fi

# 复制配置到主数据卷
println_and_run "\\cp -rf ${FILE_PATH}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/"
println_and_run "\\cp -rf ${FILE_PATH}/build-support/share/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t hadoop:v${HADOOP_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p hadoop up --remove-orphans"