FROM centos:7
ARG HOST_IP
RUN echo "[cloudera-cm]" > /etc/yum.repos.d/cm.repo &&\
    echo "name = cloudera-cm" >> /etc/yum.repos.d/cm.repo &&\
    echo "baseurl=http://${HOST_IP}/cm6.3.1" >> /etc/yum.repos.d/cm.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cm.repo &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cm.repo
COPY docker-entrypoint.sh /
RUN yum -y  install oracle-j2sdk1.8-1.8.0
RUN chmod +x docker-entrypoint.sh && yum -y  install  cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server cloudera-manager-agent


