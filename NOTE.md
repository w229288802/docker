#### 1、volume和bind mount
bind mount映射的文件夹内容会覆盖docker里，volume则相反
#### 2、docker-compose换行写法
environments:
  - PATH=/java/bin: \
    /hadoop/hbin
# git自动转换换行符
git config --global core.autocrlf false
# ARG参数
在Dockerfile的CMD命令中不能替换