---
tags:
  - Tomcat
---
下载tar包
[📎apache-tomcat-9.0.86.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1716888301759-b3d724b5-50cf-4502-8d66-4f8860c1f84f.gz)

> [!run]- 解压Tomcat
> 
> 
> ```bash
> https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz
> tar zxf apache-tomcat-9.0.86.tar.gz -C /opt/
> mv /opt/apache-tomcat-9.0.86/ /opt/tomcat-9.0.86/
> ln -s /opt/tomcat-9.0.86 /opt/tomcat
> ```

> [!run]- 修改配置文件
> 
> 
> 关闭自动部署和自动解压
> 
> ```bash
> [root@web-7 ~]# cd /opt/tomcat
> [root@web-7 /opt/tomcat]# ls
> bin           conf             lib      logs    README.md      RUNNING.txt  webapps
> BUILDING.txt  CONTRIBUTING.md  LICENSE  NOTICE  RELEASE-NOTES  temp         work
> [root@web-7 /opt/tomcat]# cp conf/server.xml /opt/
> [root@web-7 /opt/tomcat]# sed -i 's#unpackWARs="true" autoDeploy="true">#unpackWARs="false" autoDeploy="false">#g' conf/server.xml
> [root@web-7 /opt/tomcat]# grep "unpackWARs" conf/server.xml
>             unpackWARs="false" autoDeploy="false">
> ```

> [!run]- 创建普通用户
> 
> 
> ```bash
> [root@web-7 ~]# groupadd -g 1000 www
> [root@web-7 ~]# useradd -u 1000 -g 1000 -M -s /sbin/nologin www
> [root@web-7 ~]# id www
> uid=1000(www) gid=1000(www) groups=1000(www)
> ```

> [!run]- 更改目录所属用户及用户组
> 
> 
> ```bash
> [root@web-7 ~]# chown -R www:www /opt/tomcat*
> [root@web-7 ~]# ll /opt/
> total 8
> -rw------- 1 root root 7856 May 22 09:50 server.xml
> lrwxrwxrwx 1 www  www    18 May 22 09:49 tomcat -> /opt/tomcat-9.0.86
> drwxr-xr-x 9 www  www   220 May 22 09:48 tomcat-9.0.86
> ```

> [!config]- 编写启动文件
> 
> 
> ```bash
> cat > /etc/systemd/system/tomcat.service << 'EOF'
> [Unit]
> Description=Apache Tomcat Web Application Container
> After=network.target
> 
> [Service]
> Type=forking
> 
> Environment=JAVA_HOME=/opt/jdk			# 注意替换为实际的jdk路径
> Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
> Environment=CATALINA_HOME=/opt/tomcat
> Environment=CATALINA_BASE=/opt/tomcat
> Environment='CATALINA_OPTS=-Xms512M -Xmx512M -server -XX:+UseParallelGC'
> Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
> 
> ExecStart=/opt/tomcat/bin/startup.sh
> ExecStop=/opt/tomcat/bin/shutdown.sh
> 
> User=www
> Group=www
> RestartSec=10
> Restart=always
> 
> [Install]
> WantedBy=multi-user.target
> EOF
> ```
> 

> [!info]- 重要参数解释
>
> 
>  **CATALINA_OPTS**
> 
> 这个环境变量提供了特定于Tomcat服务器本身的Java系统属性和JVM参数，它只影响Tomcat的JVM实例。
> 
> - **-Xms512M**: 设置JVM启动时的堆初始大小（Heap Initial Size）为512兆字节。这是JVM开始运行时分配的内存量。
> - **-Xmx512M**: 设置JVM最大堆大小（Maximum Heap Size）为512兆字节。这是JVM能够使用的最大内存量。
> - **-server**: 告诉JVM使用服务器模式的JVM。服务器模式的JVM为长时间运行的进程优化，提高了性能，特别是在执行内存和CPU密集型操作时。
> - **-XX:+UseParallelGC**: 启用并行垃圾回收机制。这意味着垃圾回收将多个垃圾回收线程一起工作，减少停顿时间，提高性能。
> 
>  **JAVA_OPTS**
> 
> 这个环境变量提供了更为广泛的JVM设置，可以影响Tomcat以及它所托管的应用程序和任何依赖的Java组件。
> 
> - **-Djava.awt.headless=true**: 设置系统属性为无头模式。这在服务器环境中非常有用，意味着Java将不会尝试访问图形环境的功能（如显示器、键盘、鼠标），因此在没有图形用户界面的系统上运行GUI应用程序时不会出错。
> - **-Djava.security.egd=file:/dev/./urandom**: 设置Java的“Entropy Gathering Device”(随机数生成设备)。这个设置告诉JVM使用**/dev/urandom**作为随机数生成源，而不是默认的**/dev/random**，因为**/dev/random**可能会在熵不足时阻塞，而**/dev/urandom**不会。这通常用于提高在需要大量随机数时的性能，如TLS/SSL处理。
