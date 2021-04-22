#window
https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip

#Docker常见端口#

2375：未加密的docker socket,远程root无密码访问主机
2376：tls加密套接字,很可能这是您的CI服务器4243端口作为https 443端口的修改
2377：群集模式套接字,适用于群集管理器,不适用于docker客户端
5000：docker注册服务
4789和7946：覆盖网络

#Docker开启Remote API 访问 2375端口
vim /usr/lib/systemd/system/docker.service
#找到 ExecStart，在最后面添加 -H tcp://0.0.0.0:2375，如下图所示
[Service]
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock

#vim /etc/docker/daemon.json
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "http://hub-mirror.c.163.com",
        "https://docker.mirrors.ustc.edu.cn"],
    "insecure-registries":["qcloud:5000"] 
}

systemctl daemon-reload
systemctl restart docker


#安装docker
##卸载旧版本
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
 ##安装所需的软件包。
 yum-utils 提供了 yum-config-manager ，并且 device mapper 存储驱动程序需要 device-mapper-persistent-data 和 lvm2。
 yum install -y yum-utils \
   device-mapper-persistent-data \
   lvm2
##添加yum仓库
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#安装 Docker Engine-Community
yum install -y docker-ce docker-ce-cli containerd.io
    

#安装docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose