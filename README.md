#window
https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip

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


#安装docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose