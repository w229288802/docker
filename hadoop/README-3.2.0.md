docker run --name=slave2 --hostname=slave2 -p 8080:8080 -p 9000:9000 p 8088:8088 -p 50075:50075 -p 50070:50070 -p 19888:19888 -d --privileged -v ~/softwares:/softwares/  --network hadoop  centos /usr/sbin/init
docker run --name=slave1 --hostname=slave1 -d --privileged -v ~/softwares:/softwares/  --network hadoop  centos /usr/sbin/init 
docker run --name=slave2 --hostname=slave2 -d --privileged -v ~/softwares:/softwares/  --network hadoop  centos /usr/sbin/init 
yum -y install  openssh-server  openssh-clients
 
#master上生成RSA密钥
ssh-keygen -t rsa

#把密钥复制到slave1 slave2
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
 
# 配置jdk
export JAVA_HOME=/opt/jdk
export PATH=$JAVA_HOME/bin:$PATH
source /etc/profile

#配置hadoop环境
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_ROOT_LOGGER=INFO,console
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

source /etc/profile

#修改master节点/opt/hadoop/etc/hadoop/slaves
slave1
slave2

#修改master节点/opt/hadoop/etc/hadoop/core-site.xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://master:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/hadoop/tmp</value>
    </property>
</configuration>

#修改master节点/opt/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>master:9000</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/opt/hadoop/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/opt/hadoop/dfs/data</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
</configuration>

#复制mapred-site.xml
cp /opt/hadoop/etc/hadoop/mapred-site.xml.template /opt/hadoop/etc/hadoop/mapred-site.xml
#修改/opt/hadoop/etc/hadoop/mapred-site.xml
<configuration>
    <property> 
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>

# 修改/opt/hadoop/etc/hadoop/yarn-site.xml
<configuration>
    <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>master</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value> 
        </property>
        <property>
            <name>yarn.nodemanager.vmem-check-enabled</name>
            <value>false</value>
        </property>
</configuration>

#master上的hadoop配置完成，将配置全部拷贝到slave1,slave2
scp -r /opt/hadoop slave1:/opt/
scp -r /opt/hadoop slave2:/opt/

#分别在master,slave1,slave2 执行
hadoop namenode -format

#在/opt/hadoop/sbin/start-yarn.sh前面添加
YARN_RESOURCEMANAGER_USER=root
HDFS_DATANODE_SECURE_USER=yarn
YARN_NODEMANAGER_USER=root

#在/opt/hadoop/sbin/stop-dfs.sh前面添加
HDFS_DATANODE_USER=root
HDFS_DATANODE_SECURE_USER=hdfs
HDFS_NAMENODE_USER=root
HDFS_SECONDARYNAMENODE_USER=root

#在master上，启动hadoop集群
/opt/hadoop/sbin/start-all.sh

http://192.168.0.211:50070
http://192.168.0.211:8088