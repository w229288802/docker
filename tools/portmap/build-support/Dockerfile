FROM centos:7

RUN yum install -y nc && mkdir /opt/proxy

COPY proxy-linux-amd64.tar.gz /

RUN tar -xvf /proxy-linux-amd64.tar.gz -C /opt/proxy

ARG MAP_SOURCE_PORT
ARG MAP_SOURCE_HOST
ARG MAP_TARGET_PORT
ENV MAP_SOURCE_PORT=${MAP_SOURCE_PORT}
ENV MAP_SOURCE_HOST=${MAP_SOURCE_HOST}
ENV MAP_TARGET_PORT=${MAP_TARGET_PORT}
#CMD ncat --sh-exec "ncat $MAP_SOURCE_HOST $MAP_SOURCE_PORT" -l $MAP_TARGET_PORT  --keep-open
CMD /opt/proxy/proxy  tcp -p ":$MAP_TARGET_PORT" -T tcp -P "$MAP_SOURCE_HOST:$MAP_SOURCE_PORT"