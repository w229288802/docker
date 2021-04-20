#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

#配置变量
HADOOP_HOME=/opt/hadoop-2.7.5
HADOOP_DATA=/data/hadoop
PATH=$PATH:${HADOOP_HOME}/bin

#导出变量
echo "export HADOOP_HOME=${HADOOP_HOME}">> ~/.bashrc
echo "export PATH=${PATH}">> ~/.bashrc

# 启动sshd
/usr/sbin/sshd
# 拷贝sshd秘钥
mkdir -p /root/.ssh/
cp /etc/ssh/ssh_host_rsa_key ~/.ssh/id_rsa
cp /etc/ssh/ssh_host_rsa_key.pub ~/.ssh/authorized_keys
echo -n "master " > ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >>  ~/.ssh/known_hosts
echo -n "slave1 " >> ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >> ~/.ssh/known_hosts

#
if [[ ! -d ${HADOOP_DATA} ]];then
mkdir ${HADOOP_DATA}
hadoop namenode -format
fi

# 开启hadoop
if [[ "${HOSTNAME}" == "master" ]]; then
echo -e "${S}sed -i "s|\\\${JAVA_HOME}|${JAVA_HOME}|" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh${E}"
sed -i "s|\${JAVA_HOME}|${JAVA_HOME}|" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
${HADOOP_HOME}/sbin/start-all.sh
# 注意！！！如果是slave, 需等待 master退出,不然会找不到slave，也可以用sleep等待
else
while nc -w 1 master 22 </dev/null >/dev/null 2>&1;[[ $? == 1 || $? == 2 ]] #等待master启动
do
 sleep 0.2s
done
echo -e "${S}check activated master${E}"

while nc -w 1 master 22 </dev/null >/dev/null 2>&1;[[ $? == 0 || $? == 2 ]] #等待master停止
do
  sleep 0.2s
done
echo -e "${S}check inactivated master${E}"
fi
tail -f /dev/null