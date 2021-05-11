FROM centos:7
ARG HOST_IP
RUN echo "[cloudera-cm]" > /etc/yum.repos.d/cm.repo &&\
    echo "name = cloudera-cm" >> /etc/yum.repos.d/cm.repo &&\
    echo "baseurl=http://cdh6-yum/cm6.3.1" >> /etc/yum.repos.d/cm.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cm.repo &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cm.repo &&\
    yum install -y oracle-j2sdk1.8.x86_64 &&\
    yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server cloudera-manager-agent
RUN rpm -ivh https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm &&\
    yum -y install  openssh-server  openssh-clientsmysql-community-client&& ssh-keygen -A
COPY docker-entrypoint.sh mysql-connector-java-5.1.46-bin.jar /
RUN  mkdir /usr/share/java &&\
     mv /mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar &&\
     chmod +x docker-entrypoint.sh



