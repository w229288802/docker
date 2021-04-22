#1.下载 Spark 安装包, 下载时候选择对应的 Hadoop 版本(资料中已经提供了 Spark 安装包, 直接上传至集群 Master 即可, 无需遵循以下步骤)
cd /export/softwares
wget https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz

#2.解压并拷贝到`export/servers`
tar xzvf spark-2.2.0-bin-hadoop2.7.tgz
mv spark-2.2.0-bin-hadoop2.7.tgz /export/servers/spark

#3.修改配置文件`spark-env.sh`, 以指定运行参数
cd /export/servers/spark/conf
cp spark-env.sh.template spark-env.sh
vi spark-env.sh

#4.添加以下内容到spark-env.sh末尾
export JAVA_HOME=/export/servers/jdk1.8.0
export SPARK_MASTER_HOST=node01
export SPARK_MASTER_PORT=7077

#5.修改配置文件 slaves,
cd /export/servers/spark/conf
cp slaves.template slaves
vi slaves

#6.配置 HistoryServer
cd /export/servers/spark/conf
cp spark-defaults.conf.template spark-defaults.conf
vi spark-defaults.conf
#4.添加以下内容到spark-defaults.conf末尾
spark.eventLog.enabled  true
spark.eventLog.dir      hdfs://node01:8020/spark_log
spark.eventLog.compress true

#8.将以下内容复制到`spark-env.sh`的末尾, 配置 HistoryServer 启动参数, 使得 HistoryServer 在启动的时候读取 HDFS 中写入的 Spark 日志
export SPARK_HISTORY_OPTS="-Dspark.history.ui.port=4000 -Dspark.history.retainedApplications=3 -Dspark.history.fs.logDirectory=hdfs://node01:8020/spark_log"


为 Spark 创建 HDFS 中的日志目录
hdfs dfs -mkdir -p /spark_log

将 Spark 安装包分发给集群中其它机器
cd /export/servers
scp -r spark root@node02:$PWD
scp -r spark root@node03:$PWD

启动 Spark Master 和 Slaves, 以及 HistoryServer
cd /export/servers/spark
sbin/start-all.sh
sbin/start-history-server.sh

http://master:8080/