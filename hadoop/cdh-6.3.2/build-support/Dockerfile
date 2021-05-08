FROM centos:7
ARG HOST_IP
RUN echo "[cloudera-cm]" > /etc/yum.repos.d/cm.repo &&\
    echo "name = cloudera-cm" >> /etc/yum.repos.d/cm.repo &&\
    echo "baseurl=http://yum-cdh6/cm6.3.1" >> /etc/yum.repos.d/cm.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cm.repo &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cm.repo &&\
    yum install -y oracle-j2sdk1.8.x86_64 &&\
    yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server cloudera-manager-agent
COPY docker-entrypoint.sh mysql-connector-java-5.1.46-bin.jar /
RUN  mkdir /usr/share/java &&\
     mv /mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar &&\
     chmod +x docker-entrypoint.sh &&\
     yum -y install  openssh-server  openssh-clients && ssh-keygen -A


