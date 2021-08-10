## 一、privoxy安装步骤

### 1. 安装privoxy

```bash
yum -y  install epel-release
yum -y install privoxy
```

### 2. 修改配置 

```ini
# /etc/privoxy下的config文件
listen-address  0.0.0.0:8118
forward-socks5t   .googleapis.com/               127.0.0.1:1080 .
forward-socks5t   .google.com/                   127.0.0.1:1080 .
```

### 3. 重启privoxy

```bash
systemctl restart privoxy
##-Dhttp.proxyPort 在window上是-Dhttp.ProxyPort(后面测好像双不是，放VM option里)
##用http代理方式访问www.google.com
docker -H tcp://pccw105:2375 run -d -p 8000:8000 -e "JAVA_ARGS=-Dhttp.proxyHost=172.16.253.105 -Dhttp.proxyPort=8118 -Dhttps.proxyHost=172.16.253.105 -Dhttps.proxyPort=8118" --name=partner partner
```

