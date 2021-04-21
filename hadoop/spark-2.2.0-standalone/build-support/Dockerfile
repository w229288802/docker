FROM ubuntu
RUN apt-get update && apt-get -y install  openssh-server  openssh-client openjdk-8-jdk netcat-traditional&& ssh-keygen -A
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
CMD ["/bin/bash","-c","/docker-entrypoint.sh"]