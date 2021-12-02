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
if [[ "${HOSTNAME}" == "flume-pre" ]]; then
/opt/flume-1.9.0/bin/flume-ng agent -c /opt/flume-1.9.0/conf -f /opt/flume-1.9.0/conf/preposition-flume-kafka.conf -n a1 -Dflume.root.logger=INFO,console
else
/opt/flume-1.9.0/bin/flume-ng agent -c /opt/flume-1.9.0/conf -f /opt/flume-1.9.0/conf/postposition-flume-kafka.conf -n a1 -Dflume.root.logger=INFO,console
fi
#/opt/flume-1.9.0/bin/flume-ng agent --name a1 --conf-file conf/file-flume-kafka.conf &
#cp /opt/kafka_2.11-2.4.1/config/server.properties  /etc/server.properties
#sed -i "s/broker.id=0/broker.id=`hostname|grep -o '[0-9]*'`/g" /etc/server.properties
#ln -s /usr/local/openjdk-8/bin/java /usr/bin/java
#/opt/kafka_2.11-2.4.1/bin/kafka-server-start.sh -daemon /etc/server.properties
#mkdir /tmp/zookeeper
#hostname|grep -o '[0-9]*' > /tmp/zookeeper/myid
#/opt/zookeeper-3.5.6/bin/zkServer.sh start
tail -f /dev/null