# mkdir /etc/docker    #没启动docker之前没有该目录
# vim /etc/docker/daemon.json    #如果不存在则创建
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
https://blog.csdn.net/lbw520/article/details/108746617
### 1、关闭防火墙：
systemctl stop firewalld
systemctl disable firewalld
### 2、关闭selinux：
sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0
### 3、关闭swap：
swapoff -a  #临时
sed -ri 's/.*swap.*/#&/' /etc/fstab  #永久关闭
### 4、将桥接的IPv4流量传递到iptables的链
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

## 5、添加阿里云YUM的软件源
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

### 安装kubeadm，kubelet和kubectl
yum install -y kubelet kubeadm kubectl

### 部署Kubernetes Master
systemctl enable kubelet && systemctl restart kubelet

kubeadm reset
rm -rf $HOME/.kube
kubeadm init --image-repository registry.aliyuncs.com/google_containers

### 使用kubectl工具
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/kubelet.conf

### 安装calico网络
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml
