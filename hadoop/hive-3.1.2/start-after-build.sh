#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)
APP_NAME=hive
APP_VERSION=3.1.2
APP_DIR=${APP_NAME}-${APP_VERSION}
APP_HOME_VOLUME=hadoop-opt
APP_DOWNLOAD_LINK=https://archive.apache.org/dist/flume/${APP_VERSION}/apache-${APP_NAME}-${APP_VERSION}-bin.tar.gz
HADOOP_HOME=/opt/hadoop-3.1.3
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export APP_NAME

${FILE_PATH}/stop-after-build.sh

#下载压缩包
if [[ ! -f ${FILE_PATH}/${APP_DIR}.tar.gz ]];then
yum install -y wget
println_and_run "wget ${APP_DOWNLOAD_LINK} -P ${FILE_PATH}/ -O ${FILE_PATH}/${APP_DIR}.tar.gz"
fi

# 解压压缩包
if [[ ! -d ${FILE_PATH}/${APP_DIR} ]];then
println_and_run "tar -xvf ${FILE_PATH}/${APP_DIR}.tar.gz -C ${FILE_PATH}/"
println_and_run "mv ${FILE_PATH}/*${APP_DIR}*/ ${FILE_PATH}/${APP_DIR}"
fi

\cp -f ${FILE_PATH}/${APP_DIR}/conf/hive-env.sh.template ${FILE_PATH}/build-support/conf/hive-env.sh
echo "export HADOOP_HOME=${HADOOP_HOME}" >> ${FILE_PATH}/build-support/conf/hive-env.sh
echo "export HIVE_CONF_DIR=/opt/${APP_DIR}/conf" >> ${FILE_PATH}/build-support/conf/hive-env.sh


# 查找hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME} ]]; then
echo "please start hadoop at first"
exist 0
fi

# 复制spark包
if [[ ! -d ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR} ]]; then
println_and_run "cp -r ${FILE_PATH}/${APP_DIR} ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/"
fi

# 复制配置到主数据卷
println_and_run "\\cp -rf ${FILE_PATH}/build-support/conf/ ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/"
println_and_run "\\cp -rf ${FILE_PATH}/build-support/lib/ ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t ${APP_NAME}:v${APP_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker rm -f ${APP_NAME} && docker run -d --rm --name=${APP_NAME} --hostname=${APP_NAME}-master -e PATH=${PATH}:/opt/${APP_DIR}/bin --network hadoop -v ${APP_HOME_VOLUME}:/opt ${APP_NAME}:v${APP_VERSION}"
#println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans"