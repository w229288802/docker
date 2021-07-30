#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)
APP_NAME=hive
HIVE_HOME_VOLUME=hadoop-opt
HIVE_VERSION=2.1.1
HIVE_DIR=apache-${APP_NAME}-${HIVE_VERSION}-bin
HIVE_PATH=${FILE_PATH}/${HIVE_DIR}
HIVE_HOME=/opt/${HIVE_DIR}
HADOOP_HOME=/opt/hadoop-2.7.5
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export APP_NAME

${FILE_PATH}/stop-after-build.sh

#下载压缩包
if [[ ! -f ${FILE_PATH}/${HIVE_DIR}.tar.gz ]];then
yum install -y wget
println_and_run "wget http://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/${HIVE_DIR}.tar.gz -P ${FILE_PATH}/"
fi

# 解压压缩包
if [[ ! -d ${FILE_PATH}/${HIVE_DIR} ]];then
println_and_run "tar -xvf ${HIVE_PATH}.tar.gz -C ${FILE_PATH}/"
fi

\cp -f ${HIVE_PATH}/conf/hive-env.sh.template ${FILE_PATH}/build-support/conf/hive-env.sh
echo "export HADOOP_HOME=${HADOOP_HOME}" >> ${FILE_PATH}/build-support/conf/hive-env.sh
echo "export HIVE_CONF_DIR=${HIVE_HOME}/conf" >> ${FILE_PATH}/build-support/conf/hive-env.sh


# 查找hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HIVE_HOME_VOLUME} ]]; then
echo "please start hadoop at first"
exist 0
fi

# 复制spark包
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HIVE_HOME_VOLUME}/_data/${HIVE_DIR} ]]; then
println_and_run "cp -r ${HIVE_PATH} ${DOCKER_VOLUME_DIR}/${HIVE_HOME_VOLUME}/_data/"
fi

# 复制配置到主数据卷
println_and_run "\\cp -rf ${FILE_PATH}/build-support/conf/ ${DOCKER_VOLUME_DIR}/${HIVE_HOME_VOLUME}/_data/${HIVE_DIR}/"
println_and_run "\\cp -rf ${FILE_PATH}/build-support/lib/ ${DOCKER_VOLUME_DIR}/${HIVE_HOME_VOLUME}/_data/${HIVE_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t ${APP_NAME}:v${HIVE_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker rm -f ${APP_NAME} && docker run -d --rm --name=${APP_NAME} --hostname=${APP_NAME}-master -e PATH=${PATH}:${HIVE_HOME}/bin --network hadoop -v ${HIVE_HOME_VOLUME}:/opt ${APP_NAME}:v${HIVE_VERSION}"
#println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans"