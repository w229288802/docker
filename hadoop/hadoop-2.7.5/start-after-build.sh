#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_HOME_VOLUME=hadoop_opt
HADOOP_VERSION=2.7.5
HADOOP_DIR=hadoop-${HADOOP_VERSION}
FILE_DIR=$(cd $(dirname $0); pwd)

# 下载hadoop包
if [[ ! -f ${FILE_DIR}/${HADOOP_DIR}.tar.gz ]];then
echo -e "${S}wget http://archive.apache.org/dist/hadoop/core/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz -P ${FILE_DIR}/${E}"
wget http://archive.apache.org/dist/hadoop/core/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz -P ${FILE_DIR}/
fi

# 解压hadoop包
if [[ ! -d ${FILE_DIR}/${HADOOP_DIR} ]];then
echo -e "tar -xvf ${HADOOP_DIR}.tar.gz -C ${FILE_DIR}/${E}"
tar -xvf ${HADOOP_DIR}.tar.gz -C ${FILE_DIR}/
fi

# 创建hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME} ]]; then
echo -e "${S}docker volume create ${HADOOP_HOME_VOLUME}${E}"
docker volume create ${HADOOP_HOME_VOLUME}
echo -e "cp -r ${FILE_DIR}/${HADOOP_DIR} ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${E}"
cp -R ${FILE_DIR}/${HADOOP_DIR} ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/
fi

# 复制配置到主数据卷
echo -e "${S}\\\cp -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/${E}"
\cp -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/

# 构建hadoop镜像
echo -e "${S}docker build --rm -t hadoop:v${HADOOP_VERSION} ${FILE_DIR}/build-support${E}"
docker build --rm -t hadoop:v${HADOOP_VERSION} ${FILE_DIR}/build-support

# 启动hadoop镜像，orphans：孤儿
echo -e "${S}docker-compose -p hadoop up --remove-orphans${E}"
docker-compose -p hadoop up --remove-orphans