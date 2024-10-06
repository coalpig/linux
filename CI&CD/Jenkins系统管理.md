---
tags:
  - CICD/Jenkins
---
 
> [!info]- 插件管理
> 
> 
> 在线安装
> 
> jenkins具有丰富的插件，我们可以在插件管理里去选择常用的插件，这里推荐的插件列表如下：
> 
> ```bash
> Git
> Git Parameter
> Pipeline
> Pipeline: Stage View
> Blue Ocean
> Generic Webhook Trigger
> Role-based Authorization Strategy
> Nexus Artifact Uploader
> Active Choices
> Localization: Chinese (Simplified)
> Maven Artifact ChoiceListProvider (Nexus)
> ```
> 
> ![img](../images/1719369330385-34a08b05-2d1d-4871-bd30-4cc27c6b324c.png)
> 
> ![img](../images/1719369722303-c5853d1b-9453-4640-a6f6-4de850776fdd.png)
> 
> ![img](../images/1719369949882-aa739ea0-55ad-48a9-811f-7d10b6488660.png)
> 
> 插件安装完成后可以直接重启jenkins，再次来到登陆页面发现已经变成中文了。
> 
> ![img](../images/1719370360177-1db88f6d-edbb-4b4f-9357-b7cc7529afa9.png)
> 

> [!info]- 离线安装
> 
> 在线下载的时间可能会比较长，我们也可以将插件提前下好后打个压缩包，以后要用的时候直接解压到jenkins对应的插件目录即可
> 
> [📎jenkins_plugin_20240630.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719748700209-ecd9db57-ca63-469e-a555-2dc26b2251a9.gz)
> 
> 打包命令:
> 
> ```plain
> cd /var/lib/jenkins/
> tar zcf jenkins_2464_plugin.tar.gz plugins
> ```
> 
> 解压命令:
> 
> ```plain
> tar zxf jenkins_2464_plugin.tar.gz -C /var/lib/jenkins/
> systemctl restart jenkins
> ```

> [!info]- 权限角色管理
> 
> 
> 1.角色规划
> 
> | **用户**          | **角色**          | **项目**                                           | **权限**               |
> | ----------------- | ----------------- | -------------------------------------------------- | ---------------------- |
> | jenkins_user_dev  | jenkins_role_dev  | mall-service_DEV                                   | 可查看，可运行         |
> | jenkins_user_test | jenkins_role_test | mall-service_TEST                                  | 可查看，可运行         |
> | jenkins_user_ops  | jenkins_role_ops  | mall-service_DEVmall-service_TESTmall-service_PROD | 可查看，可运行，可修改 |
> 
> 2.创建项目
> 
> mall-service_DEV
> 
> mall-service_TEST
> 
> mall-service_PROD
> 
> ![img](../images/1719488936517-db79f561-3f68-45dc-bc72-642e443b6170.png)
> 
> 3.创建用户
> 
> jenkins_user_dev
> 
> jenkins_user_test
> 
> jenkins_user_ops
> 
> ![img](../images/1719485909860-b8660e4a-9004-40df-84dd-7420a525e145.png)
> 
> ![img](../images/1719489111374-74093243-e29a-42bd-98b0-f2489de0c4e9.png)
> 
> 4.启用权限插件
> 
> ![img](../images/1719486066881-442959e3-5392-47a3-9a6e-0ab0262cb1c1.png)
> 
> ![img](../images/1719486120387-a7faf37d-ec29-481d-835a-dda637473046.png)
> 
> ![img](../images/1719486245807-95681789-c125-4007-83c4-c5ce822c0150.png)
> 
> 5.创建角色
> 
> 5.1 创建Global roles
> 
> ![img](../images/1719489780722-025e580a-d149-43d3-a0e0-d974a3bd33c5.png)
> 
> 5.2 创建Item roles
> 
> ![img](../images/1719489554622-7c0ee121-6329-4e6e-b210-277a3e38ac93.png)
> 
> 6.授权角色
> 
> ![img](../images/1719489904029-11b1e8ef-1df5-4869-9ac4-6cca3335d5af.png)
> 
> 7.验证权限
> 
> 7.1 jenkins_user_dev用户测试
> 
> ![img](../images/1719489925441-4233416a-ab8d-46d3-8716-943fddd3f458.png)
> 
> ![img](../images/1719490081338-315c854b-cc48-40c0-94cc-05e3323219db.png)
> 
> ![img](../images/1719490097638-21be06eb-b8db-42f1-ba85-f3d3e2cc319b.png)
> 
> 7.2 jenkins_user_test用户测试
> 
> ![img](../images/1719490028456-4b3c3688-780a-4853-8b26-1ee5828cd56e.png)
> 
> ![img](../images/1719490042781-ba3512c9-f7f1-4930-87ae-450a135cd1dc.png)
> 
> 7.3 jenkins_user_ops用户测试
> 
> ![img](../images/1719490139724-258e3130-8cdd-4fdd-9823-f7c6e41ee6e4.png)
> 
> ![img](../images/1719490127495-d88e73ee-0e86-4fc2-90e7-3ae367411f67.png)
> 
> ![img](../images/1719490162473-9f3a0ecb-fbb5-4d28-ae84-08badb9bfeab.png)
> 
> ![img](../images/1719490182418-9f687f45-f470-4b0a-a2f2-aec87e3a8d06.png)
> 
> ![img](../images/1719490198984-1dc9eaca-d022-4b74-8bda-26fe82291f6f.png)
> 

> [!info]- 数据备份
> 
> 
> 1.Jenins备份方式
> 
> Jenkins的备份非常简单，只需要将整个数据目录备份即可，可以结合定时任务定时备份
> 
> ```bash
> cd /var/lib/
> tar zcvf jenkins_backup_20240630.tr.gz jenkins
> ```
> 
> [📎jenkins_backup_20240630.tr.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719749116745-07e7ef2c-e3a5-41a1-b931-6a18883dce59.gz)
> 
> 2.Jenkins数据恢复
> 
> 只需要将备份文件恢复到数据目录即可
> 
> ```bash
> tar zxvf jenkins_backup_20240630.tr.gz -C /var/lib/
> ```
> 