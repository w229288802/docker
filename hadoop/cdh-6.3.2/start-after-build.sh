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

# 创建网络 docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
exist_hadoop_net=`docker network ls |grep -E "\s+hadoop\s+" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/16
fi

exist_hadoop_net=`docker ps |grep -E "\s+cdh6-mysql\s?" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
println_and_run "docker run -d --rm --network=hadoop --name=cdh6-mysql -v cdh6-mysql:/var/lib/mysql --hostname=mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7"
echo "please wait mysql on running for restart script "
exit 0
fi

#hive metastore 和  oozie角色需要选择,oozie可能上传会超时
#create database if not exists hive default character set utf8 default collate utf8_general_ci;
#create database if not exists oozie default character set utf8 default collate utf8_general_ci;
#create database if not exists hue default character set utf8 default collate utf8_general_ci;

println_and_run "docker rm -f ${APP_NAME}-yum >/dev/null && docker run -d --name=${APP_NAME}-yum --hostname=${APP_NAME}-yum --network=hadoop -v ${CDH_PATH}:/usr/share/nginx/html/cdh${CDH_VERSION} -v ${CDH_PATH}/cm${CM_VERSION}:/usr/share/nginx/html/cm${CM_VERSION} nginx"

println_and_run "docker build --network=hadoop -t ${APP_NAME}:v${CDH_VERSION} ${FILE_PATH}/build-support"

println_and_run "docker rm -f ${APP_NAME} 2>/dev/null && docker run --rm -d --name=${APP_NAME} --hostname=${APP_NAME} -p 7180:7180 --network=hadoop --privileged=true ${APP_NAME}:v${CDH_VERSION} /sbin/init"

println_and_run "docker exec -it ${APP_NAME} /docker-entrypoint.sh"

# 启动hadoop镜像，orphans：孤儿
#println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} up --remove-orphans --build"