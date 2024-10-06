---
tags:
  - java微架构
---

> [!info]- 什么是Maven
> 
> 
> Maven是一个项目管理和构建工具，主要用于Java项目。
> 
> 它基于项目对象模型（POM），通过一个中心的信息片段来管理项目的构建、报告和文档。
> 
> Maven的目标是简化和标准化项目的构建过程，同时提供一个易于管理的依赖管理系统。
> 

> [!info]- 为什么需要Maven
> 
> 
> 在没有Maven的情况下，开发人员需要手动管理项目的依赖、构建过程和项目结构，这容易导致以下问题：
> 
> **依赖管理困难**：手动添加和更新依赖库（JAR文件）非常麻烦，且容易出现版本冲突问题。
> 
> **构建过程复杂**：不同的项目可能有不同的构建步骤，缺乏统一的构建过程。
> 
> **项目结构不统一**：没有统一的项目结构标准，不同的项目可能使用不同的目录结构和命名规范。
> 

> [!info]- Maven解决了哪些问题
> 
> 
> **依赖管理**：自动下载和管理项目所需的依赖库及其依赖项（传递性依赖）。
> 
> **统一构建过程**：提供标准的构建生命周期，包括编译、测试、打包、部署等步骤。
> 
> **项目结构标准化**：强制使用标准的项目结构，确保所有Maven项目的一致性。
> 

> [!info]- Maven和Java代码的关系
> 
> 
> Maven主要用于Java项目，它通过POM文件来定义项目的依赖、构建过程和插件。POM文件是XML格式，包含项目的基本信息、依赖列表、构建插件和配置等。Maven使用这些信息来自动化项目的构建过程，包括以下几个方面：
> 
> **编译**：使用Maven编译插件（maven-compiler-plugin）编译Java源代码。
> 
> **测试**：使用Maven Surefire插件（maven-surefire-plugin）运行单元测试。
> 
> **打包**：使用Maven打包插件（maven-jar-plugin或maven-war-plugin）将编译后的代码打包成JAR或WAR文件。
> 
> **部署**：使用Maven部署插件（maven-deploy-plugin）将打包后的文件部署到远程仓库。
> 

> [!info]- 如何判断Java代码是不是Maven项目
> 
> 
> 要判断一个Java项目是否是Maven项目，可以检查以下几个方面：
> 
> **POM文件**：Maven项目的根目录下应该有一个名为`pom.xml`的文件，这是Maven项目的配置文件。该文件包含项目的基本信息、依赖列表、构建插件和配置等。
> 
> **标准目录结构**：Maven项目通常遵循标准的目录结构，包括`src/main/java`、`src/test/java`等目录，用于存放源代码和测试代码。
> 
> **Maven命令支持**：在项目根目录下运行Maven命令（如`mvn clean install`）应该可以成功执行项目的构建过程。
> 
> 通过以上检查，可以确定一个Java项目是否是Maven项目。
> 

- ~ Maven部署

> [!install]- 二进制安装JDK
> 
> 
> [📎jdk-8u351-linux-x64.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719133343715-3fc4a98c-2599-421b-9406-d1b03f86373d.gz)
> 
> ```bash
> tar zxf jdk-8u351-linux-x64.tar.gz -C /opt/
> ln -s /opt/jdk1.8.0_351 /opt/jdk
> cp /etc/profile /etc/profile.bak
> cat >> /etc/profile << 'EOF'
> export JAVA_HOME=/opt/jdk
> export JRE_HOME=${JAVA_HOME}/jre
> export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
> export PATH=$PATH:${JAVA_HOME}/bin
> EOF
> source /etc/profile
> java -version
> echo $JAVA_HOME
> echo $JRE_HOME
> ```
> 

> [!install]- 二进制安装maven
> 
> 
> [📎apache-maven-3.9.6-bin.tar.gz](https://www.yuque.com/attachments/yuque/0/2024/gz/830385/1719194359566-00613ea3-e751-47fc-b8db-1e342a73f2fe.gz)
> 
> ```bash
> tar zxf apache-maven-3.9.6-bin.tar.gz -C /opt/
> mv /opt/apache-maven-3.9.6 /opt/maven-3.9.6/
> ln -s /opt/maven-3.9.6 /opt/maven
> echo "export PATH=$PATH:/opt/maven/bin" >> /etc/profile
> source /etc/profile
> mvn -v
> ```
> 

> [!test]- 设置maven国内源
> 
> 
> 在mirror标签下添加mirror区块
> 
> ```plain
> vim /opt/maven/conf/settings.xml
> < mirror>
>     <id>aliyunmaven</id>
>     <mirrorOf>*</mirrorOf>
>     <name>阿里云公共仓库</name>
>     <url>https://maven.aliyun.com/repository/public</url>
> </mirror>
> ```
> 

> [!run]- maven常用命令
> 
> 
> ```plain
> mvn clean
> mvn package
> mvn clean package
> ```
> 

> [!info]- maven缓存
> 
> 
> 默认使用maven打包时，默认会在当前用户的家目录下创建～/.m2的目录，所以一旦打包过一次，这些依赖包就被缓存了下来，下次再打包就不用从网络上下载了
> 
> 当然我们也可以修改配置文件，指定下载的目录路径
> 
> ```xml
> < settings>
>   <localRepository>/path/to/local/repo</localRepository>
>   ...
> </settings>
> ```
> 

> [!info]- maven使用Nexus作为私有仓库
> 
> 
> ```plain
> cat > /opt/maven/conf/settings.xml << 'EOF'
> <?xml version="1.0" encoding="UTF-8"?>
> <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
>           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>           xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
>   <pluginGroups>
>   </pluginGroups>
> 
>   <proxies>
>   </proxies>
> 
>   <servers>
>     <server>   
>       <id>snapshots</id>   
>       <username>admin</username>   
>       <password>admin</password>   
>     </server>   
>     <server>   
>       <id>releases</id>   
>       <username>admin</username>   
>       <password>admin</password>   
>     </server>   
>     <server>   
>       <id>public</id>   
>       <username>admin</username>   
>       <password>admin</password>   
>     </server>   
>   </servers>
> 
>   <mirrors>
>     <mirror>
>       <id>public</id>
>       <mirrorOf>*</mirrorOf>
>       <url>http://10.0.0.202:8081/repository/maven-public/</url>
>     </mirror>
>   </mirrors>
> 
>   <profiles>
>     <profile>
>       <id>public</id>
>       <repositories>
>         <repository>
>           <id>public</id>
>           <url>http://10.0.0.202:8081/repository/maven-public/</url>
>           <releases><enabled>true</enabled></releases>
>           <snapshots><enabled>true</enabled></snapshots>
>         </repository>
>       </repositories>
>       <pluginRepositories>
>         <pluginRepository>
>           <id>public</id>
>           <url>http://10.0.0.202:8081/repository/maven-public/</url>
>           <releases><enabled>true</enabled></releases>
>           <snapshots><enabled>true</enabled></snapshots>
>         </pluginRepository>
>       </pluginRepositories>
>     </profile>
>   </profiles>
> 
>   <activeProfiles>
>     <activeProfile>public</activeProfile>
>   </activeProfiles>
> 
> </settings>
> EOF
> ```
> 
> 
> 