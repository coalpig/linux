# 第0章 Jenkins介绍

jenkins是一个开源的持续集成工具，由java语言开发
jenkins是一个调度平台，拥有众多的插件，绝大部分功能都是由插件来完成的

# 第1章 Jenkins安装

## 1.官方网站

https://www.jenkins.io/zh/doc/

## 2.安装部署

截止到2024年6月26日，目前Jenkins的最新版是2.464

而最新版的jenkins需要JDK 17，需要注意版本对应

jdk-17_linux-x64_bin.rpm

jenkins-2.464-1.1.noarch.rpm

```bash
#安装依赖，不然启动会报错
[root@jenkins-201 ~]# yum install fontconfig -y

#下载并安装jdk-17
[root@jenkins-201 ~]# wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm
[root@jenkins-201 ~]# rpm -ivh jdk-17_linux-x64_bin.rpm

#下载并安装jenkins
[root@jenkins-201 ~]# wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/redhat/jenkins-2.464-1.1.noarch.rpm
[root@jenkins-201 ~]# rpm -ivh /jenkins-2.452-1.1.noarch.rpm
```

## 3.目录文件说明

```bash
[root@jenkins-201 ~]# rpm -ql jenkins
/usr/bin/jenkins												 #启动命令
/usr/lib/systemd/system/jenkins.service  #启动配置文件
/usr/lib/tmpfiles.d/jenkins.conf  			 #配置文件
/usr/share/java/jenkins.war 			       #启动war包
/usr/share/jenkins/migrate 
/var/cache/jenkins
/var/lib/jenkins 									       #数据目录
```

## 4.修改启动配置以使用root账户运行

```bash
[root@jenkins-201 ~]# vim /usr/lib/systemd/system/jenkins.service
User=root
Group=root
```

## 5.启动jenkins

```bash
[root@jenkins-201 ~]# systemctl daemon-reload
[root@jenkins-201 ~]# systemctl start jenkins
```

## 6.解锁Jenkins

登陆地址为：http://10.0.0.201:8080/

![img](./attachments/1717318638877-64b0c6e8-5230-40a2-a4d9-dde1a0328365.webp)

## 7.修改admin密码

![img](./attachments/1719369217502-86f2fe40-74b1-48fc-8bd7-1ef721bfad8c.png)

## 8.安装常用插件

jenkins具有丰富的插件，我们可以在插件管理里去选择常用的插件，这里推荐的插件列表如下：

```bash
Git
Git Parameter
Pipeline
Pipeline: Stage View
Blue Ocean
Generic Webhook Trigger
Role-based Authorization Strategy
Nexus Artifact Uploader
Active Choices
Localization: Chinese (Simplified)
Maven Artifact ChoiceListProvider (Nexus)
```

![img](./attachments/1719369330385-34a08b05-2d1d-4871-bd30-4cc27c6b324c.png)

![img](./attachments/1719369722303-c5853d1b-9453-4640-a6f6-4de850776fdd.png)

![img](./attachments/1719369949882-aa739ea0-55ad-48a9-811f-7d10b6488660.png)

插件安装完成后可以直接重启jenkins，再次来到登陆页面发现已经变成中文了。

![img](./attachments/1719370360177-1db88f6d-edbb-4b4f-9357-b7cc7529afa9.png)

## 9.使用离线安装插件

在线下载的时间可能会比较长，我们也可以将插件提前下好后打个压缩包，以后要用的时候直接解压到jenkins对应的插件目录即可

[📎jenkins_2464_plugin.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719649967354-58d3e0cd-2823-4a7a-adf9-6a14659c092e.gz)

打包命令:

```plain
cd /var/lib/jenkins/
tar zcf jenkins_2464_plugin.tar.gz plugins
```

解压命令:

```plain
tar zxf jenkins_2464_plugin.tar.gz -C /var/lib/jenkins/
systemctl restart jenkins
```

# 第2章 Jenkins系统管理

## x.用户权限管理

### 用户权限角色规划

| **用户**          | **角色**          | **项目**                                           | **权限**               |
| ----------------- | ----------------- | -------------------------------------------------- | ---------------------- |
| jenkins_user_dev  | jenkins_role_dev  | mall-service_DEV                                   | 可查看，可运行         |
| jenkins_user_test | jenkins_role_test | mall-service_TEST                                  | 可查看，可运行         |
| jenkins_user_ops  | jenkins_role_ops  | mall-service_DEVmall-service_TESTmall-service_PROD | 可查看，可运行，可修改 |

### 创建项目

mall-service_DEV

mall-service_TEST

mall-service_PROD

![img](./attachments/1719488936517-db79f561-3f68-45dc-bc72-642e443b6170.png)

### 创建用户

jenkins_user_dev

jenkins_user_test

jenkins_user_ops

![img](./attachments/1719485909860-b8660e4a-9004-40df-84dd-7420a525e145.png)

![img](./attachments/1719489111374-74093243-e29a-42bd-98b0-f2489de0c4e9.png)

### 启用权限插件

![img](./attachments/1719486066881-442959e3-5392-47a3-9a6e-0ab0262cb1c1.png)

![img](./attachments/1719486120387-a7faf37d-ec29-481d-835a-dda637473046.png)

![img](./attachments/1719486245807-95681789-c125-4007-83c4-c5ce822c0150.png)

### 创建角色

#### 创建Global roles

![img](./attachments/1719489780722-025e580a-d149-43d3-a0e0-d974a3bd33c5.png)

#### 创建Item roles

![img](./attachments/1719489554622-7c0ee121-6329-4e6e-b210-277a3e38ac93.png)

### 授权角色

![img](./attachments/1719489904029-11b1e8ef-1df5-4869-9ac4-6cca3335d5af.png)

### 验证权限

#### jenkins_user_dev用户测试

![img](./attachments/1719489925441-4233416a-ab8d-46d3-8716-943fddd3f458.png)

![img](./attachments/1719490081338-315c854b-cc48-40c0-94cc-05e3323219db.png)

![img](./attachments/1719490097638-21be06eb-b8db-42f1-ba85-f3d3e2cc319b.png)



#### jenkins_user_test用户测试

![img](./attachments/1719490028456-4b3c3688-780a-4853-8b26-1ee5828cd56e.png)

![img](./attachments/1719490042781-ba3512c9-f7f1-4930-87ae-450a135cd1dc.png)

#### jenkins_user_ops用户测试

![img](./attachments/1719490139724-258e3130-8cdd-4fdd-9823-f7c6e41ee6e4.png)

![img](./attachments/1719490127495-d88e73ee-0e86-4fc2-90e7-3ae367411f67.png)

![img](./attachments/1719490162473-9f3a0ecb-fbb5-4d28-ae84-08badb9bfeab.png)

![img](./attachments/1719490182418-9f687f45-f470-4b0a-a2f2-aec87e3a8d06.png)

![img](./attachments/1719490198984-1dc9eaca-d022-4b74-8bda-26fe82291f6f.png)



## x.节点管理



# 第2章 构建自由风格的项目

## 1.创建新任务

![img](./attachments/1719485004777-9f4da4c0-30f9-4a31-9236-1d7aaf2a83dd.png)



![img](./attachments/1719370893030-bf75e4c4-eaa4-4b67-b443-76fdc77aec12.png)

## 2.添加构建步骤

![img](./attachments/1719371033237-42e3e939-db17-4f3f-b551-ef74419c546d.png)

![img](./attachments/1719371168440-e929bd6a-11cb-47de-bc81-38cdce481d47.png)

## 3.点击立即构建

![img](./attachments/1719371188607-5e0f8c91-e29c-4cf2-81cd-bbc3f741c0f0.png)

## 4.查看控制台输出

![img](./attachments/1719371214467-9800ffcf-bbed-448e-a494-06166a47fb0b.png)

![img](./attachments/1719371296010-c888313e-791b-4c4f-a9cf-118343c27671.png)

# 第3章 发布gitlab中的静态页面项目

## 1.gitlab导入工程

这是一个h5小游戏的项目，项目地址：

https://gitee.com/skips/game.git

使用gitlab直接导入项目：

![img](./attachments/1717318639885-c8b37b3f-48ad-4fde-b6d0-6dfeaa892217.webp)

![img](./attachments/1717318640087-30dc7f64-2ddc-4fed-a399-de9be51be282.webp)

![img](./attachments/1717318640245-b1a56831-d9cf-4962-9ccf-6b692462d445.webp)

![img](./attachments/1717318640248-73696662-9cf4-4e52-a202-908cdd8ba1ec.webp)

![img](./attachments/1717318640288-3a62fabf-29c5-45fc-a95e-aeabee175ee9.webp)

## 2.在jenkins中关联gitlab的h5game项目

### 2.1 创建新项目

![img](./attachments/1717318640530-cc02bd8c-1412-4c5f-a102-37f37b09d465.webp)

![img](./attachments/1717318640688-8afd2231-c03b-42b3-a0d4-09bfed0217f8.webp)

### 2.2 填写仓库地址

选择源码管理，然后填写gitlab仓库信息，但是我们发现报错了，因为jenkins没有拉取gitlab项目的权限。

![img](./attachments/1717318640688-8bb1371c-663f-4d9e-8063-827f923f0589.webp)

## 3.配置jenkins访问gitlab的权限

### 3.1 部署公钥解释和步骤

解释

1.如果我们想让jenkins从gitlab上拉取代码，那么需要将jenkins的公钥信息放在gitlab上。
2.gitlab针对这种情况有一个专门的功能，叫做部署部署公钥。
3.部署公钥的作用是不需要创建虚拟用户和组，直接在需要拉取的项目里关联部署公钥即可。

步骤

1.获取jenkins公钥信息
2.将jenkins公钥信息填写到gitlab的部署公钥里
3.由项目管理员操作，在需要jenkins拉取的项目里关联部署公钥
4.jenkins配置私钥凭证，部署项目时关联凭证

### 3.2 获取jenkins服务器的SSH公钥信息

```bash
[root@jenkins-201 ~]# cat .ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCg8+DQFOjR+gl1Xw83CIyGJ50vI4DBeTaMRFdu5+5pT/IMnYq1iS7/lRS6JxXLYvVeNMDUfDxA1sOL70okyA3npjASXgJPGE1FsbpqzWjsN0TAGoZkR1VWuP9Yn0CrH7dA4lhZQfUUVjvqzFBZK8N9iZMzIu6KOiSY/aD4Ol59vbDS4kO0rTG1DYQNnjZzMPNlIiJ+0EVkfuYRwABRFA8fmL+6btqZqhjGY29EHuIfzIMTDTysrtCTGxQn2ql1zwjReGiNXzmFncwvyy92DAuMbnOQiE1YNn72wThy2oWSHsCwKdIvcNHqY2xBvFnkZ9Ltga7PgR33kbJ7Gl8tjiZF root@jenkins-201
```

### 3.3 gitlab添加部署公钥

![img](./attachments/1717318640786-2f6d624a-6671-470d-a637-035924b1b3cf.webp)

![img](./attachments/1717318640981-84308c57-42b7-412e-9bcf-b098df3301cb.webp)

![img](./attachments/1717318641140-0a1d6882-b6e1-4630-b7db-f7aea895b2be.webp)

### 3.4 gitlab项目关联部署公钥

![img](./attachments/1717318641154-ef55064b-7e31-4f53-a14c-324f32d99152.webp)

![img](./attachments/1717318641225-36289908-0c36-46ed-99ac-d07d1769b8ad.webp)

![img](./attachments/1717318641280-01f9e71f-e6c6-4234-8d82-94dd7d259d84.webp)

### 3.5 jenkins配置私钥凭证

![img](./attachments/1717318641413-f3c4c549-af48-495a-927a-9ec665076cfe.webp)

![img](./attachments/1717318641543-7385e012-adb2-4863-b976-10ea986ee46b.webp)

![img](./attachments/1717318641551-3b4ed9a3-6275-419c-85c2-76df6b38778c.webp)

### 3.6 测试获取代码

![img](./attachments/1717318641719-447cd5dd-66ff-4393-8c37-40e4b2ce89f9.webp)

![img](./attachments/1717318641912-bf872bdd-107f-471f-a8a1-de67ff09473b.webp)

![img](./attachments/1717318641868-8c3df262-7850-4dd3-9d84-e74297505041.webp)

查看拉取的代码：

```plain
[root@jenkins-201 ~]# ll /var/lib/jenkins/workspace/h5game
总用量 16
drwxr-xr-x 4 jenkins jenkins   47 8月   6 09:37 game
-rw-r--r-- 1 jenkins jenkins 9349 8月   6 09:37 LICENSE
-rw-r--r-- 1 jenkins jenkins  937 8月   6 09:37 README.md
```

## 4.编写部署脚本

```plain
#创建目录
mkdir -p /scripts/jenkins/

#编写脚本
cat > /scripts/jenkins/deploy.sh << 'EOF'
#!/bin/bash

PATH_CODE=/var/lib/jenkins/workspace/h5game/
PATH_WEB=/usr/share/nginx
TIME=$(date +%Y%m%d-%H%M)
IP=10.0.0.7

#打包代码
cd ${PATH_CODE} 
tar zcf /opt/${TIME}-web.tar.gz ./*

#拷贝打包好的代码发送到web服务器代码目录
ssh ${IP} "mkdir ${PATH_WEB}/${TIME}-web -p"
scp /opt/${TIME}-web.tar.gz ${IP}:${PATH_WEB}/${TIME}-web

#web服务器解压代码
ssh ${IP} "cd ${PATH_WEB}/${TIME}-web && tar xf ${TIME}-web.tar.gz && rm -rf ${TIME}-web.tar.gz"
ssh ${IP} "cd ${PATH_WEB} && rm -rf html && ln -s ${TIME}-web html"
EOF

#添加可执行权限
chmod +x /scripts/jenkins/deploy.sh
```

也可以使用jenkins内置的变量来代替自定义变量，查看jenkins内置变量的地址如下：

http://10.0.0.201:8080/env-vars.html

## 4.jenkins调用构建脚本

在构建的位置填写执行shell脚本的命令

![img](./attachments/1717318642001-6c0dcd8a-2bad-4104-a57f-3c2f2a80c0d8.webp)

然后立即构建，发现报错了，提示权限不足：

![img](./attachments/1717318641989-87bbb5fb-88a3-41ff-9689-a8e3b6ef17b9.webp)

报错原因是因为jenkins是以jenkins用户运行的，所以提示权限不足，我们可以修改jenkins为root用户运行。

```plain
[root@jenkins-201 ~]# vim /etc/sysconfig/jenkins 
[root@jenkins-201 ~]# grep "USER" /etc/sysconfig/jenkins 
JENKINS_USER="root"
[root@jenkins-201 ~]# systemctl restart jenkins
```

重启好之后我们重新构建一下：

![img](./attachments/1717318642229-0eccd6c4-4dfe-441b-98ae-890c682a95c1.webp)

查看一下web服务器的代码目录

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
drwxr-xr-x 3 root root 50 8月   6 10:13 20200806-1013-web
lrwxrwxrwx 1 root root 17 8月   6 10:13 html -> 20200806-1013-web
```

# 第4章 监听gitlab自动触发构建

## 1.jenkins项目里添加构建触发器

![img](./attachments/1717318642381-c880ef64-6bfb-408c-b079-b3e5f24405c9.webp)

## 2.gitlab添加webhook

将刚才jenkins里配置的token和URL地址复制进去

![img](./attachments/1717318642407-a043ef2a-ae86-4e20-8f95-9c3596d08cb0.webp)

较新版本的gitlab此时点击添加会提示报错：

![img](./attachments/1717318642453-f82be7b6-4a5d-4c8e-891b-4f16f6e82dc7.webp)

解决方法：进入admin area区域，然后点击setting-->network进行设置

![img](./attachments/1717318642527-50bd72e2-6ab9-49a2-a611-7e00ce22d279.webp)

正常添加成功之后，会在下方出现测试的选项

![img](./attachments/1717318642701-006eeda0-20ae-4208-ad29-af38b17ffd83.webp)

选择push事件来测试是否可以正常出发，如果可以，会在页面上方显示200状态码

![img](./attachments/1717318642782-439579b5-3b00-434b-818c-6a2ccee66185.webp)

此时我们去查看jenkins项目页面，就会发现以及出发了来自gitlab的构建任务

![img](./attachments/1717318642928-e83131e4-d06e-4946-9954-01826f8756fb.webp)

# 第5章 返回构建状态给gitlab

## 1.gitlab生成access token

![img](./attachments/1717318642952-e893ebe6-5080-4cc0-9fce-fa5283ac1037.webp)

点击创建之后会生成一串token,注意及时保存，因为刷新就没有了

![img](./attachments/1717318642987-292a6083-4514-4eb5-9d74-ff10eeaf69aa.webp)

## 2.jenkins配置gitlab的token

点击jenkins的系统管理-->系统设置，然后找到gitlab选项

![img](./attachments/1717318643189-cae0247e-30e9-482f-9b90-d9103e233225.webp)

填写gitlab的信息：

![img](./attachments/1717318643123-d63ad4e5-51c8-48a5-97e1-644d2d4eac87.webp)

点击添加后返回上一层页面，然后选中刚才添加的gitlab凭证

![img](./attachments/1717318643479-d1eaa673-27db-4cb6-abb5-a715533875a2.webp)

## 3.设置项目构建后将结果通知给gitlab

![img](./attachments/1717318643487-3e1caa23-9b18-47b8-b35b-816fe082ff58.webp)

## 4.合并分支然后检查gitlab能否收到消息

![img](./attachments/1717318643471-52600b7c-0057-480b-92a0-b1f603ad957d.webp)

## 5.防止重复构建

jenkins具有很多内置变量，点击项目-->构建--> 查看 可用的环境变量列表

http://10.0.0.201:8080/env-vars.html/

这里我们使用两个变量，一个是此次提交的commit的hash，另一个是上一次提交成功的commit的hash

我们可以在部署脚本里添加一行判断，如果这两个变量一样，那么就不用再次提交了

这些变量不需要在脚本里定义，直接引用即可

![img](./attachments/1717318643677-f586dd5f-9d21-4c74-b65d-08f20ecfa7de.webp)

# 第6章 tag方式发布版本

## 1.给代码打标签

首先我们先给代码打上标签，然后提交2个版本

v1.0版本：修改代码，然后发布v1.0版本

```plain
git commit -am 'v1.0'
git tag -a v1.0 -m "v1.0 稳定版"
git push -u origin v1.0
git tag
```

v2.0版本：修改代码，然后发布v2.0版本

```plain
git commit -am 'v2.0'
git tag -a v2.0 -m "v2.0 稳定版"
git push -u origin v2.0
git tag
```

## 2.gitlab查看标签

此时gitlab上可以看到2个标签

![img](./attachments/1717318643690-b81d05c0-3908-4665-97ba-222e2ca2872b.webp)

点进去之后可以看到具体标签名称

![img](./attachments/1717318643890-ca9dc08e-52b7-441f-8211-4a77166d4ab6.webp)

## 3.jenkins配置参数化构建

jenkins上我们新建一个参数化构建项目

![img](./attachments/1717318643842-17329fe9-9f1e-4ab0-bcda-fd8a2a669656.webp)

然后配置git的标签参数:

![img](./attachments/1717318643890-991cae2d-7c0e-486b-be49-ae221e930caa.webp)

最后还需要配置一下git仓库地址,注意需要修改拉取的版本的变量为 $git_version

![img](./attachments/1717318644101-07352525-ad0e-4e04-b855-8efb7e82a530.webp)

此时点击项目的build with parameters就会看到对应的版本号：

![img](./attachments/1717318644042-1b631c5b-a897-4648-a33f-c2cbe8343e81.webp)

然后去jenkins工作目录下查看是否拉取了对应版本:

/var/lib/jenkins/workspace/my-deploy-rollback

## 4.优化部署脚本

```plain
cat >/scripts/jenkins/deploy_rollback.sh<<'EOF'
#!/bin/bash

PATH_CODE=/var/lib/jenkins/workspace/my-deploy-rollback/
PATH_WEB=/usr/share/nginx
IP=10.0.0.7

#打包代码
cd ${PATH_CODE} 
tar zcf /opt/web-${git_version}.tar.gz ./*

#拷贝打包好的代码发送到web服务器代码目录
ssh ${IP} "mkdir ${PATH_WEB}/web-${git_version} -p"
scp /opt/web-${git_version}.tar.gz ${IP}:${PATH_WEB}/web-${git_version}

#web服务器解压代码
ssh ${IP} "cd ${PATH_WEB}/web-${git_version} && tar xf web-${git_version}.tar.gz && rm -rf web-${git_version}.tar.gz"
ssh ${IP} "cd ${PATH_WEB} && rm -rf html && ln -s web-${git_version} html"
EOF
```

## 5.jenkins添加执行脚本动作并测试

![img](./attachments/1717318644316-a65d4911-40fd-433e-b07f-65a7930ae76e.webp)

## 6.测试发布

![img](./attachments/1717318644350-c45de85d-db2b-4518-8000-9840500b2d41.webp)

然后去web服务器上查看发现已经发布了

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
lrwxrwxrwx 1 root root  8 8月   6 15:59 html -> web-v2.0
drwxr-xr-x 3 root root 68 8月   6 15:59 web-v2.0
```

# 第7章 tag方式回滚版本

## 1.jenkins配置回滚选项参数

在工程配置里添加选项参数:

![img](./attachments/1717318644274-b7455566-3393-4c33-ab06-e36ad16a4e20.webp)

在参数化构建里添加2个选项：发布和回滚

![img](./attachments/1717318644429-691ecc68-456e-4ddf-8ce2-1c86f0190c84.webp)

此时查看构建页面就会发现多了选项卡:

![img](./attachments/1717318644516-f85ad653-71c6-4c06-8bf2-41d4d49f4dd6.webp)

## 2.修改发布脚本增加条件判断

```plain
cat >/scripts/jenkins/deploy_rollback.sh <<'EOF'
#!/bin/bash

PATH_CODE=/var/lib/jenkins/workspace/my-deploy-rollback/
PATH_WEB=/usr/share/nginx
IP=10.0.0.7

#打包代码
code_tar(){
        cd ${PATH_CODE} 
        tar zcf /opt/web-${git_version}.tar.gz ./*
}

#拷贝打包好的代码发送到web服务器代码目录
code_scp(){
        ssh ${IP} "mkdir ${PATH_WEB}/web-${git_version} -p"
        scp /opt/web-${git_version}.tar.gz ${IP}:${PATH_WEB}/web-${git_version}
}

#web服务器解压代码
code_xf(){
        ssh ${IP} "cd ${PATH_WEB}/web-${git_version} && tar xf web-${git_version}.tar.gz && rm -rf web-${git_version}.tar.gz"
}

#创建代码软链接
code_ln(){
        ssh ${IP} "cd ${PATH_WEB} && rm -rf html && ln -s web-${git_version} html"
}

main(){
        code_tar
        code_scp
        code_xf
        code_ln
}

#选择发布还是回滚
if [ "${deploy_env}" == "deploy" ]
then
        ssh ${IP} "ls ${PATH_WEB}/web-${git_version}" >/dev/null 2>&1
        if [ $? == 0 -a ${GIT_COMMIT} == ${GIT_PREVIOUS_SUCCESSFUL_COMMIT} ] 
        then
                echo "web-${git_version} 已部署,不允许重复构建"
                exit
        else 
                main
        fi
elif [ "${deploy_env}" == "rollback" ]
then
        code_ln
fi
EOF
```

## 3.测试回滚功能

部署v1.0版本

![img](./attachments/1717318644749-15d65680-4277-46aa-afef-094160a7d13a.webp)

部署v2.0版本：

![img](./attachments/1717318644819-73d9b671-7ef6-4a3e-9228-4d669af02cd7.webp)

检查web服务器当前的版本

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
lrwxrwxrwx 1 root root  8 8月   6 16:52 html -> web-v2.0
drwxr-xr-x 3 root root 68 8月   6 16:51 web-v1.0
drwxr-xr-x 3 root root 68 8月   6 16:52 web-v2.0
```

然后我们选择v1.0版本并且选择回滚操作：

![img](./attachments/1717318644855-4b724d87-5a9c-429a-bae9-c51626e36702.webp)

查看控制台显示回滚成功：

![img](./attachments/1717318644835-b1562d91-97cb-4fc7-a8a1-8746343053d9.webp)

在web服务器上查看发现已经回滚成功：

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
lrwxrwxrwx 1 root root  8 8月   6 16:56 html -> web-v1.0
drwxr-xr-x 3 root root 68 8月   6 16:51 web-v1.0
drwxr-xr-x 3 root root 68 8月   6 16:52 web-v2.0
```

## 4.发布新代码并打标签测试

修改代码并发布v3.0:

```plain
cd h5game/
echo v3.0 >> index.html
git commit -am 'v3.0'
git tag -a v3.0 -m 'v3.0 稳定版'       
git push -u origin v3.0
git tag
```

jenkins查看并发布3.0版本:

web服务器查看发布情况：

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
lrwxrwxrwx 1 root root  8 8月   6 16:58 html -> web-v3.0
drwxr-xr-x 3 root root 68 8月   6 16:51 web-v1.0
drwxr-xr-x 3 root root 68 8月   6 16:52 web-v2.0
drwxr-xr-x 3 root root 68 8月   6 16:58 web-v3.0
```

然后工程选择回滚到v2.0版本:

![img](./attachments/1717318644860-2235075b-f01a-4174-8db0-f4c0ec45db76.webp)

再次在web服务器上查看:

```plain
[root@web-7 ~]# ll /usr/share/nginx/
总用量 0
lrwxrwxrwx 1 root root  8 8月   6 16:59 html -> web-v2.0
drwxr-xr-x 3 root root 68 8月   6 16:51 web-v1.0
drwxr-xr-x 3 root root 68 8月   6 16:52 web-v2.0
drwxr-xr-x 3 root root 68 8月   6 16:58 web-v3.0
```