FROM centos:7
RUN yum -y install  openssh-server  openssh-clients java-1.7.0-openjdk
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh