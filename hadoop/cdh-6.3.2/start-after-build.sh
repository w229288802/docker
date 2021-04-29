#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)
CDH_PATH=/root/cdh6.3.2
CDH_VERSION=6.3.2
export APP_NAME=cdh6
export HOST_IP=$(ip address |grep inet |grep eth0 |tr -s ' '|cut -d ' ' -f3|cut -d / -f1)
${FILE_PATH}/stop-after-build.sh

# 解压hadoop包
if [[ ! -d ${CDH_PATH}/cm6.3.1 ]];then
println_and_run "tar -xvf ${CDH_PATH}/cm6.3.1.tar.gz"
fi


println_and_run "docker rm -f yum-cdh6 && docker run -d --name=yum-${APP_NAME} --hostname=yum-${APP_NAME} -p 3636:80 -v ${CDH_PATH}:/usr/share/nginx/html/cdh6.3.2 -v ${CDH_PATH}/cm6.3.1:/usr/share/nginx/html/cm6.3.1 nginx"

println_and_run "docker build --rm --build-arg HOST_IP=${HOST_IP}:3636 -t ${APP_NAME}:v${CDH_VERSION} ${FILE_PATH}/build-support"

println_and_run "docker rm -f cdh6 && docker run -d --name=${APP_NAME} --hostname=${APP_NAME} --network=hadoop --privileged=true centos:7 /sbin/init"

println_and_run "docker exec -it ${APP_NAME} /docker-entrypoint.sh"

# 启动hadoop镜像，orphans：孤儿
#println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans --build"