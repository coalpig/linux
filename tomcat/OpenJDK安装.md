---
tags:
  - OpenJDK
---
版本选择

用的最多  1.8

比较新的  1.17

>二进制安装

[📎jdk-8u351-linux-x64.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1716888274711-40a20e0b-1846-4648-b0b9-6d81ffbd30bc.gz)

```bash
tar zxf jdk-8u351-linux-x64.tar.gz -C /opt/
ln -s /opt/jdk1.8.0_351 /opt/jdk
cp /etc/profile /etc/profile.bak
cat >> /etc/profile << 'EOF'
export JAVA_HOME=/opt/jdk
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=$PATH:${JAVA_HOME}/bin
EOF
source /etc/profile
java -version
echo $JAVA_HOME
echo $JRE_HOME
```

>rpm安装

[📎jdk-8u351-linux-x64.rpm](https://www.yuque.com/attachments/yuque/0/2024/rpm/830385/1716888285259-f1a58203-a499-44ba-9f00-517e19245fe6.rpm)

```bash
rpm -ivh jdk-8u351-linux-x64.rpm
update-alternatives --config java
cp /etc/profile /etc/profile.bak
cat >> /etc/profile << 'EOF'
export JAVA_HOME=/usr/java/jdk1.8.0_351-amd64
export PATH=$PATH:$JAVA_HOME/bin
EOF
source /etc/profile
java -version
echo $JAVA_HOME
echo $JRE_HOME
```

>yum安装

```bash
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
update-alternatives --config java
cp /etc/profile /etc/profile.bak
cat >> /etc/profile << 'EOF'
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
EOF
source /etc/profile
java -version
echo $JAVA_HOME
echo $JRE_HOME
```
