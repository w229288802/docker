#!/bin/bash
S='\033[0;30m[debug] '
E='\033[0m'

FILE_DIR=$(cd $(dirname $0); pwd)
#删除以住进程
for pid_path in `ls ${FILE_DIR}/*.pid 2>/dev/null` ; do
#获取pid文件名(最后一次出现/后的字符串)
pid_name=${pid_path##*/}
#获取pid (最后一次出现.pid前的字符串)
pid=${pid_name%%.pid}
echo -E "the follows are killing "
echo `ps -ef | grep -E "\s${pid}\s" | awk '{print $9}'`
ps -ef | grep -E "\s${pid}\s" | awk '{print $2}' | xargs kill -9 2&>/dev/null
rm -f ${pid_path}
done
#获取父进程`ps -ef|awk '$2=='$psid'{print $3}'`,获取当前进程$$
echo > `ps -ef|awk '$2=='$$'{print $3}'`.pid

docker-compose -p hadoop down