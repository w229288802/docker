#!/bin/bash
export JAVA_HOME=/usr
if [[ ! -f ~/.ssh/id_rsa ]];then
echo


    #/opt/hadoop-2.7.5/bin/hadoop namenode -format
fi
ssh-keygen -A -t rsa -P ''
/usr/sbin/sshd
ssh master ls /
ssh slave1 ls /
if [[ $HOSTNAME == "master" ]];then
ls ~/.ssh/
ssh master ls /
ssh slave1 ls /
 echo
    #/opt/hadoop-2.7.5/sbin/start-all.sh
fi
#ping master
echo "==========================>>> started <<<=========================="
