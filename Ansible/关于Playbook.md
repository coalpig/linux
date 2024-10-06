# 关于Playbook

**Playbook**（剧本） 是 **Ansible** 指令的集合，其利用 YAML 语言编写，自上而下按顺序一次执行。

如果Ansible模块是你的车间的工具，那playbook则是你的指导手册，你的主机清单(inventory)是你的原材料。

play的主要功能在于将事先归并为一组的主机装扮成事先通过ansible中的task定义好的角色。从根本上来讲所谓task无非是调用ansible的一个module。将多个play组织在一个playbook中即可以让它们联同起来按事先编排的机制同唱一台大戏。其主要有以下四部分构成:

- Target section： 定义将要执行 playbook 的远程主机组
- Variable section： 定义 playbook 运行时需要使用的变量
- Task section： 定义将要在远程主机上执行的任务列表
- Handler section： 定义 task 执行完成以后需要调用的任务

## Playbook 示例

> centos7 环境

开始书写我们第一个playbook

**第一步：** 定义我们得主机清单

```
[web]
192.168.77.129 ansible_ssh_pass=123456
192.168.77.130 ansible_ssh_pass=123456
```

> 注：这里如果做了ssh免密码登陆，可以去掉ansible_ssh_pass

**第二步：** 明确playbook做哪些任务

web组的主机完成下列任务

1. 远程执行用户为root
2. 安装httpd
3. apache配置文件实现自定义http端口和客户端连接数
4. 在配置文件变更的时候，重启httpd
5. 启动httpd，并设置其开机自启动

**第三步：** 书写playbook

> playbook 使用 YAML 标记语言 (see [[YAML Syntax]]) (中文[YAML语法](YAML语法.md)) 来描述任务的编排

```
---
- hosts: web                 # Target section
  remote_user: root
  vars:                      # Variable section
    http_port: 80
    max_clients: 200
  tasks:                     # Task section
  - name: ensure apache is at the latest version
    yum:
      name: httpd
      state: latest
  - name: write the apache config file
    template:
      src: httpd.j2
      dest: /etc/httpd/conf/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running
    service:
      name: httpd
      state: started
  handlers:                 # Handler section
    - name: restart apache
      service:
        name: httpd
        state: restarted
```

> `remote_user` `vars` 等等这些都是ansible的playbook对象的关键字, 全部可用的关键字列表见 [Ansible关键字](Ansible关键字.md)

当前目录下的 `httpd.j2` 文件内容

```
ServerRoot "/etc/httpd"
Listen {{ http_port }}

Include conf.modules.d/*.conf

User apache
Group apache

ServerAdmin root@localhost

<Directory />
    AllowOverride none
    Require all denied
</Directory>

DocumentRoot "/var/www/html"

<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>

<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog "logs/error_log"
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8
<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>

<IfModule mpm_prefork_module>
    ServerLimit        256
    StartServers         5
    MinSpareServers      5
    MaxSpareServers     10
    MaxClients          {{ max_clients }}
    MaxRequestsPerChild  0
</IfModule>

EnableSendfile on
IncludeOptional conf.d/*.conf
```

题外：一个playbook文件可以拥有多个play, 比如我们在加一个`databases`组的数据库安装操作

```
---
- hosts: webservers
  remote_user: root

  tasks:
  - name: ensure apache is at the latest version
    yum:
      name: httpd
      state: latest
  - name: write the apache config file
    template:
      src: httpd.j2
      dest: /etc/httpd/conf/httpd.conf

- hosts: databases
  remote_user: root

  tasks:
  - name: ensure postgresql is at the latest version
    yum:
      name: postgresql
      state: latest
  - name: ensure that postgresql is started
    service:
      name: postgresql
      state: started
```

**第四步：** 运行playbok

```
ansible-playbook -i hosts test.yml
```

注：还有一种运行方式

在yml文件头部加入

```
#!/bin/env ansible-playbook
```

在给yml文件执行权限

```
chmod +x t.yml
```

运行playbook

```
./t.yml
```

## 主机和用户

对于每个playbok的play,都会有一个主机和远程用户来确定哪些主机为目标

```
---
- hosts: webservers
  remote_user: root
```

`hosts` 定义了主机清单的`patterns` 来确定哪些主机为执行目标。`remote_user`指定执行目标主机的执行用户。

`remote_user` 也可以为每个`task`设置

```
---
- hosts: webservers
  remote_user: root
  tasks:
    - name: test connection
      ping:
      remote_user: yourname
```

如果你想要为执行提升权限，可以设置`become`提权参数

```
---
- hosts: webservers
  remote_user: yourname
  become: yes
```

当然，你也可以为每个`task`设置

```
---
- hosts: webservers
  remote_user: yourname
  tasks:
    - service:
        name: nginx
        state: started
      become: yes
      become_user: root
      become_method: sudo
```

become 相关参数

- `become`是否开启提权
- `become_method` 指定提升方式
- `become_user` 指定提升用户
- `become_flags` 提权命令的参数

### 主机的执行顺序

```
---
- name: exec order
  hosts: all
  order: sorted
  gather_facts: False
  tasks:
    - debug:
        var: inventory_hostname
```

> `play` 也可以加上`name`来标识名称, `gather_facts` 定义不获取主机fact数据

`order` 参数可以控制主机的 **运行顺序**， 默认是`inventory` 按主机清单的从上到下顺序依次执行，其他的可选值如下表：

| 可选值            | 说明                                     |
| :---------------- | :--------------------------------------- |
| inventory         | 默认值，按主机清单的从上到下顺序依次执行 |
| reverse_inventory | 按主机清单的从下到上顺序依次执行         |
| sorted            | 以主机名称按字母顺序排序                 |
| reverse_sorted    | 以主机名称按字母顺序反序排序             |
| shuffle           | 随机排序                                 |

## 任务列表

每个play包含一组任务列表， 任务之间是按照从上往下顺序执行的，执行完上一个任务再去执行下一个任务。

运行从上到下运行的剧本时，任务失败的主机将从整个剧本的轮换中删除。 如果失败，只需更正剧本文件并重新运行即可。

每个任务(task)的目标是执行带有特定参数的模块。 变量可以在模块的参数中使用。

模块应该是幂等的，也就是说，在一个序列中多次运行一个模块应该与只运行它一次具有相同的效果。实现幂等性的一种方法是让一个模块检查它所期望的最终状态是否已经实现，如果已经实现，则退出而不执行任何操作。如果playbook使用的所有模块都是幂等的，那么playbook本身可能也是幂等的，所以重新运行playbook应该是安全的。

每个任务都应该有一个名称(names)，它包含在运行剧本的输出中。这是人类可读的输出，因此提供每个任务步骤的良好描述非常有用。但是，如果没有提供名称，那么将使用提供给 ‘action’ 的字符串作为输出。

任务示例

```
tasks:
  - name: make sure apache is running
    service:
      name: httpd
      state: started
```

也可以使用`key=value`的形式表示模块参数

```
tasks:
  - name: make sure apache is running
    service: name=httpd state=started
```

`command`和`shell`模块只有一组参数，可以直接写在模块后面

```
tasks:
  - name: enable selinux
    command: /sbin/setenforce 1
  - name: run this command and ignore the result
    shell: /usr/bin/somecommand || /bin/true
```

如果想忽略模块的执行错误，可以为模块添加`ignore_errors`

```
tasks:
  - name: run this command and ignore the result
    shell: /usr/bin/somecommand
    ignore_errors: True
```

如果行太长了，可以换行缩进表示

```
tasks:
  - name: Copy ansible inventory file to client
    copy: src=/etc/ansible/hosts dest=/etc/ansible/hosts
            owner=root group=root mode=0644
```

也可以使用变量`vhost`

```
tasks:
  - name: create a virtual host file for {{ vhost }}
    template:
      src: somefile.j2
      dest: /etc/httpd/conf.d/{{ vhost }}
```

task还有一种古老的标记方法，不建议使用这类形式来标记任务。

```
action: template src=templates/foo.j2 dest=/etc/foo.conf
```

## 事件处理Handlers

这些`notify`动作在play中每个任务块结束时触发，并且即使由多个不同的任务通知，也只会触发一次。

```
- name: template configuration file
  template:
    src: template.j2
    dest: /etc/foo.conf
  notify:
     - restart memcached
     - restart apache
```

> `notify` 定义的时handlers里的任务名称列表

Handlers 也是任务列表，与常规任务没有什么不同，它们由全局惟一的名称引用，并由`notify`动作通知。如果没有通知处理程序，它将不会运行。不管有多少任务通知一个处理程序，它都将只运行一次，即在一个特定`play`中的所有任务完成之后。

```
handlers:
  - name: restart memcached
    service:
      name: memcached
      state: restarted
  - name: restart apache
    service:
      name: apache
      state: restarted
```

Handlers 里的任务名称 **不能使用** 变量

在 ansible 2.2之后，handlers 支持`listen` 来实现监听一个通知程序来实现执行多个通知任务。

```
handlers:
    - name: restart memcached
      service:
        name: memcached
        state: restarted
      listen: "restart web services"
    - name: restart apache
      service:
        name: apache
        state: restarted
      listen: "restart web services"

tasks:
    - name: restart everything
      command: echo "this task will restart the web services"
      notify: "restart web services"
```

## 执行 Playbook

使用`ansible-playbook`命令执行`playbook`

```
ansible-playbook playbook.yml -f 10
```

在执行playbook前，可以做些检查

1. 检查palybook语法

```
ansible-playbook -i hosts httpd.yml --syntax-check
```

1. 列出要执行的主机

```
ansible-playbook -i hosts httpd.yml --list-hosts
```

1. 列出要执行得任务

```
ansible-playbook -i hosts httpd.yml --list-tasks
```

也可以使用`ansible-lint` 命令进行详细检查playbook文件

```
ansible-lint httpd.yml
```

[关于 Ansible Lint](关于%20Ansible%20Lint.md)页面描述了每一个错误信息。

### playbook执行顺序

一个playbook的内容，是按照下列表依次执行的

1. Variable loading 变量加载
2. Fact gatherin 是否获取fact数据
3. The pre_tasks execution 执行pre_tasks任务
4. Handlers notified from the pre_tasks execution 执行pre_tasks任务里的事件通知
5. Roles execution 执行roles角色
6. Tasks execution 执行tasks任务
7. Handlers notified from roles or tasks execution 执行tasks任务里的事件通知
8. The post_tasks execution 执行post_tasks任务
9. Handlers notified from post_tasks execution 执行post_tasks任务里的事件通知