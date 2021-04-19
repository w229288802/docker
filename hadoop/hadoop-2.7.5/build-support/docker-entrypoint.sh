#!/bin/bash
if [[ ! -f ~/.ssh/id_rsa ]];then
ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''
fi
if [[ $HOSTNAME == "" ]];then
    echo "test"
fi
echo "started"