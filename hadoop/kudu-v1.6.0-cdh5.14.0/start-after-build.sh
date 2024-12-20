#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)
kudu_VERSION=1.6.0
export APP_NAME=kudu

${FILE_PATH}/stop-after-build.sh

#ln -s /etc/hadoop/conf/core-site.xml /etc/kudu/conf/core-site.xml
#ln -s /etc/hadoop/conf/hdfs-site.xml /etc/kudu/conf/hdfs-site.xml
#ln -s /etc/hive/conf/hive-site.xml /etc/kudu/conf/hive-site.xml

# 构建hadoop镜像
println_and_run "docker build --rm -t ${APP_NAME}:v${kudu_VERSION}  --network=hadoop ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans"