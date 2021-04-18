1. 安装privoxy
yum -y install privoxy
2. 修改配置 /etc/privoxy
listen-address  0.0.0.0:8118
forward-socks5t   .googleapis.com/               127.0.0.1:1080 .
forward-socks5t   .google.com/                   127.0.0.1:1080 .
3. 重启privoxy
systemctl restart privoxy

##-Dhttp.proxyPort 在window上是-Dhttp.ProxyPort
docker -H tcp://pccw105:2375 run -d -p 8000:8000 -e "JAVA_ARGS=-Dhttp.proxyHost=172.16.253.105 -Dhttp.proxyPort=8118 -Dhttps.proxyHost=172.16.253.105 -Dhttps.proxyPort=8118" --name=partner partner