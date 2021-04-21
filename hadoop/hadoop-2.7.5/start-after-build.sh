#!/bin/bash
BLACK_COLOR='\033[0;30m'
NO_COLOR='\033[0m'
printf_and_run() {
printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"
bash -c "$1"
}

#删除以住进程
for pid_path in $(cd $(dirname $0); pwd)/*.pid ; do
#获取pid文件名(最后一次出现/后的字符串)
pid_name=${pid_path##*/}
#获取pid (最后一次出现.pid前的字符串)
pid=${pid_name%%.pid}
ps -ef | grep -E "\s${pid}\s" | awk '{print $2}' | xargs kill -9 2&>/dev/null
done
echo > "$$.pid"

#配置变量
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_HOME_VOLUME=hadoop_opt
HADOOP_VERSION=2.7.5
HADOOP_DIR=hadoop-${HADOOP_VERSION}
FILE_DIR=$(cd $(dirname $0); pwd)

${FILE_DIR}/stop-after-build.sh

# 下载hadoop包
if [[ ! -f ${FILE_DIR}/${HADOOP_DIR}.tar.gz ]];then
printf_and_run "wget http://archive.apache.org/dist/hadoop/core/${HADOOP_DIR}/${HADOOP_DIR}.tar.gz -P ${FILE_DIR}/"
fi

# 解压hadoop包
if [[ ! -d ${FILE_DIR}/${HADOOP_DIR} ]];then
printf_and_run "tar -xvf ${HADOOP_DIR}.tar.gz -C ${FILE_DIR}/"
fi

# 创建hadoop主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME} ]]; then
printf_and_run "docker volume create ${HADOOP_HOME_VOLUME}"
printf_and_run "cp -r ${FILE_DIR}/${HADOOP_DIR} ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/"
fi

# 创建网络 docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
exist_hadoop_net=`docker network ls |grep -E "\s+hadoop\s+" |wc -l`
if [[ ${exist_hadoop_net} -eq 0 ]];then
docker network create hadoop --gateway=172.18.0.1 --subnet=172.18.0.0/1
fi

# 复制配置到主数据卷
printf_and_run "\\cp -rf ${FILE_DIR}/build-support/etc/ ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME}/_data/${HADOOP_DIR}/"

# 构建hadoop镜像
printf_and_run "docker build --rm -t hadoop:v${HADOOP_VERSION} ${FILE_DIR}/build-support"

# 启动hadoop镜像，orphans：孤儿
printf_and_run "docker-compose -p hadoop up --remove-orphans"