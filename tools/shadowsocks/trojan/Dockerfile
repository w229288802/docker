FROM centos:7
COPY trojan-1.15.1-linux-amd64.tar.xz /opt
RUN yum -y  install epel-release && yum -y install privoxy && tar -xvf /opt/trojan-1.15.1-linux-amd64.tar.xz -C /opt
RUN sed -i "s|127.0.0.1:8118|0.0.0.0:8118|g" /etc/privoxy/config && \
    #上面有限制，可能不能访问网页
    #echo "forward-socks5t   .googleapis.com/               127.0.0.1:1080 ." >> /etc/privoxy/config &&\
    #echo "forward-socks5t   .google.com/                   127.0.0.1:1080 ." >> /etc/privoxy/config
    #可以访问网页
    echo "forward-socks5t   /                   127.0.0.1:1080 ." >> /etc/privoxy/config
COPY build-support/opt/trojan/config.json /opt/trojan
WORKDIR /opt/trojan
CMD  /usr/sbin/privoxy --pidfile /run/privoxy.pid --user privoxy /etc/privoxy/config && ./trojan
#1080端口为socks5协议 ， 8118端口为http,https协议