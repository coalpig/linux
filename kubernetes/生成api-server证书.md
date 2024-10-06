```
第1章 创建CA证书
1.创建证书目录
mkdir /root/kubernetes/
cd /root/kubernetes/

2.创建CA配置文件
cat > /root/kubernetes/ca-config.json << 'EOF'
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
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

3.创建CA证书申请文件
cat > /root/kubernetes/ca-csr.json <<'EOF'
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Beijing",
      "ST": "Beijing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

4.生成CA证书和公私钥
cfssl gencert -initca ca-csr.json | cfssljson -bare ca –

第2章 创建API Server证书
1.创建API Server证书请求文件
cat > /root/kubernetes/server-csr.json << 'EOF'
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "192.168.100.1",
    "192.168.100.2",
    "10.0.0.10",	
    "10.0.0.14",
    "10.0.0.12",
    "10.0.0.13",
    "10.0.0.23",
    "10.0.0.24",
    "master-04",
    "master-02",
    "master-03",
    "node-03",
    "node-04",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Beijing",
      "ST": "Beijing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

2.创建API Server证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server

3.检查
[root@master-1 ~/kubernetes]# ll
总用量 36
-rw-r--r-- 1 root root  284 3月  23 11:31 ca-config.json
-rw-r--r-- 1 root root 1001 3月  23 11:31 ca.csr
-rw-r--r-- 1 root root  208 3月  23 11:31 ca-csr.json
-rw------- 1 root root 1675 3月  23 11:31 ca-key.pem
-rw-r--r-- 1 root root 1359 3月  23 11:31 ca.pem
-rw-r--r-- 1 root root 1358 3月  23 11:35 server.csr
-rw-r--r-- 1 root root  633 3月  23 11:35 server-csr.json		#定义了谁能连接到api server
-rw------- 1 root root 1679 3月  23 11:35 server-key.pem		#发送给需要连接api server的组件
-rw-r--r-- 1 root root 1724 3月  23 11:35 server.pem			#发送给需要连接api server的组件
```