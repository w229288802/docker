#!/bin/bash
#docker cp scp.sh deploy:/opt/scp.sh

service=$1
branch=$2

declare -A map
#map['mall-gateway']='10.199.209.51'
map['mall-order']='10.199.201.196'
map['mall-ca']='10.199.201.196'
map['mall-deliver']='10.199.201.196'
map['mall-youzan']='10.199.201.196'
map['mall-data']='10.199.201.196'

map['mall-goods']='10.199.201.195'
map['mall-invoice']='10.199.201.195'
map['mall-voucher']='10.199.201.195'


map['mall-base']='10.199.201.194'
map['mall-user']='10.199.201.194'
map['mall-manage']='10.199.201.194'
map['mall-finance']='10.199.201.194'
map['mall-workflow']='10.199.201.194'
map['mall-contract']='10.199.201.194'


if [ "${map[$service]}" == '' ];then
  echo "${service} 没有配置"
  exit -1
fi

password=Yhxx#0814
./main.sh $service test $branch ${map[$service]} ${password} $3
