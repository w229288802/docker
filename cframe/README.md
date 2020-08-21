# controller 开放端口
0.0.0.0/0 UDP:58423
0.0.0.0/0 TCP:58422
0.0.0.0/0 TCP:12345 apiserver
127.0.0.1 TCP:2379 etcd

# edge 开放端口
0.0.0.0/0 UDP:58423

export NODE1=0.0.0.0
docker run -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --name etcd quay.io/coreos/etcd:latest \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://${NODE1}:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://${NODE1}:2379 \
  --initial-cluster node1=http://${NODE1}:2380

docker build -t cframe:latest .
docker-compose up -d controller

export EDGE_NAME=aliyun &&
export EDGE_IP=47.98.175.80 &&
export EDGE_PORT=58423 &&
export EDGE_CIDR=172.16.0.0/16 &&
export CONTROLLER_HOST=119.45.191.75 &&
export LISTEN_PORT=58422 &&
export APISERVER_PORT=12345 &&
cd ~/cframe/opt &&chmod +x run.sh &&./run.sh

export EDGE_NAME=qcloud &&
export EDGE_IP=119.45.191.75 &&
export EDGE_PORT=58423 &&
export EDGE_CIDR=10.206.0.0/16 &&
export CONTROLLER_HOST=119.45.191.75 &&
export LISTEN_PORT=58422 &&
export APISERVER_PORT=12345 &&
cd ~/cframe/opt &&chmod +x run.sh &&./run.sh


export EDGE_NAME=ctyun &&
export EDGE_IP=117.88.44.56 &&
export EDGE_PORT=58423 &&
export EDGE_CIDR=172.31.0.0/16 &&
export CONTROLLER_HOST=119.45.191.75 &&
export LISTEN_PORT=58422 &&
export APISERVER_PORT=12345 &&
cd ~/cframe/opt &&chmod +x run.sh &&./run.sh

172.16.185.130	aliyun
10.206.0.12	qcloud
172.31.0.10	ctyun

##旧方法

cd ~/cframe/apiserver && nohup ./apiserver -c config.toml &
cd  ~/cframe/controller && nohup ./controller -c config.toml &
cd  ~/cframe/edge && nohup ./edge -c config.toml &


curl "http://127.0.0.1:12345/api-service/v1/edge/add" -X "POST" -d '{"name": "aliyun", "hostaddr": "47.98.175.80:58423", "cidr": "172.16.0.0/16"}' -H "Content-Type: application/json"
curl "http://127.0.0.1:12345/api-service/v1/edge/add" -X "POST" -d '{"name": "qcloud", "hostaddr": "119.45.191.75:58423", "cidr": "10.206.0.0/16"}' -H "Content-Type: application/json"
curl "http://127.0.0.1:12345/api-service/v1/edge/add" -X "POST" -d '{"name": "ctyun", "hostaddr": "117.88.44.56:58423", "cidr": "172.31.0.0/16"}' -H "Content-Type: application/json"
curl "http://119.45.191.75:12345/api-service/v1/edge/list"


47.98.175.80(公)
172.16.185.130（私有

119.45.191.75（公）
10.206.0.12（内)

172.31.0.10(内)
117.88.44.56(公)

/usr/share/nginx/html/index.html