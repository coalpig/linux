# 1.安装部署harbor

实施方案：

方案1：Harbor本身也是运行在k8s里的

方案2：Harbor独立运行在k8s之外的

注意：

1.新版本的harbor部署比较麻烦，需要节点和系统都需要拷贝证书

2.Docker还要信任harbor的地址

步骤：

```
#1.下载地址
https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-offline-installer-v2.10.0.tgz

#2.解压安装
tar zxf harbor-offline-installer-v2.10.0.tgz

#3.生成证书
https://goharbor.io/docs/2.10.0/install-config/

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=abc/OU=Personal/CN=abc.com" \
 -key ca.key \
 -out ca.crt
 
openssl genrsa -out abc.com.key 4096
openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=abc/OU=Personal/CN=abc.com" \
    -key abc.com.key \
    -out abc.com.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=abc.com
DNS.2=abc
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in abc.com.csr \
    -out abc.com.crt
	
#4.给harbor复制证书
mkdir /data/cert/ -p
cp abc.com.crt /data/cert/
cp abc.com.key /data/cert/

#5.给docker复制证书
openssl x509 -inform PEM -in abc.com.crt -out abc.com.cert
mkdir -p /etc/docker/certs.d/abc.com/
cp abc.com.cert /etc/docker/certs.d/abc.com/
cp abc.com.key /etc/docker/certs.d/abc.com/
cp ca.crt /etc/docker/certs.d/abc.com/
cp /etc/docker/certs.d/abc.com/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

#6.重启docker
systemctl restart docker

#7.配置harbor
vim /opt/harbor/harbor.yml
hostname: abc.com

https:
  port: 443
  certificate: /data/cert/abc.com.crt
  private_key: /data/cert/abc.com.key

harbor_admin_password: Harbor12345

#8.安装harbor
./prepare
./install.sh
docker compose ps

#9.在harbor的web页面上创建仓库
base
app

#10.修改镜像标签
docker tag openjdk:8 abc.com/base/openjdk:8

#11.推送镜像
docker push abc.com/base/openjdk:8
```

