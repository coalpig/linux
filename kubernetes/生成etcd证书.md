```
生成证书--重点
只需要在master-1操作即可,生成后发送给其他节点就行了

第1章 安装生成证书工具
mkdir /soft && cd /soft
#wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
#wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
#wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64
mv cfssl_linux-amd64 /usr/local/bin/cfssl
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo

1.创建目录
mkdir /root/etcd
cd /root/etcd

2.CA证书配置文件
cat >/root/etcd/ca-config.json<<'EOF'
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "www": {
        "expiry": "87600h",
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ]
      }
    }
  }
}
EOF


3.创建CA证书请求文件
cat > /root/etcd/ca-csr.json << 'EOF'
{
  "CN": "etcd CA",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Beijing",
      "ST": "Beijing"
    }
  ]
}
EOF

4.创建ETCD证书请求文件
可以把所有的 master IP 加入到 csr 文件中
cat > /root/etcd/server-csr.json << 'EOF'
{
  "CN": "etcd",
  "hosts": [
    "master-04",
    "master-02",
    "master-03",
    "10.0.0.14",
    "10.0.0.12",
    "10.0.0.13",
    "10.0.0.10"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Beijing",
      "ST": "Beijing"
    }
  ]
}
EOF


5.生成ca证书
cd /root/etcd/
cfssl gencert -initca ca-csr.json | cfssljson -bare ca –

检查
[root@master-1 ~/etcd]# ll
总用量 24
-rw-r--r-- 1 root root  277 7月  23 17:47 ca-config.json
-rw-r--r-- 1 root root  956 7月  23 17:51 ca.csr
-rw-r--r-- 1 root root  165 7月  23 17:48 ca-csr.json
-rw------- 1 root root 1675 7月  23 17:51 ca-key.pem
-rw-r--r-- 1 root root 1265 7月  23 17:51 ca.pem
-rw-r--r-- 1 root root  290 7月  23 17:50 server-csr.json


6.生成etcd证书
cd /root/etcd/
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server


检查
[root@master-1 ~/etcd]# ll
总用量 36
-rw-r--r-- 1 root root  277 7月  23 17:47 ca-config.json			#ca证书的配置文件
-rw-r--r-- 1 root root  165 7月  23 17:48 ca-csr.json				#cs证书的请求文件
-rw------- 1 root root 1675 7月  23 17:51 ca-key.pem				#ca证书	
-rw-r--r-- 1 root root  956 7月  23 17:51 ca.csr					#ca请求文件证书
-rw-r--r-- 1 root root 1265 7月  23 17:51 ca.pem					#ca证书
-rw-r--r-- 1 root root 1054 7月  23 17:52 server.csr
-rw-r--r-- 1 root root  290 7月  23 17:50 server-csr.json			#定义了哪些主机可以连接到etcd
-rw------- 1 root root 1675 7月  23 17:52 server-key.pem			#给需要连接etcd的客户端的证书
-rw-r--r-- 1 root root 1379 7月  23 17:52 server.pem				#给需要连接etcd的客户端的证书
```