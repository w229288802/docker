#!/usr/bin/env bash
mkdir /home/swap
#使用dd命令创建一个swap分区，在这里创建一个4G大小的分区
dd if=/dev/zero of=/home/swap/swapfile bs=1M count=2048
#格式化新建的分区文件
mkswap /home/swap/swapfile
#将新建的分区文件设为swap分区
swapon /home/swap/swapfile
#设置开机自动挂载swap分区
echo "/home/swap/swapfile swap swap defaults 0 0" >> /etc/fstab


swapoff -a