**密钥对的逻辑**

- 逻辑就是生成一个密钥对，这个密钥对不管在哪个机器只要能生成就可以
- 这个密钥对包含着私钥和公钥
- 有私钥的服务器去连接有公钥的服务器

**开启远程主机秘钥认证**

```
#被ansible管理的机器操作
#一般用vim  /etc/ssh/sshd_config
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

systemctl restart sshd
```

**配置远程主机秘钥**

```
#所有机器都可以生成
ssh-keygen -t rsa -P '' -b 4096 -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  #将公钥写入被管理机器的.ssh目录
chmod 600 ~/.ssh/authorized_keys
```

**将刚刚生成的私钥 `~/.ssh/id_rsa` 拷贝到 ansible 节点**

```
mv id_rsa /opt/131.key
chmod 600 /opt/131.key
```

**定义主机清单**

在主机清单中定义ansible连接机器使用什么密钥连接

```
cat /etc/ansible/hosts 192.168.77.131 ansible_ssh_private_key_file=/opt/131.key
```

> 不指定 `ansible_user` 则使用运行ansible命令的用户


如果 `private_key` 使用了 **passphrase** ，可使用下列命令，将密码保存在 ssh-agent 中。

```
ssh-agent bash 
ssh-add /opt/131.key
```

**测试连通性**

```
ansible 192.168.77.131 -m ping 192.168.77.131 | SUCCESS => {     "ansible_facts": {         "discovered_interpreter_python": "/usr/bin/python"     },      "changed": false,      "ping": "pong" }`
```
