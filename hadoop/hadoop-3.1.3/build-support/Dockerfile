FROM centos:7
RUN yum -y install  openssh-server  openssh-clients java-1.8.0-openjdk which
RUN yum -y install  lzo-devel  zlib-devel  gcc autoconf automake libtool
RUN yum -y install nc  telnet&& ssh-keygen -A
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
CMD ["/bin/bash","-c","/docker-entrypoint.sh"]