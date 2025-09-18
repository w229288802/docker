#!/bin/bash
#docker cp scp.sh deploy:/opt/scp.sh

service=$1
main_branch=$2
branch=$3
host=$4
password=$5

source_dir=/e/users/v_wuweijie/桌面/deploy

if [ $service == 'mall-deliver' ];then
pom_version="0.0.1-SNAPSHOT"
else
pom_version="1.0.0-SNAPSHOT"
fi


if [ $main_branch != master ];then
  target_dir=/home/appuser/wc-mall/${service}/source/
else
  target_dir=/home/appuser/wc-mall/deploy
fi
cp ./expect.exe ${source_dir}/wc-mall-${main_branch}/
scp="echo(true)\n
if spawn([[scp]],'./${service}/target/${service}-${pom_version}.jar', 'appuser@${host}:${target_dir}/${service}-${pom_version}-`date +%Y-%m-%d_%H:%M`.jar') then\n
    expect('password:')\n
	echo(false)\n
    send('${password}\\\r')\n
	expect('(yes/no)?')\n
	echo(false)\n
    send('yes\\\r')\n
end"
exec="echo(true)\n
if spawn([[ssh]], 'appuser@${host}', 'cd /home/appuser/wc-mall/${service}/bin/&&./restart.sh1') then\n
    expect('password:')\n
	echo(false)\n
    send('${password}\\\r')\n
end"

cd ${source_dir}/wc-mall-${main_branch}/
echo "#### 当前目录:"
pwd
echo "#### 切换分支到:${main_branch}"
git checkout ${main_branch}
echo "#### 拉取代码"
git pull
if [ $main_branch != master ];then
  echo "#### 合并分支${branch}"
  git merge remotes/origin/${branch}
  if [ $? -ne 0 ];then
    echo "### 合并代码出错"
    exit
  fi
  echo "#### 推送拉码"
git push
fi
echo "#### 最新提交记录"
git log -n2 --oneline
#echo `mvn help:evaluate -Dexpression="project.version" -q -DforceStdout`
version=`git rev-parse HEAD`
old_version=`cat .version 2>/dev/null`
echo "#### 当前版号:$version"
echo "#### 旧版号:$old_version"
if [ "$version" != "$old_version" ];then
  echo "#### 正在打包"
    /f/软件/maven/bin/mvn clean install -q
    if [ $? -eq 0 ];then
      echo "#### 打包成功"
    else
      echo "#### 打包失败"
      exit
    fi
  echo $version > .version
fi

echo "#### 正在上传文件"

echo -e $scp > ./scp.lua
pwd
./expect scp.lua
if [ $? -eq 0 ];then
  echo "#### 上传文件成功"
else
  echo "#### 上传文件失败"
fi

