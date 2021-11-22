    #!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
APP_NAME=kafka
APP_VERSION=2.11-2.4.1
APP_DIR=${APP_NAME}_${APP_VERSION}
APP_HOME_VOLUME=hadoop-opt
APP_DOWNLOAD_LINK=https://archive.apache.org/dist/kafka/2.4.1/kafka_2.11-2.4.1.tgz
ZOOKEEPER_SERVER_LIST=zookeeper1:2181,zookeeper2:2181
FILE_PATH=$(cd $(dirname $0); pwd)

${FILE_PATH}/stop-after-build.sh

if [[ ! -f ${FILE_PATH}/${APP_DIR}.tar.gz ]];then
yum install -y wget
println_and_run "wget ${APP_DOWNLOAD_LINK} -P ${FILE_PATH}/ -O ${APP_DIR}.tar.gz"
fi

# 解压hadoop包
if [[ ! -d ${FILE_PATH}/${APP_DIR} ]];then
println_and_run "tar -xvf ${FILE_PATH}/${APP_DIR}.tar.gz -C ${FILE_PATH}/"
println_and_run "mv *${APP_DIR}*/ ${APP_DIR}"
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
if [[ ! -d ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR} ]]; then
println_and_run "cp -r ${APP_DIR} ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/"
fi


sed -i "s/localhost:2181/${ZOOKEEPER_SERVER_LIST}/g"  ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/config/server.properties
#echo "delete.topic.enable=true" >> ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/config/server.properties
#println_and_run "cp ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo_sample.cfg ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo.cfg"
#grep "hostname" docker-compose.yml | sed -r 's/.*:\s+([a-zA-Z]*)([0-9]*)/server.\2=\1\2:2888:3888/g' >> ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/conf/zoo.cfg


# 复制配置到主数据卷
#println_and_run "\\cp -rf ${FILE_PATH}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${APP_HOME_VOLUME}/_data/${APP_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t ${APP_NAME}:v${APP_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans"