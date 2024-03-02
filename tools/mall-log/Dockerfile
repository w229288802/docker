FROM openjdk:8
COPY log-web-1.0.0-SNAPSHOT.jar /opt/
##java -jar JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar -p 1008 &
##http://jrebel.yanjiayu.cn:9001/
##wget https://terwer.oss-cn-qingdao.aliyuncs.com/active/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar
ENTRYPOINT ["java","-jar", "/opt/log-web-1.0.0-SNAPSHOT.jar","--spring.profiles.active=test","--spring.cloud.nacos.discovery.server-addr=host.docker.internal:8848,host.docker.internal:8849,host.docker.internal:8850","--spring.cloud.nacos.config.server-addr=host.docker.internal:8848,host.docker.internal:8849,host.docker.internal:8850"]