精简资源清单，删掉不需要的配置
编写简单的pod
https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/


```
apiVersion: v1  
kind: Pod  
metadata:  
  name: nginx  
  labels:  
    app: nginx  
spec:  
  containers:  
  - name: nginx  
    image: nginx:alpine  
    imagePullPolicy: IfNotPresent  #不用重新拉取镜像,节省时间
    ports:  
    - name: http  
      containerPort: 80
```

json格式写法：
```
{  
 apiVersion: "v1",  
 kind: "Pod",  
 metadata:   
   {  
      name: "nginx",   
      labels:   
        {  
           app: "nginx"  
        }          
    }  
 spec:   
   {  
     containers:  
       {  
         name: "nginx",  
         image: "nginx:alpine",  
         imagePullPolicy: "IfNotPresent"  
       }  
   }      
}       
```

一个pod里面运行两个容器
注意不要让端口冲突

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-tomcat-pod
spec:
  containers:
  - name: nginx-pod
    image: nginx
    imagePullPolicy: IfNotPresent
    ports:
    - containerPort: 80

  - name: tomcat-pod #写两个- name
    image: tomcat
    imagePullPolicy: IfNotPresent
    ports:
    - containerPort: 8080
```



