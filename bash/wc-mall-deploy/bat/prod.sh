#!/bin/bash
#docker cp scp.sh deploy:/opt/scp.sh

#service=mall-ca
#branch=feature-seal-wwj-20220809

#service=mall-finance
#branch=feature-bank-serial-match-wwj-20220812

#service=mall-finance
#branch=feature-finance-write-off-wwj-20220815

#service=mall-finance
#branch=feature-bill-wwj-20220809

#service=mall-deliver
#branch=feature-order-deliver-batch-download-wwj-20220816

service=mall-finance
branch=xxxxxx

declare -A map
#map['mall-gateway']='10.199.209.51'
map['mall-order']='10.199.144.79'
map['mall-ca']='10.199.144.79'
map['mall-deliver']='10.199.144.79'

map['mall-goods']='10.199.144.80'

map['mall-base']='10.199.144.80'
map['mall-user']='10.199.144.80'
map['mall-contract']='10.199.144.80'
map['mall-manage']='10.199.144.80'
map['mall-finance']='10.199.144.79'
map['mall-youzan']='10.199.144.79'
#map['mall-workflow']='10.199.201.194'

password=uMPlj9fwQu1025
./main.sh $service master $branch ${map[$service]} ${password}
