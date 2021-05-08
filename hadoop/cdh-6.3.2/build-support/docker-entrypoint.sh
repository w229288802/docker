#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
APP_NAME=cdh6
CDH_MASTER_HOSTNAME=cdh6

#导出变量
echo "export HIVE_HOME=${HIVE_HOME}">> ~/.bashrc
echo "export PATH=${PATH}">> ~/.bashrc

println_and_run "/usr/sbin/sshd"

#配置数据库
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h mysql scm root root

sed -i "s/server_host=localhost/server_host=${CDH_MASTER_HOSTNAME}/g" /etc/cloudera-scm-agent/config.ini
systemctl start cloudera-scm-server
tail -f /dev/null