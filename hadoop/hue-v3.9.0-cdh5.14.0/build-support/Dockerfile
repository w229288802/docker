FROM centos:6
RUN sed -i "s|enabled=1|enabled=0|g" /etc/yum/pluginconf.d/fastestmirror.conf &&\
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup&&\
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://www.xmpan.com/Centos-6-Vault-Aliyun.repo&&\
    yum clean all&&yum makecache
RUN echo "[cloudera-cdh5]" > /etc/yum.repos.d/cloudera-cdh5.repo &&\
    # Packages for Cloudera's Distribution for Hadoop, Version 5, on RedHat or CentOS 6 x86_64
    echo "name=Cloudera's Distribution for Hadoop, Version 5" >> /etc/yum.repos.d/cloudera-cdh5.repo &&\
    echo "baseurl=http://cdh5-yum" >> /etc/yum.repos.d/cloudera-cdh5.repo &&\
    echo "gpgcheck = 0" >> /etc/yum.repos.d/cloudera-cdh5.repo  &&\
    echo "enabled = 1" >> /etc/yum.repos.d/cloudera-cdh5.repo
RUN yum install -y hue
COPY . /
ENTRYPOINT chmod +x /docker-entrypoint.sh && /docker-entrypoint.sh