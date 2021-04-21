FROM ubuntu
RUN apt-get update && apt-get -y install  openssh-server  openssh-client java-1.7.0-openjdk which nc telnet&& ssh-keygen -A
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
CMD ["/bin/bash","-c","/docker-entrypoint.sh"]