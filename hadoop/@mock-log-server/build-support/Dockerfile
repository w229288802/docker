FROM openjdk:8
WORKDIR /opt/mock-log
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
CMD ["/bin/bash","-c","/docker-entrypoint.sh"]