FROM openjdk:8
COPY docker-entrypoint.sh /
COPY conf/system-config.properties /opt/kafka-eagle/conf/
RUN chmod +x docker-entrypoint.sh
CMD ["/bin/bash","-c","/docker-entrypoint.sh"]