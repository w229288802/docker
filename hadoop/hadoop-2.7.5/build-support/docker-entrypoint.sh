#!/bin/bash
BLACK_COLOR='\033[0;30m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

#配置变量
HADOOP_HOME=/opt/hadoop-2.7.5
HADOOP_DATA=/data/hadoop
HADOOP_MASTER_HOSTNAME=hadoop-master
HADOOP_SLAVE1_HOSTNAME=hadoop-slave1
PATH=$PATH:${HADOOP_HOME}/bin

#导出变量
echo "export HADOOP_HOME=${HADOOP_HOME}">> ~/.bashrc
echo "export PATH=${PATH}">> ~/.bashrc

# 启动sshd
println_and_run "/usr/sbin/sshd"
# 拷贝sshd秘钥
mkdir -p /root/.ssh/
cp /etc/ssh/ssh_host_rsa_key ~/.ssh/id_rsa
cp /etc/ssh/ssh_host_rsa_key.pub ~/.ssh/authorized_keys
echo -n "${HADOOP_MASTER_HOSTNAME} " > ~/.ssh/known_hosts &&  sed -r "s|root@\w+||g" /etc/ssh/ssh_host_rsa_key.pub >>  ~/.ssh/known_hosts
echo -n "${HADOOP_SLAVE1_HOSTNAME} " >> ~/.ssh/known_hosts &&  sed -r "s|root@\w+||g" /etc/ssh/ssh_host_rsa_key.pub >> ~/.ssh/known_hosts
#格式化namenode
if [[ ! -d ${HADOOP_DATA} ]];then
println_and_run "mkdir ${HADOOP_DATA}"
println_and_run "hadoop namenode -format"
fi

# 开启hadoop
if [[ "${HOSTNAME}" == "hadoop-master" ]]; then
println_and_run "sed -i 's|\${JAVA_HOME}|${JAVA_HOME}|' ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh"
println_and_run "${HADOOP_HOME}/sbin/start-all.sh"
# 注意！！！如果是slave, 需等待 master退出,不然会找不到slave，也可以用sleep等待
else
while nc -w 1 ${HADOOP_MASTER_HOSTNAME} 22 </dev/null >/dev/null 2>&1;[[ $? == 1 || $? == 2 ]] #等待master启动
do
 sleep 0.2s
done
println "check activated ${HADOOP_MASTER_HOSTNAME}"

while nc -w 1 ${HADOOP_MASTER_HOSTNAME} 22 </dev/null >/dev/null 2>&1;[[ $? == 0 || $? == 2 ]] #等待master停止
do
  sleep 0.2s
done
println "check inactivated ${HADOOP_MASTER_HOSTNAME}"
fi
tail -f /dev/null