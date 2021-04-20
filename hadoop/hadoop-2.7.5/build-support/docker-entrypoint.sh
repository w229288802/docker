#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

/usr/sbin/sshd

mkdir -p /root/.ssh/
cp /etc/ssh/ssh_host_rsa_key ~/.ssh/id_rsa
cp /etc/ssh/ssh_host_rsa_key.pub ~/.ssh/authorized_keys
echo -n "master " > ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >>  ~/.ssh/known_hosts
echo -n "slave1 " >> ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >> ~/.ssh/known_hosts

# 开启hadoop
if [[ "${HOSTNAME}" == "master" ]]; then
ls /opt
/opt/hadoop-2.7.5/sbin/start-all.sh
else

# 等待master启
while nc -w 1 master 22 </dev/null >/dev/null 2>&1;[[ $? == 1 || $? == 2 ]]
do
 sleep 0.2s
done
echo -e "${S}check activated master${E}"
# 等待 master退出,注意！！！不然会找不到slave，也可以用sleep等待
while nc -w 1 master 22 </dev/null >/dev/null 2>&1;[[ $? == 0 || $? == 2 ]]
do
  sleep 0.2s
done
echo -e "${S}check inactivated master${E}"

fi