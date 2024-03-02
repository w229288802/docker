#!/bin/sh
array=($(curl -s https://raw.fastgit.org/freefq/free/master/v2 | base64 -d |grep trojan | sed 's/.*\/\(.*\)@\(.*\):\(.*\)#\(.*\)/\2,\3,\1/g'))
for i in ${array[@]}; do
  echo $i
done
a=(${array[3]})
echo "====连接到===="
echo $a
arr=(${a//,/ })
arr=("us1.trojan-lite.com" "443" "DkRC9bbcEqBfqs4NQg")
sed -i "s/@password/${arr[2]}/g" ./config.json
sed -i "s/@host/${arr[0]}/g" ./config.json
sed -i "s/@port/${arr[1]}/g" ./config.json