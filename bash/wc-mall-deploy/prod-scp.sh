#!/bin/bash

temp=`ls *.jar`
array=(${temp// /})

branch=xxx

declare -A map
#map['mall-gateway']='10.199.209.51'
map['mall-order']='10.199.144.79'
map['mall-ca']='10.199.144.79'
map['mall-deliver']='10.199.144.79'

map['mall-goods']='10.199.144.80'

map['mall-base']='10.199.144.80'
map['mall-user']='10.199.144.80'
map['mall-manage']='10.199.144.80'
map['mall-finance']='10.199.144.79'
#map['mall-workflow']='10.199.201.194'

password=uMPlj9fwQu0426

for var in ${array[@]}
do
  service=`echo $var | sed -E 's/(mall-\w+).*/\1/g'`
  ./main.sh $service master $branch ${map[$service]} ${password} 1
done