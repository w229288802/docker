#service=mall-ca
#branch=feature-seal-onfile-remove-template-wwj-20221209
#branch=feature-seal-process-wwj-20221121
#branch=feature-seal-add-project-name-wwj-20221014
#branch=feature-seal-wwj-20220809
#branch=feature-seal-onfile-20220908
#branch=feature-seal-add-comment-wwj-20221009

#service=mall-deliver
#branch=feature-order-deliver-batch-download-wwj-20220816
#branch=feature-order-deliver-batch-download-wwj-20220816

#service=mall-order
#branch=develop
#branch=feature-youzan-voucher-20221009

#service=mall-data
#branch=feature-fin-data-wwj-20221121
#branch=hotfix-data-other-wwj-20221205

service=mall-finance
branch=hotfix-fin-account-wwj-20230327
#branch=feature-fin-fssc-receive-wwj-20230322
#branch=feature-all-improvement-wwj-20230207
#branch=feature-all-improvement-wwj-20230207
#branch=feature-seal-fromca-wwj-20230306
#branch=feature-fin-settle-check-wwj-20230217

#service=mall-data
#branch=feature-fin-stat-wwj-20230317
#branch=feature-fin-account-over-wwj-20230222
#branch=hotfix-contract-pre-wwj-20230310

#service=mall-manage
#branch=feature-user-add-idcard-wwj-20230209

index=0
./dev.sh $service $branch $((index++))
if [ $? -ne 0 ];then
    exit
fi
index=0 #是否要重新打包
./test.sh $service $branch $((index++))
