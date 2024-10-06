---
tags:
  - CICD/Jenkins
---

- ~ Jenkins从gitlab拉取代码

> [!info]- Jenkins与Gitlab通讯流程
> 
> 
> 开发人员将自己的公钥上传到gitlab的账户的SSH Key中
> 
> 因为Jenkins需要拉取所有代码，所以Gitlab中有一种专门的Deplay key可以用来作为部署服务器的公钥存放。
> 
> ![img](../images/1719749761532-c0898ad1-be99-4101-a424-288f6ce16872.png)
> 

> [!info]- Gitlab配置部署公钥
> 
> 
> 2.1 Jenkins服务器生成公钥
> 
> ```bash
> ssh-keygen
> cat .ssh/id_rsa.pub
> ```
> 
> 2.2 Gitlab添加Deploy Key
> 
> 点击项目 --> Settings --> Repository --> Deploy keys
> 
> ![img](../images/1719749979555-d37fa471-285e-477d-81a3-da9d6ae87eae.png)
> 
> 添加部署公钥
> 
> ![img](../images/1719750032023-7c49359b-5d64-420d-906e-0de62f9940c5.png)
> 
> 查看结果
> 
> ![img](../images/1719750111827-6dcb38b4-d400-4d92-ad1f-078a24d3517d.png)
> 

> [!info]- Jenkins拉取代码测试
> 
> 
> 3.1 jenkins服务器手动拉取代码测试
> 
> 在jenkins服务器上执行git克隆命令
> 
> ```bash
> [root@jenkins-201 ~]# git clone git@10.0.0.200:root/kaoshi.git
> Cloning into 'kaoshi'...
> remote: Enumerating objects: 1115, done.
> remote: Counting objects: 100% (78/78), done.
> remote: Compressing objects: 100% (66/66), done.
> remote: Total 1115 (delta 33), reused 24 (delta 7), pack-reused 1037
> Receiving objects: 100% (1115/1115), 5.37 MiB | 0 bytes/s, done.
> Resolving deltas: 100% (191/191), done.
> ```
> 
> 3.2 jenkins使用git插件拉取代码
> 
> 注意，需要安装git插件
> 
> ![img](../images/1719750947505-9d21c478-274a-4be9-8d38-10110471fd68.png)
> 
> ![img](../images/1719750511815-43e86f6a-9b07-45f7-997d-4351b81ef0d4.png)
> 
> git源码管理，注意拉取分支要输入main而不是master！
> 
> ![img](../images/1719750693977-59934c5f-5c82-470b-afbc-3aeefa13437f.png)
> 
> ![img](../images/1719750766949-adf71e53-636b-4659-97e7-80a1052804a5.png)
> 
> 查看拉取代码结果:
> 
> ![img](../images/1719750808143-2b95ee96-278a-42c8-8c93-a0faa2db2dcb.png)
> 

Gitlab代码提交自动触发Jnekins构建任务

新版本待测试
