#!/bin/bash
wget https://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo
mv cloudera-cdh5.repo /etc/yum.repos.d/
yum install -y yum-utils createrepo
reposync -r cloudera-cdh5
