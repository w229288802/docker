#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
FILE_PATH=$(cd $(dirname $0); pwd)
CDH_PATH=/root/cdh5.14.0/5.14.0
CDH_VERSION=5.14.0
export APP_NAME=cdh5
export HOST_IP=$(ip address |grep inet |grep eth0 |tr -s ' '|cut -d ' ' -f3|cut -d / -f1)

${FILE_PATH}/stop-after-build.sh

#ln -s /etc/hadoop/conf/core-site.xml /etc/impala/conf/core-site.xml
#ln -s /etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/hdfs-site.xml
#ln -s /etc/hive/conf/hive-site.xml /etc/impala/conf/hive-site.xml

println_and_run "docker rm -f yum-${APP_NAME} >/dev/null && docker run -d --name=yum-${APP_NAME} --hostname=yum-${APP_NAME} --network=hadoop -v ${CDH_PATH}:/usr/share/nginx/html nginx"