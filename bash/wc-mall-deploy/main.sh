#!/bin/bash
#docker cp scp.sh deploy:/opt/scp.sh

service=$1
main_branch=$2
branch=$3
host=$4
password=$5
index=$6

if [ $service == 'mall-deliver' -o $service == 'mall-order' -o $service == 'mall-data' ];then
pom_version="0.0.1-SNAPSHOT"
else
pom_version="1.0.0-SNAPSHOT"
fi

if [ $main_branch != master ];then
  target_dir=/home/appuser/wc-mall/${service}/source
else
  target_dir=/home/appuser/wc-mall/deploy
fi

scp="#!/usr/bin/expect -f \n
set timeout -1 \n
spawn scp -r /opt/${service}-${pom_version}.jar appuser@${host}:${target_dir} \n
expect { \n
  *(yes/no)?  {send yes\\\r} \n
  *password:  {send ${password}\\\r} \n
} \n
expect eof"

cd ../../../deploy/wc-mall-${main_branch}
echo "#### 当前目录:"
pwd

if [ $index -eq 0 ];then
  echo "#### 切换分支到:${main_branch}"
  git checkout ${main_branch}
  echo "#### 拉取代码"
  git pull
fi

if [ $main_branch != master ] && [ $index -eq 0 ];then
  echo "##################################### 合并分支 ## ${branch} #####################################"
  echo "##################################### 打包环境 ## ${main_branch} #####################################"
  git merge remotes/origin/${branch}
  if [ $? -ne 0 ];then
    echo "### 合并代码出错"
    exit
  fi
  echo "#### 推送拉码"
  git push
fi

if [ $index -eq 0 ];then
  echo "#### 最新提交记录"
  git log -n2 --oneline
  #echo `mvn help:evaluate -Dexpression="project.version" -q -DforceStdout`
  version=`git rev-parse HEAD`
  old_version=`cat .version 2>/dev/null`
  echo "#### 当前版号:$version"
  echo "#### 旧版号:$old_version"
fi

#exit 0

echo -e "package com.wchl.mall.common.config;
@org.springframework.web.bind.annotation.RestController
public class HealthController {
    @org.springframework.web.bind.annotation.GetMapping(\"/info\")
    public String info(){
        String n = \"<br/>\";
        return `git log -n10 --oneline| sed 's/"//g' | sed 's/^/\"/' | sed 's/$/\"+n+/'`
        \"#######打包时间：`date +"%Y-%m-%d %H:%M:%S"`#######\"+
        \"<b>#######当前分支：`echo $main_branch`#######<b>\";
    }
}" > mall-common/src/main/java/com/wchl/mall/common/config/HealthController.java

if [ "$version" != "$old_version" ] && [ $index -eq 0 ];then
  echo $version > .version
  echo "#### 正在打包"
  if [ $branch == master ];then
    mvn clean package -q
  else
    #mvn clean package -q
    mvn clean install -q -f ./mall-common/pom.xml && mvn clean package -q -f ./${service}/pom.xml && rm -rf .version
  fi
  if [ $? -eq 0 ];then
    echo "#### 打包成功"
  else
    echo "#### 打包失败"
    rm -rf .version
    exit
  fi
fi

if [ $branch == master ];then
  cp -f ${service}/target/${service}-${pom_version}.jar ../
  exit
fi

docker cp ${service}/target/${service}-${pom_version}.jar deploy:/opt/
echo "#### 正在上传文件"

echo -e $scp > ./scp.sh
docker cp scp.sh deploy:/opt/scp.sh
#docker exec deploy sh -c "touch /opt/scp.sh && echo -e $ss > /opt/scp.sh"
#docker exec deploy sh -c 'sshpass -p Yhxx#0814 scp -r /opt/mall-ca-1.0.0-SNAPSHOT.jar appuser@10.199.201.196:/home/appuser/wc-mall/mall-ca/source/test'
docker exec deploy bash -c "opt/scp.sh"
if [ $? -eq 0 ];then
  echo "#### 上传文件成功"
  docker exec deploy sh -c "sshpass -p ${password} ssh appuser@${host} 'cd /home/appuser/wc-mall/${service}/bin/&&./restart.sh'"
else
  echo "#### 上传文件失败"
fi

