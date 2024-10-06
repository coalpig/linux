---
tags:
  - CICD/Jenkins
---

> [!test]- 拆分思路分析
> 
> 
> 有了Nexus制品上传和下载之后，我们的发布脚本就可以拆解成CI和CD两部分了
> 
> CI流程:
> 
> - 下载代码
> - maven编译
> - 代码扫描
> - 制品上传
> 
> CD流程：
> 
> - 下载制品
> - Ansible部署
> 
> 拆分后流程图如下：
> 
> ![img](../images/1719792686230-d70ffe80-3def-47c3-a973-d663634f8e43.png)
> 
> 像这样的发布脚本，我们最好单独一个仓库，和业务代码仓库分开，这样方便后续的管理
> 
> ![img](../images/1719836277191-3ca424be-6386-4be9-b7e5-2630fee93a81.png)
> 
> ![](attachments/jenkins-deploy%201.zip)
> 

> [!info]- 拆解CI脚本
> 
> 
> ```bash
> [root@jenkins-201 /opt/deploy]# cat jenkins_deploy_ci.sh
> #!/bin/bash
> 
> # 1.构建镜像
> export JAVA_HOME=/opt/jdk8
> /opt/maven/bin/mvn -s settings.xml clean package
> 
> # 2.代码扫描
> if [ "$sonarSkip" == "false" ];then
>   /opt/sonar-scanner/bin/sonar-scanner -Dsonar.host.url=http://10.0.0.203:9000 \
>   -Dsonar.projectKey=kaoshi-maven-service \
>   -Dsonar.projectName=kaoshi-maven-service \
>   -Dsonar.projectVersion=${releaseVersion} \
>   -Dsonar.token=${sonarToken} \
>   -Dsonar.ws.timeout=30 \
>   -Dsonar.projectDescription="my first project" \
>   -Dsonar.links.homepage=http://10.0.0.203/devops/kaoshi-maven-service \
>   -Dsonar.sources=src \
>   -Dsonar.sourceEncoding=UTF-8 \
>   -Dsonar.java.binaries=target/classes \
>   -Dsonar.java.test.binaries=target/test-classes \
>   -Dsonar.java.surefire.report=target/surefire-reports
> fi
> 
> 
> # 3.制品上传
> if [ -f "target/xzs-${releaseVersion}.jar" ];then
>   /opt/maven/bin/mvn -s settings.xml deploy:deploy-file \
>   -DgroupId=com.mindskip \
>   -DartifactId=xzs \
>   -Dversion=${releaseVersion} \
>   -Dpackaging=jar \
>   -Dfile=target/xzs-${releaseVersion}.jar \
>   -Durl=http://10.0.0.202:8081/repository/kaoshi-release/ \
>   -DrepositoryId=releases
> fi
> ```
> 

> [!info]- 拆解CD脚本
> 
> 
> jenkins调用脚本
> 
> ```bash
> [root@jenkins-201 /opt/deploy]# cat jenkins_deploy_cd.sh
> #!/bin/bash
> 
> #1.下载制品
> curl -s -u admin:admin -o /opt/deploy/xzs-${releaseVersion}.jar ${nexusUrl}
> 
> #2.替换系统变量
> if [ -f "xzs-${releaseVersion}.jar" ];then
>   sed -i "/APP_VERSION=/c APP_VERSION=$releaseVersion" kaoshi.env
>   sed -i "/APP_ENV=/c APP_ENV=${deployEnv,,}" kaoshi.env
> else
>   exit
> fi
> 
> #3.调用Ansible剧本
> ansible-playbook -l $deployHosts /opt/deploy/ansible_deploy_cd.yaml -e "app_version=$releaseVersion"
> ```
> 
> ansible发布脚本:
> 
> ```yaml
> [root@jenkins-201 /opt/deploy]# cat ansible_deploy_cd.yaml
> ---
> - name: Deploy Kaoshi Application
>   hosts: all
> 
>   tasks:
>     - name: Copy the JAR file to the server
>       copy:
>         src: "xzs-{{ app_version }}.jar"
>         dest: /opt/
> 
>     - name: Copy the environment file
>       copy:
>         src: kaoshi.env
>         dest: /etc/systemd/system/kaoshi.env
>       notify:
>         - restart kaoshi
> 
>     - name: Copy the systemd service file
>       copy:
>         src: kaoshi.service
>         dest: /etc/systemd/system/kaoshi.service
>       notify:
>         - reload systemd
>         - restart kaoshi
> 
>     - name: Start and enable the kaoshi service
>       systemd:
>         name: kaoshi
>         state: started
>         enabled: yes
> 
>   handlers:
>     - name: reload systemd
>       command: systemctl daemon-reload
> 
>     - name: restart kaoshi
>       systemd:
>         name: kaoshi
>         state: restarted
> ```
> 
> 启动脚本变量文件:
> 
> ```bash
> cat > kaoshi.env << 'EOF'
> APP_ENV=prod
> APP_VERSION=3.9.2
> EOF
> ```
> 
> 启动脚本systemd文件:
> 
> ```bash
> cat > kaoshi.service < 'EOF'
> [Unit]
> Description=Spring Boot Application
> After=network.target
> 
> [Service]
> EnvironmentFile=/etc/systemd/system/kaoshi.env
> ExecStart=/opt/jdk/bin/java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=${APP_ENV} /opt/xzs-${APP_VERSION}.jar 
> SuccessExitStatus=143
> Restart=always
> RestartSec=10
> 
> [Install]
> WantedBy=multi-user.target
> EOF
> ```
> 

- ~ jenkins任务配置

> [!info]- 持续集成CI 任务配置
> 
> 
> ![img](../images/1719748002508-c9f4ed41-672c-463c-a52f-998a83109e80.png)
> 
> ![img](../images/1719747888709-4e314179-1c15-4044-922e-e880d18c1f4c.png)
> 
> ![img](../images/1719747924404-33ead318-b89b-4804-ae98-6e2d1cc1640f.png)
> 
> ![img](../images/1719747940194-7c4b3888-072a-4213-9d96-19990ba7f6bd.png)
> 
> ![img](../images/1719747965777-5d8db71c-b7cd-4574-8570-511c34be6ec8.png)
> 
> ![img](../images/1719747974394-f657b0e0-d790-42c0-9fa5-c13cbd913774.png)
> 
> ![img](../images/1719836489876-a9d60924-47d0-4077-8559-4cba67cc4b2e.png)
> 

> [!info]- 持续集成CD 任务配置
> 
> 
> ![img](../images/1719748212721-97212616-1bb8-4aa2-ba93-5f56741ec7cb.png)
> 
> ![img](../images/1719748021357-dc811415-2eeb-4dec-b209-607e2a96347d.png)
> 
> ![img](../images/1719748063808-702845e5-ba5b-492d-b7df-864a58ee3ac9.png)
> 
> ![img](../images/1719748092755-9765d78e-140c-406f-8788-f0b6bfe57a88.png)
> 
> ![img](../images/1719748113103-63a617f7-aaeb-4a37-abcc-c29159d32d13.png)
> 
> ![img](../images/1719748133966-f92c8545-6c14-410c-90e7-02416432233f.png)
> 
> ![img](../images/1719836534584-43bb104a-23b3-42de-9ab9-1e553879f18c.png)
> 
> 