#!/bin/bash
if [[ ! -f /etc/ssh/ssh_host_rsa_key ]];then
echo "==========================>>> keygen <<<=========================="
echo
    #ssh-keygen -A -t rsa -P ''
fi
/usr/sbin/sshd

mkdir -p /root/.ssh/
cp /etc/ssh/ssh_host_rsa_key ~/.ssh/id_rsa
cp /etc/ssh/ssh_host_rsa_key.pub ~/.ssh/authorized_keys
echo -n "master " > ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >>  ~/.ssh/known_hosts
echo -n "slave1 " >> ~/.ssh/known_hosts &&  cat /etc/ssh/ssh_host_rsa_key.pub >> ~/.ssh/known_hosts
ls ~/.ssh/

#while  nc slave1 22 2>/dev/null; ($? eq 1)
#do
# sleep 200ms
# echo 'wait'
#done
sleep 2s
echo "--"
#nc master 22
#nc slave1 22
ssh master ls
ssh slave1 ls

#ping slave1
