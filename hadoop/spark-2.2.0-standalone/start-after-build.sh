#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

#配置变量
FILE_PATH=$(cd $(dirname $0); pwd)
JAVA_HOME=/usr
DOCKER_VOLUME_DIR=/var/lib/docker/volumes
HADOOP_VERSION=hadoop2.7
SPARK_HOME_VOLUME=hadoop-opt
SPARK_VERSION=2.2.0
SPARK_DIR=spark-${SPARK_VERSION}
SPARK_PATH=${FILE_PATH}/${SPARK_DIR}
SPARK_MASTER_HOST=spark-master
HADOOP_MASTER_HOST=hadoop-master
HADOOP_DFS_PORT=9000
SPARK_MASTER_PORT=7077


${FILE_PATH}/stop-after-build.sh

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}


# 下载spark包
if [[ ! -f ${SPARK_PATH}-bin-${HADOOP_VERSION}.tgz ]];then
yum install -y wget
println_and_run "wget https://archive.apache.org/dist/spark/${SPARK_DIR}/${SPARK_DIR}-bin-${HADOOP_VERSION}.tgz -P ${FILE_PATH}/"
fi

# 解压spark包
if [[ ! -d ${SPARK_PATH} ]];then
println_and_run "tar -xvf ${SPARK_DIR}-bin-${HADOOP_VERSION}.tgz"
println_and_run "mv ${SPARK_DIR}-bin-${HADOOP_VERSION} ${SPARK_DIR}"
fi

mkdir -p ${env}/build-support/conf
#配置spark-env.sh
\cp -f ${SPARK_PATH}/conf/spark-env.sh.template ${FILE_PATH}/build-support/conf/spark-env.sh
echo "export JAVA_HOME" >> ${FILE_PATH}/build-support/conf/spark-env.sh
echo "export SPARK_MASTER_HOST" >> ${FILE_PATH}/build-support/conf/spark-env.sh
echo "export SPARK_MASTER_PORT" >> ${FILE_PATH}/build-support/conf/spark-env.sh
#配置slave地址
\cp -f ${SPARK_PATH}/conf/slaves.template ${FILE_PATH}/build-support/conf/slaves
echo "spark-slave1" >  ${FILE_PATH}/build-support/conf/slaves
#配置spark-defaults.conf
\cp -f ${SPARK_PATH}/conf/spark-defaults.conf.template ${FILE_PATH}/build-support/spark-defaults.conf
echo "spark.eventLog.enabled  true" >> ${FILE_PATH}/build-support/conf/spark-defaults.conf
echo "spark.eventLog.dir      hdfs://${HADOOP_MASTER_HOST}:${HADOOP_DFS_PORT}/spark_log" >> ${FILE_PATH}/build-support/conf/spark-defaults.conf
echo "spark.eventLog.compress true" >> ${FILE_PATH}/build-support/conf/spark-defaults.conf
#将以下内容复制到`spark-env.sh`的末尾, 配置 HistoryServer 启动参数, 使得 HistoryServer 在启动的时候读取 HDFS 中写入的 Spark 日志
echo "export SPARK_HISTORY_OPTS='-Dspark.history.ui.port=4000 -Dspark.history.retainedApplications=3\
 -Dspark.history.fs.logDirectory=hdfs://${HADOOP_MASTER_HOST}:${HADOOP_DFS_PORT}/spark_log'">> ${FILE_PATH}/build-support/conf/spark-env.sh


# 创建spark主数据卷
if [[ ! -d ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME} ]]; then
println_and_run "docker volume create ${SPARK_HOME_VOLUME} >/dev/null"
fi

# 复制spark包
if [[ ! -d ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME}/_data/${SPARK_DIR} ]]; then
println_and_run "cp -r ${SPARK_PATH} ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME}/_data/"
fi

# 复制配置到主数据卷
println_and_run "\\cp -rf ${FILE_PATH}/build-support/conf/ ${DOCKER_VOLUME_DIR}/${SPARK_HOME_VOLUME}/_data/${SPARK_DIR}/"

# 构建hadoop镜像
println_and_run "docker build --rm -t spark:v${SPARK_VERSION} ${FILE_PATH}/build-support"

# 启动hadoop镜像，orphans：孤儿
println_and_run "docker-compose -f ${FILE_PATH}/docker-compose.yml -p spark up --remove-orphans"