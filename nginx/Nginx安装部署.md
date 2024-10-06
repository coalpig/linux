---
tags:
  - Nginx
---

> [!install]- Nginx资源
> 
> 
> Nginx源码
> 
> [📎nginx-1.26.0.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1716700535906-46268f52-14f1-4325-b41d-5c218e33255a.gz)
> 
>  Nginx RPM包
> 
> [📎nginx-1.26.0-1.el7.ngx.x86_64.rpm](https://www.yuque.com/attachments/yuque/0/2024/rpm/830385/1716700184785-b5b21096-ad98-4793-9926-0d3ed0a4c9d1.rpm)
> [📎pcre2-10.23-2.el7.x86_64.rpm](https://www.yuque.com/attachments/yuque/0/2024/rpm/830385/1716700212740-3f86785a-1863-4369-9939-a908fe8cb814.rpm)
> 
> 游戏代码
> 
> [📎sjm.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1716370835002-334af0b1-cb3f-4e08-86a4-e293d6fc157b.gz)
> 
> [📎2048.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1716370835011-29a545fa-4cde-4134-b9de-e89d2cfe78c4.gz)
> 

> [!info]- Nginx分为几种
> 
> 
> 1.源码编译-适合老鸟
> 
> 版本随意
> 
> 安装复杂
> 
> 升级繁琐
> 
> 
> 2.epel仓库-魔改版本-不推荐
> 
> 版本较低
> 
> 安装简单
> 
> 配置不易读
> 
> 
> 3.官方仓库-官方原血-推荐
> 
> 版本较新
> 
> 安装简单
> 
> 配置易读

> [!install]- 编译安装方法
> 
> 
> 
> >官方文档
> 
> http://nginx.org/en/docs/configure.html
> 
> >创建www用户
> 
> ```shell
> groupadd www -g 1000
> useradd www -s /sbin/nologin -M -u 1000 -g 1000
> id www
> ```
> 
> >安装编译餐宿的依赖包
> 
> ```shell
>  yum install openssl-devel pcre-devel -y
> ```
> 
> >下载解压软件包
> 
> ```shell
> mkdir /data/soft -p
> cd /data/soft/
> wget http://nginx.org/download/nginx-1.16.0.tar.gz
> tar zxvf nginx-1.16.0.tar.gz
> ```
> 
> >配置编译参数
> 参数可以参考官网的建议
> 比如要指定配置文件的位置等等
> ```shell
> cd /data/soft/nginx-1.16.0/
> ./configure --help
> ./configure --user=www --group=www --prefix=/opt/nginx-1.16.0 --with-http_stub_status_module --with-http_ssl_module --with-pcre
> ```
> 
> >编译安装
> 
> ```shell
> cd /data/soft/nginx-1.16.0/
> make && make install
> ```
> 
> >创建软链接
> 
> ```shell
> ln -s /opt/nginx-1.16.0/ /opt/nginx
> ls -lh /opt/
> ```
> 
> >检查语法
> 
> ```shell
> [root@web-7 /opt/nginx]# /opt/nginx/sbin/nginx -t
>  nginx: the configuration file /opt/nginx-1.16.0//conf/nginx.conf syntax is ok
>  nginx: configuration file /opt/nginx-1.16.0//conf/nginx.conf test is successful
> 
> ```
> >启动nginx
> 
> ```shell
>  /opt/nginx/sbin/nginx
> ```
> 
> >检查测试
> 
> ```shell
> [root@web-7 /opt/nginx]# netstat -lntup|grep nginx
>  tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      12828/nginx: master 
>  [root@web-7 /opt/nginx]# curl 10.0.0.7
> ```
> 

> [!install]- YUM安装方法
> 
> 
> >安装依赖包
> 
> ```shell
>  yum install openssl-devel pcre-devel -y
> ```
> 
> >配置官方yum源
> 
> ```shell
> cat > /etc/yum.repos.d/nginx.repo << 'EOF'
> [nginx-stable]
> name=nginx stable repo
> baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=1
> gpgkey=https://nginx.org/keys/nginx_signing.key
>  
> [nginx-mainline]
> name=nginx mainline repo
> baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
> gpgcheck=1
> enabled=0
> gpgkey=https://nginx.org/keys/nginx_signing.key
> EOF
> 
> ```
> 
> >安装nginx服务
> 
> ```shell
> yum install nginx -y
> ```
> 
> >启动服务并配置开机自启动
> 
> ```shell
> [root@web-7 ~]# nginx -t
> nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
> nginx: configuration file /etc/nginx/nginx.conf test is successful
> [root@web-7 ~]# systemctl start nginx
> [root@web-7 ~]# systemctl enable nginx
> ```
> 
> >测试访问 
> 
> ```
>  curl 10.0.0.7
> ```

> [!systemd]- Nginx启动方式说明
> 
> 
> >编译安装启动管理方式
> 
> ```shell
> nginx -t
> nginx
> nginx -s reload
> nginx -s stop
> ```
> 
> >yum安装启动管理方法
> 
> ```shell 
> nginx -t
> systemctl start nginx
> systemctl reload nginx
> systemctl restart nginx
> systemctl stop  nginx
> ```



