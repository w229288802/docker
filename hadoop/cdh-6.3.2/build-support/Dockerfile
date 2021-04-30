FROM centos:7
ARG HOST_IP
#RUN yum install -y java-1.8.0-openjdk-devel.x86_64
RUN echo "[cloudera-cm]" > /etc/yum.repos.d/cm.repo &&\
    echo "name = cloudera-cm" >> /etc/yum.repos.d/cm.repo &&\
    echo "baseurl=http://${HOST_IP}/cm6.3.1" >> /etc/yum.repos.d/cm.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cm.repo &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cm.repo
COPY docker-entrypoint.sh /
COPY mysql-connector-java-5.1.38.jar /usr/bin/
RUN yum install -y oracle-j2sdk1.8.x86_64
RUN chmod +x docker-entrypoint.sh && yum -y  install  cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server cloudera-manager-agent


