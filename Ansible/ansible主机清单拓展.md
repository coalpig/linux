>主机内置变量列表

**用于主机连接**

|参数|描述|
|---|---|
|ansible_connection|与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.|

**用于所有连接**

|参数|描述|
|---|---|
|ansible_host|将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.|
|ansible_port|连接端口号，如果是ssh的话，默认是22|
|ansible_user|用于连接认证的用户名|
|ansible_password|用于连接认证的用户名密码|

**ssh连接参数**

|参数|描述|
|---|---|
|ansible_ssh_private_key_file|ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.|
|ansible_ssh_common_args|此设置附加到sftp，scp和ssh的缺省命令行|
|ansible_sftp_extra_args|此设置附加到默认sftp命令行。|
|ansible_scp_extra_args|此设置附加到默认scp命令行。|
|ansible_ssh_extra_args|此设置附加到默认ssh命令行。|
|ansible_ssh_pipelining|确定是否使用SSH管道。这可以覆盖ansible.cfg中得设置。|
|ansible_ssh_executable|ssh可执行文件|

**权限提升参数**

| 参数                      | 描述                                                            |
| ----------------------- | ------------------------------------------------------------- |
| ansible_become          | 开启提权，等同于```ansible_sudo```，```ansible_su```                   |
| ansible_become_method   | 提权方式                                                          |
| ansible_become_user     | 提权用户，等同于```ansible_sudo_user```，```ansible_su_user```         |
| ansible_become_password | 提权密码,等同于```ansible_sudo_password```，```ansible_su_password``` |
| ansible_become_exe      | 提权所用的可执行文件，等同于```ansible_sudo_exe```,```ansible_su_exe```     |
| ansible_become_flags    | 提权命令的参数，等同于```ansible_sudo_flags```,```ansible_su_flags```    |

**远程主机环境参数**

|参数|描述|
|---|---|
|ansible_shell_type|目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.|
|ansible_python_interpreter|目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如 *BSD, 或者 /usr/bin/python|
|ansible_*_interpreter|这里的"*"可以是 ruby 或 perl 或其他语言的解释器，作用和ansible_python_interpreter 类似|
|ansible_shell_executable|这将设置ansible控制器将在目标机器上使用的shell，覆盖ansible.cfg中的配置，默认为/bin/sh。|

**非SSH连接类型参数**

ansible默认是使用 ```ssh``` 连接主机，但也不限制于这种方式，可以通过使用主机特定参数 ```ansible_connection = <connector>```，来更改连接类型。以下是支持的连接类型。

| 参数                        | 描述                                |
| ------------------------- | --------------------------------- |
| local                     | 在控制端本地执行                          |
| docker                    | 使用本地Docker客户端                     |
| ansible_host              | 容器连接的主机                           |
| ansible_port              | 容器连接的端口                           |
| ansible_become            | 如果设置为true，则会使用begin_user在容器内进行操作。 |
| ansible_docker_extra_args | Docker 的额外参数                      |


一个创建容器的小例子

```
- name: create jenkins container
  docker_container:
    docker_host: myserver.net:4243
    name: my_jenkins
    image: jenkins

- name: add container to inventory
  add_host:
    name: my_jenkins
    ansible_connection: docker
    ansible_docker_extra_args: "--tlsverify --tlscacert=/path/to/ca.pem --tlscert=/path/to/client-cert.pem --tlskey=/path/to/client-key.pem -H=tcp://myserver.net:4243"
    ansible_user: jenkins
  changed_when: false

- name: create directory for ssh keys
  delegate_to: my_jenkins
  file:
    path: "/var/jenkins_home/.ssh/jupiter"
    state: directory
```

在运行的时候增加主机

使用 ```add_host``` 模块动态添加运行主机，此类主机只有在运行时才会向内存中添加，运行结束后，也不会添加到静态主机清单文件中。

```
- name: add new node into runtime inventory
  add_host:
    hostname: webserver
    groups: web
​    ansible_host: 192.168.77.129
    ansible_port: 22
```

限定主机清单的运行主机

使用```--limit hostname```可以在运行任务的时候，只允许在此主机上运行，就是只想一台机器执行，节省时间
因为有时候主机清单写了多台机器

```
[root@master ansible]# ansible-playbook test.yml --list-hosts
 playbook: test.yml
  play #1 (test2): test2        TAGS: []
​    pattern: [u'test2']
​    hosts (3):
​      node1
​      node3
​      node2
[root@master ansible]# ansible-playbook test.yml --list-hosts --limit node3,node2
playbook: test.yml
  play #1 (test2): test2        TAGS: []
​    pattern: [u'test2']
​    hosts (2):
​      node3
​      node2
```

连接本地主机

不需要在主机清单里定义，直接使用 ```localhost``` 或 ```127.0.0.1``` 就可以连接本地了

```
# ansible localhost -m ping
localhost | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

# ansible 127.0.0.1 -m ping
127.0.0.1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

使用别名连接主机

**定义主机清单**

```
cat /etc/ansible/hosts

alias_host ansible_host=192.168.77.131 ansible_port=22 ansible_user=root ansible_password=123456 # 指定别名，定义主机ssh连接信息
```

**测试连通性**

```
ansible alias_host -m ping alias_host
```


使用 跳板机 连接主机

> 通过 192.168.77.132 连接192.168.77.131， 192.168.77.132 需安装nc

**添加132节点到kown_hosts**

```
# ssh 192.168.77.132
The authenticity of host '192.168.77.132 (192.168.77.132)' can't be established.
ECDSA key fingerprint is SHA256:2lWSIJMF9r8hnfLwlKONY07eQCeZaDVZ/xWZizr9wqs.
ECDSA key fingerprint is MD5:be:82:d9:23:45:18:f2:e3:fa:32:56:65:c9:b1:4b:07.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.77.132' (ECDSA) to the list of known hosts.
```

1. 使用ssh代理参数配置

**定义主机清单**

```
cat /etc/ansible/hosts
192.168.77.131 ansible_ssh_private_key_file=/root/131.key ansible_ssh_common_args="-o ProxyCommand=\"sshpass -p '123456' ssh -qay -p 22 root@192.168.77.132 'nc %h %p'\""
```

> ansible_ssh_common_args 配置ssh连接的参数

**测试连通性**

```
ansible 192.168.77.131 -m ping 192.168.77.131 
```

1. 使用本地ssh配置主机代理

**配置ssh**

```
# cat ~/.ssh/config 
Host 192.168.77.131
        User root
        Port 22
        TCPKeepAlive yes
        ForwardAgent yes
        ProxyCommand sshpass -p '123456' ssh -qaY -p 22 root@192.168.77.132 'nc %h %p'
```

**定义主机清单**

```
# cat /etc/ansible/hosts
192.168.77.131 ansible_ssh_private_key_file=/opt/131.key
```

**测试连通性**

```
# ansible 192.168.77.131 -m ping
192.168.77.131 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
```

1. 使用ssh代理

> 不需要在192.168.77.132上安装nc软件了

**定义主机清单**

```
# cat /etc/ansible/hosts
192.168.77.131 ansible_ssh_private_key_file=/root/131.key ansible_ssh_common_args="-o ProxyCommand=\"sshpass -p '123456' ssh -W %h:%p -q -p 22 root@192.168.77.132\""
```

> ansible_ssh_common_args 配置ssh连接的参数

**测试连通性**

```
# ansible 192.168.77.131 -m ping
192.168.77.131 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
```

命令行指定主机清单

```
# ansible -i '192.168.77.131,192.168.77.132' 192.168.77.* -m ping -k
SSH password: 
192.168.77.131 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
192.168.77.132 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
```

通过 ```-i``` 参数， 指定用逗号分隔的主机列表即可。

不过不能指定`ansible_*`开头的变量，即不能定义连接密码。

动态主机清单

ansible 不仅可以使用```yaml```,```ini```等格式的静态文件配置主机清单，还可以使用动态的源作为主机清单，详细内容请见 [使用动态主机](https://ansible.leops.cn/advanced/dynamic-hosts)
