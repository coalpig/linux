jenkins服务器

![img](./attachments/1719653612402-1fa72545-369d-4df2-9bb0-04b403dfc8de.png)

```plain
export JAVA_HOME=/opt/jdk8
/opt/maven/bin/mvn -v
```

![img](./attachments/1719654008425-046aec98-a196-460f-9e0d-45d73b4ccab3.png)

```plain
export JAVA_HOME=/opt/jdk8
/opt/maven/bin/mvn clean package
```



# Ansible指定IP

ansible 10.0.0.7,10.0.0.8 -m ping



# Ansible调试完成脚本

![](attachments/ansible_kaoshi_20240630.tar.gz)

```bash
[root@jenkins-201 ~/ansible_kaoshi]# cat jenkins_deploy.sh 
#!/bin/bash

# 1.构建镜像
export JAVA_HOME=/opt/jdk8
/opt/maven/bin/mvn clean package

# 2.替换变量
cd /root/ansible_kaoshi/
sed -i "/APP_VERSION=/c APP_VERSION=$releaseVersion" kaoshi.env
sed -i "/APP_ENV=/c APP_ENV=${deployEnv,,}" kaoshi.env

# 3.调用Ansible剧本
ansible-playbook -l $deployHosts ansible_kaoshi.yaml -e "app_version=$releaseVersion"


[root@jenkins-201 ~/ansible_kaoshi]# cat kaoshi.env 
APP_ENV=prod
APP_VERSION=3.9.0
[root@jenkins-201 ~/ansible_kaoshi]# cat kaoshi.service 
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
EnvironmentFile=/etc/systemd/system/kaoshi.env
ExecStart=/opt/jdk/bin/java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=${APP_ENV} /opt/xzs-${APP_VERSION}.jar 
SuccessExitStatus=143
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target


[root@jenkins-201 ~/ansible_kaoshi]# cat kaoshi.sh 
#!/bin/bash

# 项目名称
APP_NAME="xzs"
# 项目版本
APP_VERSION="3.9.0"
# Spring Boot 配置文件
SPRING_PROFILES_ACTIVE="prod"
# JAR 文件路径
JAR_PATH="/opt/${APP_NAME}-${APP_VERSION}.jar"
# Java 选项
JAVA_OPTS="-Duser.timezone=Asia/Shanghai -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}"

# PID 文件路径
PID_FILE="/var/run/${APP_NAME}.pid"

start() {
  if [ -f "$PID_FILE" ]; then
    echo "Application is already running."
  else
    echo "Starting application..."
    nohup java $JAVA_OPTS -jar $JAR_PATH > /dev/null 2>&1 &
    echo $! > $PID_FILE
    echo "Application started."
  fi
}

stop() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    echo "Stopping application..."
    kill $PID
    rm -f $PID_FILE
    echo "Application stopped."
  else
    echo "Application is not running."
  fi
}

restart() {
  stop
  start
}

status() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null; then
      echo "Application is running (PID: $PID)."
    else
      echo "PID file exists but application is not running."
    fi
  else
    echo "Application is not running."
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
esac
```

# Jar包启动管理脚本

运行命令：

```bash
java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=prod  xzs-3.9.0.jar
```

创建环境变量配置：

```bash
cat > /opt/kaoshi.env << 'EOF'
PROFILES_ACTIVE=prod
JAR_PATH=/opt/xzs-3.9.0.jar
EOF
```

systemd脚本：

```bash
cat > /etc/systemd/system/kaoshi.service << 'EOF'
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
EnvironmentFile=/opt/kaoshi.env
ExecStart=/opt/jdk/bin/java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=${PROFILES_ACTIVE} ${JAR_PATH}
SuccessExitStatus=143
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

shell脚本：

```bash
#!/bin/bash

# 项目名称
APP_NAME="xzs"
# 项目版本
APP_VERSION="3.9.0"
# Spring Boot 配置文件
SPRING_PROFILES_ACTIVE="prod"
# JAR 文件路径
JAR_PATH="/opt/${APP_NAME}-${APP_VERSION}.jar"
# Java 选项
JAVA_OPTS="-Duser.timezone=Asia/Shanghai -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}"

# PID 文件路径
PID_FILE="/var/run/${APP_NAME}.pid"

start() {
  if [ -f "$PID_FILE" ]; then
    echo "Application is already running."
  else
    echo "Starting application..."
    nohup java $JAVA_OPTS -jar $JAR_PATH > /dev/null 2>&1 &
    echo $! > $PID_FILE
    echo "Application started."
  fi
}

stop() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    echo "Stopping application..."
    kill $PID
    rm -f $PID_FILE
    echo "Application stopped."
  else
    echo "Application is not running."
  fi
}

restart() {
  stop
  start
}

status() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null; then
      echo "Application is running (PID: $PID)."
    else
      echo "PID file exists but application is not running."
    fi
  else
    echo "Application is not running."
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
esac
```

# 备份：

[📎jenkins_20240630.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719679146245-6b33e28d-e2bd-4696-93ed-445e0db09e52.gz)

# 环境准备：

gitlab创建项目

jenkins导入项目



jenkins服务器准备

\- jdk17

\- jdk8

\- maven3.9

\- ansible



数据库准备

\- mysql 8.0

\- xzs.sql



java服务器准备

\- nginx

\- jdk



# 制品管理

制品版本命名：版本号-CommitID





# 实验环境要求（强制一样）:

| 服务器        | 软件版本                     | 安装方式   | 安装路径      |
| ------------- | ---------------------------- | ---------- | ------------- |
| gitlab-200    | gitlab-16.9.8                | rpm        | 默认          |
| jenkins-201   | git                          | yum        | 默认          |
| ansible       | yum                          | 默认       |               |
| jenkins-2.464 | rpm                          | 默认       |               |
| jdk-17        | rpm                          | 默认       |               |
| jdk-8u351     | 二进制                       | /opt/jdk8  |               |
| maven-3.9.6   | 二进制                       | /opt/maven |               |
| node-14.21.3  | 二进制                       | /opt/node  |               |
|               | sonar-scanner-cli-6.1.0.4477 | 二进制     | sonar-scanner |
| nexus-202     | jdk-8u351                    | 二进制     | /opt/jdk      |
|               | nexus-3.23                   | 二进制     | /opt/nexus    |
| wbe-7/8       | jdk-8u351                    | 二进制     | /opt/jdk      |
| db-51         | mysql-8.0                    | 二进制     | /opt/mysql    |

# 代码扫描**SonarQube**





![img](./attachments/1719648250740-c0c7c741-5efa-4cf0-8355-a80aed93b538.png)



![img](./attachments/1719648280267-1582c445-2fd2-4bdb-bdb6-69c4bc7c135a.png)







# Jenkins用户权限管理





# 角色插件

项目：

mall-service_DEV

mall-service_TEST

mall-service_PROD



用户：

jenkins_user_dev

jenkins_user_test

jenkins_user_ops



角色：

jenkins_role_dev 

jenkins_role_test

jenkins_role_ops



| **用户**          | **角色**          | **项目**                                           | **权限**               |
| ----------------- | ----------------- | -------------------------------------------------- | ---------------------- |
| jenkins_user_dev  | jenkins_role_dev  | mall-service_DEV                                   | 可查看，可运行         |
| jenkins_user_test | jenkins_role_test | mall-service_TEST                                  | 可查看，可运行         |
| jenkins_user_ops  | jenkins_role_ops  | mall-service_DEVmall-service_TESTmall-service_PROD | 可查看，可运行，可修改 |

## 创建用户：

jenkins_user_dev

jenkins_user_test

jenkins_user_ops



![img](./attachments/1719485909860-b8660e4a-9004-40df-84dd-7420a525e145.png)



![img](./attachments/1719489111374-74093243-e29a-42bd-98b0-f2489de0c4e9.png)

## 创建环境：

mall-service_DEV

mall-service_TEST

mall-service_PROD

![img](./attachments/1719488936517-db79f561-3f68-45dc-bc72-642e443b6170.png)

## 启用安全角色插件

![img](./attachments/1719486066881-442959e3-5392-47a3-9a6e-0ab0262cb1c1.png)



![img](./attachments/1719486120387-a7faf37d-ec29-481d-835a-dda637473046.png)

![img](./attachments/1719486245807-95681789-c125-4007-83c4-c5ce822c0150.png)

## 创建角色

### 创建Global roles

![img](./attachments/1719489780722-025e580a-d149-43d3-a0e0-d974a3bd33c5.png)

### 创建Item roles

jenkins_role_dev 

jenkins_role_test

jenkins_role_ops

![img](./attachments/1719489554622-7c0ee121-6329-4e6e-b210-277a3e38ac93.png)

## 授权角色

![img](./attachments/1719489904029-11b1e8ef-1df5-4869-9ac4-6cca3335d5af.png)

## 测试权限

## jenkins_dev用户测试

![img](./attachments/1719489925441-4233416a-ab8d-46d3-8716-943fddd3f458.png)

![img](./attachments/1719490081338-315c854b-cc48-40c0-94cc-05e3323219db.png)

![img](./attachments/1719490097638-21be06eb-b8db-42f1-ba85-f3d3e2cc319b.png)



## jenkins_test用户测试

![img](./attachments/1719490028456-4b3c3688-780a-4853-8b26-1ee5828cd56e.png)

![img](./attachments/1719490042781-ba3512c9-f7f1-4930-87ae-450a135cd1dc.png)

## jenkins_ops用户测试

![img](./attachments/1719490139724-258e3130-8cdd-4fdd-9823-f7c6e41ee6e4.png)

![img](./attachments/1719490127495-d88e73ee-0e86-4fc2-90e7-3ae367411f67.png)

![img](./attachments/1719490162473-9f3a0ecb-fbb5-4d28-ae84-08badb9bfeab.png)

![img](./attachments/1719490182418-9f687f45-f470-4b0a-a2f2-aec87e3a8d06.png)

![img](./attachments/1719490198984-1dc9eaca-d022-4b74-8bda-26fe82291f6f.png)