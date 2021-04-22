#!/bin/bash
BLACK_COLOR='\033[0;30m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_HOME_VOLUME=hadoop-opt
HADOOP_VERSION=2.7.5
HADOOP_DIR=hadoop-${HADOOP_VERSION}
FILE_DIR=$(cd $(dirname $0); pwd)

${FILE_DIR}/stop-after-build.sh

# 下载hadoop包
if [[ ! -f ${FILE_DIR}/${HADOOP_DIR}.tar.gz ]];then
yum install -y wget
println_and_run "wget http://archive.apache.org/dist/hadoop/core/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz -P ${FILE_DIR}/"
fi

# 解压hadoop包
if [[ ! -d ${FILE_DIR}/${HADOOP_DIR} ]];then
println_and_run "tar -xvf ${HADOOP_DIR}.tar.gz -C ${FILE_DIR}/"
fi

# 创建hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME} ]]; then
println_and_run "docker volume create ${HADOOP_HOME_VOLUME} >/dev/null"
println_and_run "cp -r ${FILE_DIR}/${HADOOP_DIR} ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/"
fi

# 创建网络 docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
exist_hadoop_net=`docker network ls |grep -E "\s+hadoop\s+" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/16
fi

# 复制配置到主数据卷
println_and_run "\\cp -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t hadoop:v${HADOOP_VERSION} ${FILE_DIR}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -p hadoop up --remove-orphans"