#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
APP_NAME=hive
HIVE_DATA=/data/hadoop
HIVE_VERSION=2.1.1
HIVE_DIR=apache-${APP_NAME}-${HIVE_VERSION}-bin
HIVE_HOME=/opt/${HIVE_DIR}
CDH_MASTER_HOSTNAME=cdh6
HIVE_SLAVE1_HOSTNAME=hive-slave1
export PATH=$PATH:${HIVE_HOME}/bin

#导出变量
echo "export HIVE_HOME=${HIVE_HOME}">> ~/.bashrc
echo "export PATH=${PATH}">> ~/.bashrc

sed -i "s/server_host=localhost/server_host=${CDH_MASTER_HOSTNAME}/g" /etc/cloudera-scm-agent/config.ini
#systemctl start cloudera-scm-server
tail -f /dev/null