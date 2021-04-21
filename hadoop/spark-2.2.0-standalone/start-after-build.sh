#!/bin/bash
BLACK_COLOR='\033[0;30m'
NO_COLOR='\033[0m'

#配置变量
JAVA_HOME=/usr
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_VERSION=hadoop2.7
SPARK_HOME_VOLUME=hadoop_opt
SPARK_VERSION=2.2.0
SPARK_DIR=spark-${SPARK_VERSION}
SPARK_MASTER_HOST=spark-master
SPARK_MASTER_PORT=7077
FILE_DIR=$(cd $(dirname $0); pwd)

${FILE_DIR}/stop-after-build.sh

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}


# 下载spark包
if [[ ! -f ${FILE_DIR}/${SPARK_DIR}-bin-${HADOOP_VERSION}.tgz ]];then
println_and_run "wget https://archive.apache.org/dist/spark/${SPARK_DIR}/${SPARK_DIR}-bin-${HADOOP_VERSION}.tgz -P ${FILE_DIR}/"
fi

# 解压spark包
if [[ ! -d ${FILE_DIR}/${SPARK_DIR} ]];then
println_and_run "tar -xvf ${SPARK_DIR}-bin-${HADOOP_VERSION}.tgz -C ${FILE_DIR}/${SPARK_DIR}/"
println_and_run "mv ${SPARK_DIR}-bin-${HADOOP_VERSION} ${SPARK_DIR}"
fi

#配置master地址
cp ${SPARK_DIR}/conf/spark-env.sh.template ${SPARK_DIR}/conf/spark-env.sh
export JAVA_HOME
export SPARK_MASTER_HOST
export SPARK_MASTER_PORT
#配置slave地址
cp ${SPARK_DIR}/conf/slaves.template ${SPARK_DIR}/conf/slaves
echo "slave1" >>  ${SPARK_DIR}/conf/slaves


# 复制spark包
if [[ ! -d ${DOCKER_VOLUME_DIR}/${HADOOP_HOME_VOLUME} ]]; then
println_and_run "cp -r ${FILE_DIR}/${SPARK_DIR} ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME}/_data/"
fi

# 复制配置到主数据卷
#println_and_run "\\cp -rf ${FILE_DIR}/build-support/conf/ ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME}/_data/${SPARK_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t spark:v${SPARK_VERSION} ${FILE_DIR}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -p spark up --remove-orphans"