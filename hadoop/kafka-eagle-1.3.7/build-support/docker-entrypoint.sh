#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
#PATH=$PATH:${HADOOP_HOME}/bin

#导出变量
#echo "export HADOOP_HOME=${HADOOP_HOME}">> ~/.bashrc
#echo "export PATH=${PATH}">> ~/.bashrc

chmod +x /opt/kafka-eagle/bin/ke.sh
/opt/kafka-eagle/bin/ke.sh start
#mkdir /tmp/zookeeper
#hostname|grep -o '[0-9]*' > /tmp/zookeeper/myid
#/opt/zookeeper-3.5.6/bin/zkServer.sh start
tail -f /dev/null