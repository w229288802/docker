if [ ${ETCD_HOST} ];then
sed "s/127.0.0.1/${ETCD_HOST}/g" ~/cframe/opt/apiserver/config.toml > ~/cframe/opt/apiserver/config-new.toml
sed -i "s/2379/${ETCD_PORT}/g" ~/cframe/opt/apiserver/config-new.toml
sed -i "s/12345/${APISERVER_PORT}/g" ~/cframe/opt/apiserver/config-new.toml
sed -i "s/log\/apiserver.log/${APISERVER_LOG}/g" ~/cframe/opt/apiserver/config-new.toml

sed "s/127.0.0.1/${ETCD_HOST}/g" ~/cframe/opt/controller/config.toml > ~/cframe/opt/controller/config-new.toml
sed -i "s/2379/${ETCD_PORT}/g" ~/cframe/opt/controller/config-new.toml
sed -i "s/12345/${APISERVER_PORT}/g" ~/cframe/opt/controller/config-new.toml
sed -i "s/58422/${LISTEN_PORT}/g" ~/cframe/opt/controller/config-new.toml
sed -i "s/controller.log/${CONTROLLER_LOG}/g" ~/cframe/opt/controller/config-new.toml

else

sed "s/127.0.0.1/${CONTROLLER_HOST}/g" ~/cframe/opt/edge/config.toml > ~/cframe/opt/edge/config-new.toml
echo >> ~/cframe/opt/edge/config-new.toml
echo listen_addr="\":${EDGE_PORT}\"" >> ~/cframe/opt/edge/config-new.toml
sed -i "s/58422/${LISTEN_PORT}/g" ~/cframe/opt/edge/config-new.toml
sed -i "s/cn-wg-uat-145/${EDGE_NAME}/g" ~/cframe/opt/edge/config-new.toml

fi

if [ ${ETCD_HOST} ];then
echo '==============================apiserver配置==================================='
cat ~/cframe/opt/apiserver/config-new.toml
echo
echo '==============================controller配置==================================='
cat ~/cframe/opt/controller/config-new.toml
echo
chmod +x ~/cframe/opt/apiserver/apiserver
chmod +x ~/cframe/opt/controller/controller
nohup ~/cframe/opt/apiserver/apiserver -c ~/cframe/opt/apiserver/config-new.toml &
~/cframe/opt/controller/controller -c ~/cframe/opt/controller/config-new.toml
else
echo '==============================edge配置==================================='
cat ~/cframe/opt/edge/config-new.toml
echo '==============================添加CIDR==================================='
curl "http://${CONTROLLER_HOST}:${APISERVER_PORT}/api-service/v1/edge/add" -X "POST" -d "{\"name\": \"${EDGE_NAME}\", \"hostaddr\": \"${EDGE_IP}:${EDGE_PORT}\", \"cidr\": \"${EDGE_CIDR}\"}" -H "Content-Type: application/json"
echo
echo '==============================启动EDGE==================================='
chmod +x ~/cframe/opt/edge/edge
if [ ! -d ~/cframe/opt/edge/log ]; then
        mkdir ~/cframe/opt/edge/log
fi
kill -9 $(ps -ef | grep edge | grep -v grep | awk '{print $2}') 2>/dev/null
cd ~/cframe/opt/edge
nohup ./edge -c ~/cframe/opt/edge/config-new.toml  &>/dev/null  &
fi