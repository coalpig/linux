CD需要映射kubectl


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
    - mountPath: "/usr/bin/kubectl"
      name: "volume-0"
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
      path: "/usr/bin/kubectl"
    name: "volume-0"
  - emptyDir:
      medium: ""
    name: "workspace-volume"
'''		
      }
    }

    stages{
        stage("准备kubectl环境"){ 
            steps{
                withCredentials([file(credentialsId: 'kube-config', variable: 'KUBE_CONFIG')]) {
                    sh '''
					    mkdir ~/.kube/
                        cp ${KUBE_CONFIG} ~/.kube/config
						chmod 600 ~/.kube/config
                    '''
                }
            }
        }
        
        stage("更新镜像版本"){
            steps{
                sh '''
                    kubectl -n default set image deployment nginx-dp nginx-dp=abc.com/base/nginx:v3
                '''
            }
        }	
    }
}

```