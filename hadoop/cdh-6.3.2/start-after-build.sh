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
CM_VERSION=6.3.1
export APP_NAME=cdh6
#export HOST_IP=$(ip address |grep inet |grep eth0 |tr -s ' '|cut -d ' ' -f3|cut -d / -f1)

${FILE_PATH}/stop-after-build.sh

# 解压hadoop包
if [[ ! -d ${CDH_PATH}/cm6.3.1 ]];then
println_and_run "tar -xvf ${CDH_PATH}/cm6.3.1.tar.gz"
fi

exist_hadoop_net=`docker ps |grep -E "\s+cdh6-mysql\s?" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
println_and_run "docker run --rm -d --network=hadoop --name=cdh6-mysql --hostname=mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7"
echo "please wait mysql on running"
exit 0
fi

println_and_run "docker rm -f yum-${APP_NAME} >/dev/null && docker run -d --name=yum-${APP_NAME} --hostname=yum-${APP_NAME} --network=hadoop -v ${CDH_PATH}:/usr/share/nginx/html/cdh${CDH_VERSION} -v ${CDH_PATH}/cm${CM_VERSION}:/usr/share/nginx/html/cm${CM_VERSION} nginx"

println_and_run "docker build --network=hadoop -t ${APP_NAME}:v${CDH_VERSION} ${FILE_PATH}/build-support"

println_and_run "docker rm -f ${APP_NAME} 2>/dev/null && docker run --rm -d --name=${APP_NAME} --hostname=${APP_NAME} -p 7180:7180 --network=hadoop --privileged=true ${APP_NAME}:v${CDH_VERSION} /sbin/init"

println_and_run "docker exec -it ${APP_NAME} /docker-entrypoint.sh"

# 启动hadoop镜像，orphans：孤儿
#println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans --build"