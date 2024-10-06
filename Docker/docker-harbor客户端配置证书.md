新版本的harbor需要配置证书
harbor服务器scp发送到docker-21和22


```
ssh-keygen

ssh-copy-id
```

21和22 

```
mkdir /etc/docker/certs.d/abc.com/ -p
```

修改

```
vim /etc/hosts
```

docker-21
```
scp -r /etc/docker/certs.d 10.0.0.21:/etc/docker/
scp /etc/docker/certs.d/abc.com/ca.crt 10.0.0.21:/etc/pki/ca-trust/source/anchors/

update-ca-trust
```

docker-22
```
scp -r /etc/docker/certs.d 10.0.0.22:/etc/docker/
scp /etc/docker/certs.d/abc.com/ca.crt 10.0.0.22:/etc/pki/ca-trust/source/anchors/

update-ca-trust
```

docker-23
```
scp -r /etc/docker/certs.d 10.0.0.23:/etc/docker/
scp /etc/docker/certs.d/abc.com/ca.crt 10.0.0.23:/etc/pki/ca-trust/source/anchors/

update-ca-trust
```


docker 测试

```
docker pull abc.com/base/nginx
```


