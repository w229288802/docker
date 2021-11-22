#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
APP_NAME=kafka-eagle
APP_VERSION=1.3.7
APP_DIR=${APP_NAME}-${APP_VERSION}
APP_HOME_VOLUME=hadoop-opt
APP_DOWNLOAD_LINK=https://codeload.github.com/smartloli/kafka-eagle-bin/tar.gz/v1.3.7
ZOOKEEPER_SERVER_LIST=zookeeper1:2181,zookeeper2:2181
FILE_PATH=$(cd $(dirname $0); pwd)

${FILE_PATH}/stop-after-build.sh

if [[ ! -f ${FILE_PATH}/${APP_NAME}.tar.gz ]];then
yum install -y wget
println_and_run "wget ${APP_DOWNLOAD_LINK} -P ${FILE_PATH}/ -O ${APP_NAME}.tar.gz"
fi

# 解压hadoop包
if [[ ! -d ${FILE_PATH}/${APP_NAME} ]];then
println_and_run "tar -xvf ${FILE_PATH}/${APP_NAME}.tar.gz -C ${FILE_PATH}/"
println_and_run "tar -xvf *${APP_NAME}*/*.tar.gz"
println_and_run "mv *${APP_NAME}-web*/ ${APP_NAME}"
println_and_run "cp build-support/conf/system-config.properties ${APP_NAME}/conf/"
fi



# 创建网络 docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
exist_hadoop_net=`docker network ls |grep -E "\s+hadoop\s+" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/16
fi


# 创建spark主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME} ]]; then
println_and_run "docker volume create ${APP_HOME_VOLUME} >/dev/null"
fi


# 复制spark包
if [[ ! -d ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_NAME} ]]; then
println_and_run "cp -r ${APP_NAME} ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/"
fi


#sed -i "s/localhost:2181/${ZOOKEEPER_SERVER_LIST}/g"  ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/config/server.properties
#echo "delete.topic.enable=true" >> ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/config/server.properties
#println_and_run "cp ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo_sample.cfg ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo.cfg"
#grep "hostname" docker-compose.yml | sed -r 's/.*:\s+([a-zA-Z]*)([0-9]*)/server.\2=\1\2:2888:3888/g' >> ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo.cfg


# 复制配置到主数据卷
#println_and_run "\\cp -rf ${FILE_PATH}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t ${APP_NAME}:v${APP_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker run --rm -d -e KE_HOME=/opt/${APP_NAME} --name=${APP_NAME} --hostname=${APP_NAME} -p 8048:8048 --network=hadoop -v ${APP_HOME_VOLUME}:/opt ${APP_NAME}:v${APP_VERSION}"