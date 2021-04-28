FROM centos:6
RUN yum -y install  openssh-server  openssh-clients java-1.7.0-openjdk which
RUN yum -y install nc  telnet&& ssh-keygen -A
CMD tail -f /dev/null