FROM java:8
COPY JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar /opt/
##java -jar JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar -p 1008 &
##http://jrebel.yanjiayu.cn:9001/
##wget https://terwer.oss-cn-qingdao.aliyuncs.com/active/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar
ENTRYPOINT ["java","-jar", "/opt/JrebelBrainsLicenseServerforJava-1.0-SNAPSHOT-jar-with-dependencies.jar","-p","800"]