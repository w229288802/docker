【Linux】命令行使用教程
命令行客户端仅提供最基础的功能，如果没有必要，推荐使用其他图形客户端。
1. 下载客户端
访问 https://dl.trojan-cdn.com/trojan/linux/ 下载
访问 Github 下载
下载 trojan-[版本号]-linux-amd64.tar.xz 文件

2. 获取配置文 件config
登入到客户中心，依次访问 产品服务 > 我的产品与服务(点击前往) ，查看 Trojan 服务对应的 云加速服务 - Lite / Pro 服务器信息。


3. 配置客户端
解压客户端后，进入客户端的目录，使用文本编辑器编辑 config.json 文件，使用 2. 获取配置 中复制的配置替换全部的内容后保存。
{
    "local_addr":"0.0.0.0"
    "ssl":{"cert": "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"}
}

sudo ./trojan &
pkill -f trojan