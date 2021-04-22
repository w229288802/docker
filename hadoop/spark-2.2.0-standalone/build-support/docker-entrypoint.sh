#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
SPARK_HOME=/opt/spark-2.2.0
HADOOP_HOME=/opt/hadoop-2.7.5
SPARK_MASTER_HOSTNAME=spark-master
SPARK_SLAVE1_HOSTNAME=spark-slave1
HADOOP_MASTER_HOST=hadoop-master
HADOOP_DFS_PORT=9000
PATH=${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}

#导出变量
echo "export SPARK_HOME=${SPARK_HOME}">> ~/.bashrc
echo "export HADOOP_HOME=${HADOOP_HOME}">> ~/.bashrc
echo "export PATH=${SPARK_HOME}/bin:${HADOOP_HOME}/bin:${PATH}">> ~/.bashrc

# 启动sshd
mkdir /run/sshd
println_and_run "/usr/sbin/sshd"
# 拷贝sshd秘钥
mkdir -p /root/.ssh/
cp /etc/ssh/ssh_host_rsa_key ~/.ssh/id_rsa
cp /etc/ssh/ssh_host_rsa_key.pub ~/.ssh/authorized_keys
echo -n "${HADOOP_MASTER_HOSTNAME} " > ~/.ssh/known_hosts &&  sed -r "s|root@\w+||g" /etc/ssh/ssh_host_rsa_key.pub >>  ~/.ssh/known_hosts
echo -n "${HADOOP_SLAVE1_HOSTNAME} " >> ~/.ssh/known_hosts &&  sed -r "s|root@\w+||g" /etc/ssh/ssh_host_rsa_key.pub >> ~/.ssh/known_hosts


# 开启hadoop
if [[ "${HOSTNAME}" == "${SPARK_MASTER_HOSTNAME}" ]]; then
echo "export JAVA_HOME=${JAVA_HOME}" >> ${SPARK_HOME}/sbin/spark-config.sh
println_and_run "hdfs dfs -fs hdfs://${HADOOP_MASTER_HOST}:${HADOOP_DFS_PORT} -mkdir -p /spark_log"
println_and_run "${SPARK_HOME}/sbin/start-all.sh"
println_and_run "${SPARK_HOME}/sbin/start-history-server.sh"
# 注意！！！如果是slave, 需等待 master退出,不然会找不到slave，也可以用sleep等待
else

println "waiting ${SPARK_MASTER_HOSTNAME} activated"
while nc -w 1 ${SPARK_MASTER_HOSTNAME} 22 </dev/null >/dev/null 2>&1;[[ $? == 1 || $? == 2 ]] #等待master启动
do
 sleep 0.2s
done

println "wait ${SPARK_MASTER_HOSTNAME} inactivated "
while nc -w 1 ${SPARK_MASTER_HOSTNAME} 22 </dev/null >/dev/null 2>&1;[[ $? == 0 || $? == 2 ]] #等待master停止
do
  sleep 0.2s
done

fi
tail -f /dev/null