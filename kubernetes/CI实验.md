查看gitlab的密码

```
kubectl -n devops exec -it $(kubectl -n devops get pod|awk '/gitlab/{print $1}') -- grep "^Password" /etc/gitlab/initial_root_password
```

查看jenkins密码就在pod的日志里面查看

jenkins安装必备插件

```
## 安装必备插件
kubernetes  
git  
git parameter  
pipeline  
pipeline: stage view  
active choices  
Localization: Chinese (Simplified)
```

jenkins创建cloud

```
https://kubernetes.default.svc.cluster.local
https://jenkins-svc.devops.svc.cluster.local:8080
jenkins-svc.devops.svc.cluster.local:50000
```

![](attachments/Pasted%20image%2020240926190233.png)

![](attachments/Pasted%20image%2020240926190304.png)

添加pod模板

下载镜像 jenkins/inbound-agent

如果使用harbor

```
docker pull  jenkins/inbound-agent
docker tag jenkins/inbound-agent abc.com/devops/inbound-agent:latest
docker push abc.com/devops/inbound-agent:latest
```

```
abc.com/devops/inbound-agent
```

```
/usr/bin/docker
/run/docker.sock
/usr/libexec/docker/
```

![](attachments/Pasted%20image%2020240926191325.png)


![](attachments/Pasted%20image%2020240926204340.png)


![](attachments/Pasted%20image%2020240926191359.png)

![](attachments/Pasted%20image%2020240926191408.png)


在创建完cloud云后可以先执行docker info 查看docker是否可以使用

![](attachments/Pasted%20image%2020240926204931.png)



在k8s中使用这种方式用docker的话不需要将harbor凭证就可以拉取harbor镜像，也不需要解析abc.com

CI使用pipeline流水线方式

首先在master创建密钥对

gitlab在项目里面配置好公钥(可写)

master拉取gitlab代码

先查看svc的ip

```
[root@master-01 jenkins]# kubectl -n devops get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
gitlab-svc    ClusterIP   10.103.128.88   <none>        80/TCP,22/TCP        8h
jenkins-svc   ClusterIP   10.99.250.18    <none>        8080/TCP,50000/TCP   7h54m
```

在克隆之前
需要创建和流水线脚本一样的项目名称

我创建的是jenkins

```
git clone git@10.103.128.88:root/jenkins.git
```

```
yum install git -y
git add .
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git commit -m 'v1'
git push origin main
```

流水线脚本

```
pipeline{
    //调用kubernetes插件创建jenkins-agent的临时pod
    agent {
      kubernetes {
        cloud 'kubernetes'
		yaml '''
---
apiVersion: "v1"
kind: "Pod"
metadata:
  labels:
    jenkins: "slave"
  namespace: "devops"
spec:
  containers:
  - env:
    - name: "JENKINS_TUNNEL"
      value: "jenkins-svc.devops.svc.cluster.local:50000"
    - name: "JENKINS_AGENT_WORKDIR"
      value: "/home/jenkins/agent"
    - name: "JENKINS_URL"
      value: "http://jenkins-svc.devops.svc.cluster.local:8080/"
    image: "abc.com/devops/inbound-agent"
    imagePullPolicy: "IfNotPresent"
    name: "jnlp"
    volumeMounts:
    - mountPath: "/usr/libexec/docker"
      name: "volume-1"
      readOnly: false
    - mountPath: "/var/run/docker.sock"
      name: "volume-0"
      readOnly: false
    - mountPath: "/etc/docker"
      name: "volume-3"
      readOnly: false
    - mountPath: "/usr/bin/docker"
      name: "volume-2"
      readOnly: false
    - mountPath: "/home/jenkins/agent"
      name: "workspace-volume"
      readOnly: false
    workingDir: "/home/jenkins/agent"
  imagePullSecrets:
  - name: "harbor-secret"
  nodeSelector:
    kubernetes.io/os: "linux"
  restartPolicy: "Never"
  securityContext:
    runAsGroup: 0
    runAsUser: 0
  serviceAccountName: "jenkins-admin"
  volumes:
  - hostPath:
      path: "/var/run/docker.sock"
    name: "volume-0"
  - hostPath:
      path: "/usr/bin/docker"
    name: "volume-2"
  - hostPath:
      path: "/usr/libexec/docker"
    name: "volume-1"
  - emptyDir:
      medium: ""
    name: "workspace-volume"
  - hostPath:
      path: "/etc/docker/"
    name: "volume-3"
'''		
      }
    }

    stages{
        stage("准备ssh环境"){ 
            steps{
                withCredentials([string(credentialsId: 'jenkins-ssh-pub-key', variable: 'SSH_PUB_KEY_FILE'), sshUserPrivateKey(credentialsId: 'jenkins-ssh-key', keyFileVariable: 'SSH_KEY_FILE')]) {
                    sh '''
					    mkdir ~/.ssh/ && chmod 700 ~/.ssh/
                        cp ${SSH_KEY_FILE} ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
                        echo ${SSH_PUB_KEY_FILE} > ~/.ssh/id_rsa.pub
                    '''
                }
            }
        }
        
        stage("拉取代码"){ 
            steps{
                sh '''
                    ssh-keyscan gitlab-svc >> ~/.ssh/known_hosts
                    git clone git@gitlab-svc:root/jenkins.git
                '''
            }
        }

        stage("登录Harbor"){ 
            steps{
                sh '''
                    echo "登录Habor"
                    docker login abc.com -u admin -p Harbor12345
                '''
            }
        }

        stage("构建镜像"){ 
            steps{
                sh '''
                    cd jenkins && docker build -t abc.com/app/xzs:v1 .
                '''
            }
        }

        stage("推送镜像"){ 
            steps{
                sh '''
                    docker push abc.com/app/xzs:v1
                '''
            }
        }		
    }
}
```