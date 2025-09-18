#!/usr/bin/expect -f 
 set timeout -1 
 spawn scp -r /opt/mall-finance-1.0.0-SNAPSHOT.jar appuser@10.199.209.120:/home/appuser/wc-mall/mall-finance/source/ 
 expect { 
 *(yes/no)? {send yes\r} 
 *password: {send 4^W%Bnmu\r} 
 } 
 expect eof
