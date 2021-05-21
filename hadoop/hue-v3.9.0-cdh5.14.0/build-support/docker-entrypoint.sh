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

sed -i "s/## hive_server_host=localhost/hive_server_host=hive-master/g" /etc/hue/conf/hue.ini

sed -i "s/## server_host=localhost/server_host=impala-master/g" /etc/hue/conf/hue.ini

tail -f /dev/null