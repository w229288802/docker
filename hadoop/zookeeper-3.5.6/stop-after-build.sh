#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

APP_NAME=zookeeper

FILE_PATH=$(cd $(dirname $0); pwd)
#删除以住进程
for pid_path in `ls ${FILE_PATH}/*.pid 2>/dev/null` ; do
#获取pid文件名(最后一次出现/后的字符串)
pid_file=${pid_path##*/}
#获取pid (最后一次出现.pid前的字符串)
pid=${pid_file%%.pid}
println "the follows are killing"
println "`ps -aux | grep -E "\s${pid}\s" | awk '{print $11,$12}'`"
#杀死指定pid和进程名字的shell
ps -ef | grep -E "\s${pid}\s" | grep `cat ${pid_path}` | awk '{print $2}' | xargs kill -9 2&>/dev/null
rm -f ${pid_path}
done
#获取父进程`ps -ef|awk '$2=='$psid'{print $3}'`,获取当前进程$$
pid=`ps -ef|awk '$2=='$$'{print $3}'`
if [[ `ps -ef|awk '$2=='${pid}'{print $8}'`  != "-bash" ]]; then
# 进程名
pName=`ps -aux | grep -E "\s${pid}\s" | awk '{print $12}'`
# 进程名打印到进程pid文件
echo ${pName##*/}> ${FILE_PATH}/`ps -ef|awk '$2=='$$'{print $3}'`.pid
fi

docker-compose -f ${FILE_PATH}/docker-compose.yml -p ${APP_NAME} down