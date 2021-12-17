#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
APP_NAME=hive
HIVE_DATA=/data/hadoop
HIVE_VERSION=3.1.2
HIVE_DIR=${APP_NAME}-${HIVE_VERSION}
HIVE_HOME=/opt/${HIVE_DIR}
HIVE_MASTER_HOSTNAME=hive-master
HIVE_SLAVE1_HOSTNAME=hive-slave1
HADOOP_HOME=/opt/hadoop-3.1.3
export PATH=$PATH:${HIVE_HOME}/bin

#导出变量
echo "export HIVE_HOME=${HIVE_HOME}">> ~/.bashrc
echo "export PATH=${PATH}">> ~/.bashrc

rm ${HIVE_HOME}/lib/guava-*.jar

cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-*.jar ${HIVE_HOME}/lib/

#开启MetaStore
println_and_run "hive --service metastore &"
#开启远程服务Thrift
println_and_run "hive --service hiveserver2 "
