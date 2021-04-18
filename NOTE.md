#### 1、volume和bind mount
bind mount映射的文件夹内容会覆盖docker里，volume则相反
#### 2、docker-compose换行写法
environments:
  - PATH=/java/bin: \
    /hadoop/hbin
    