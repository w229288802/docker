#### 1、volume和bind mount

bind mount映射的文件夹内容会覆盖docker里，volume则相反

#### 2、docker-compose换行写法
```yaml
environments:

  - PATH=/java/bin: \
    /hadoop/bin
```

#### 3 、git自动转换换行符
```bash
git config --global core.autocrlf false
```

#### 4、ARG参数
在Dockerfile的CMD命令中不能替换

