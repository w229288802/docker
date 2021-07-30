##### 1.打包trojan

```bash
docker build -t trojan .
```

##### 2.运行docker

```bash
docker run -d -p 1080:1080 --name trojan trojan
```



