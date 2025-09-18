#service=mall-ca
#branch=feature-seal-onfile-remove-template-wwj-20221209
#branch=feature-seal-add-project-name-wwj-20221014
#branch=feature-seal-wwj-20220809
#branch=feature-seal-onfile-20220908
#branch=feature-seal-add-comment-wwj-20221009
#branch=feature-seal-encrypt-wwj-20221103

#service=mall-deliver
#branch=feature-order-deliver-batch-download-wwj-20220816
#branch=feature-order-deliver-batch-download-wwj-20220816
#service=mall-finance
#branch=feature-fssc-improvement-wwj-20221202

#service=mall-finance
#branch=feature-fin-account-over-wwj-20230222
#branch=feature-fin-account-query-wwj-20221214
#branch=feature-fin-settle-check-wwj-20230217
#branch=feature-project-account-wwj-20221201
#branch=hotfix-fin-fssc-noauto-wwj-20221206
#branch=hotfix-fin-account-stat-wwj-20221128
#branch=feature-fin-fssc-wwj-20221122
#branch=hotfix-fin-invoice-contract-wwj-20221111
#branch=feature-fin-account-stat-wwj-20221025
#branch=feature-voucher-entry-wwj-20221031
#branch=feature-youzan-voucher-20221009

#service=mall-order
#branch=develop
#branch=feature-youzan-voucher-20221009

#service=mall-youzan
#branch=feature-youzan-voucher-20221009

#service=mall-data
#branch=feature-fin-stat-wwj-20230317
#branch=feature-fin-warranty-wwj-20221223
#branch=feature-fin-fssc-wwj-20221122

branch=`git rev-parse --abbrev-ref HEAD`
read -p "服务名：mall-" service
service="mall-$service"

read -p "选择环境(1-dev,2-test,3-test和dev)：" env

index=0
#./dev.sh $service $branch $((index++))
if [ $env -eq 1 ];then
  ./dev.sh $service $branch $((index++))
elif [ $env -eq 2 ]; then
  ./test.sh $service $branch $((index++))
elif [ $env -eq 3 ]; then
  ./test.sh $service $branch $((index++)) #index=0 代表重新打包
  if [ $? -ne 0 ];then
      exit
  fi
  index=0
  ./dev.sh $service $branch $((index++))
fi
