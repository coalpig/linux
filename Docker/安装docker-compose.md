新版本docker内置了compose，一般不用安装

方法1:直接yum安装-版本比较老

```
yum install docker-compose
```

方法2:使用官方脚本安装

```
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

