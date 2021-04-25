#!/bin/bash
BLACK_COLOR='\033[0;35m'
NO_COLOR='\033[0m'

#配置变量
FILE_PATH=$(cd $(dirname $0); pwd)
APP_NAME=kudu

${FILE_PATH}/stop-after-build.sh

println_and_run() { printf "${BLACK_COLOR}$1 ${NO_COLOR}\n"; bash -c "$1";}
println(){ printf "${BLACK_COLOR}$1 ${NO_COLOR}\n";}

export KUDU_QUICKSTART_IP=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 |  awk '{print $2}' | tail -1)
export KUDU_QUICKSTART_VERSION=1.9
println_and_run "docker-compose -f ${FILE_PATH}/quickstart.yml -p ${APP_NAME} up --remove-orphans"