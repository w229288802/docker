#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
HADOOP_HOME=/opt/hadoop-2.7.5
HADOOP_DATA=/data/hadoop
HADOOP_MASTER_HOSTNAME=hadoop-master
HADOOP_SLAVE1_HOSTNAME=hadoop-slave1
PATH=$PATH:${HADOOP_HOME}/bin
APP_NAME=impala

#导出变量

if [[ "${HOSTNAME}" == "${APP_NAME}-master" ]]; then
service impala-server start
service impala-state-store start
service impala-catalog start
else
sed -i "s/127.0.0.1/impala-master/"  /etc/default/impala
service impala-server start
fi



tail -f /dev/null