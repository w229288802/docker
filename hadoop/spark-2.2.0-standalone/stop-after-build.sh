#!/bin/bash
BLACK_COLOR='\033[0;30m[debug] '
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

FILE_DIR=$(cd $(dirname $0); pwd)
#删除以住进程
for pid_path in `ls ${FILE_DIR}/*.pid 2>/dev/null` ; do
#获取pid文件名(最后一次出现/后的字符串)
pid_file=${pid_path##*/}
#获取pid (最后一次出现.pid前的字符串)
pid=${pid_file%%.pid}
println "the follows are killing ${pName}"
println "`ps -aux | grep -E "\s${pid}\s" | awk '{print $11,$12}'`"
ps -ef | grep -E "\s${pid}\s" | awk '{print $2}' | xargs kill -9 2&>/dev/null
rm -f ${pid_path}
done
#获取父进程`ps -ef|awk '$2=='$psid'{print $3}'`,获取当前进程$$
pid=`ps -ef|awk '$2=='$$'{print $3}'`
if [[ `ps -ef|awk '$2=='${pid}'{print $8}'`  != "-bash" ]]; then
echo > `ps -ef|awk '$2=='$$'{print $3}'`.pid
fi

docker-compose -p spark down