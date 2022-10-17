#配置zabbix yum 源
cat <<EOF > /etc/yum.repos.d/zabbix.repo
[zabbix]
name=Zabbix Official Repository - \$basearch
baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.0/rhel/7/\$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - \$basearch
baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/\$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=1
EOF
#添加秘钥
curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591 \
    -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591
curl https://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX \
    -o /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
#安装zabbix
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
yum clean all
#安装Zabbix server，Web前端，agent
yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent
#创建初始数据库
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user zabbix@'%'' identified by 'Zabbix@123';
mysql> grant all privileges on zabbix.* to zabbix@'%';
mysql> quit;
#导入初始架构和数据，系统将提示您输入新创建的密码
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p
#No database selected报错处理
cd /usr/share/doc/zabbix-server-mysql*/
gunzip create.sql.gz
vim create.sql
cat create.sql | mysql -uzabbix -p
#为Zabbix server配置数据库
#/etc/zabbix/zabbix_server.conf
DBPassword=password
#为Zabbix前端配置PHP
 #编辑配置文件 /etc/httpd/conf.d/zabbix.conf
 php_value date.timezone Asia/Shanghai
 #启动Zabbix server和agent进程
 systemctl restart zabbix-server zabbix-agent httpd
 systemctl enable zabbix-server zabbix-agent httpd
 #中文字体添加中字体到
 /usr/share/zabbix/assets/fonts/simkai.ttf
 #修改中文字体为simkai
 vim /usr/share/zabbix/include/defines.inc.php