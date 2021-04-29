FROM centos:7
RUN yum install -y autofs
RUN echo "[cloudera-cm]" > /etc/yum.repos.d/cm.repo &&\
    echo "baseurl=http://yum-cdh6/cm6.3.1" >> /etc/yum.repos.d/cm.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cm.repo &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cm.repo
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh && /sbin/init



