#Docker开启Remote API 访问 2375端口
vim /usr/lib/systemd/system/docker.service
#找到 ExecStart，在最后面添加 -H tcp://0.0.0.0:2375，如下图所示
[Service]
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock

systemctl daemon-reload
systemctl start docker