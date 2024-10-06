# day85-k8s
```
1.Pod的生命周期都有哪些配置？
初始化
启动钩子和停止钩子
存活探针和就绪探针

2.初始化容器和启动钩子函数有什么区别？详细说明
是在业务容器创建之前启动一个init容器作为业务容器定义一个执行前的条件

3.存活性探针都有哪些重要配置？含义是什么？
initialDelaySeconds: 10  # pod启动10秒探测一次
periodSeconds: 3 





4.存活性探针探测方式有哪些？探测条件分别是什么？探测失败了会如何处理？
exec 探测命令执行是否成功
httpget 探测状态码是否为200
tcpSocket 探测端口是否为期望的

如果失败了就查看日志

```
详细解释以下资源配置清单每一行的含义：
```
apiVersion: v1      #k8s引擎
kind: Pod           #资源类型
metadata:           #存在etcd的数据
  name: nginx-pod   #etcd的数据名
spec:
  volumes:          #定义卷组
  - name: nginx-data
    hostPath:
      path: /data/nginx
      type: Directory

  containers:
  - name: nginx-pod
    image: nginx
    imagePullPolicy: IfNotPresent

    volumeMounts:  #挂载卷组
    - name: nginx-data
      mountPath: /usr/share/nginx/html
      
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh", "-c", "echo ok >> /usr/share/nginx/html/healthy.html"]

    livenessProbe:
      initialDelaySeconds: 10  #10秒后探测
      periodSeconds: 3         #每3秒探测一次
      httpGet:
        path: /healthy.html
        port: 80
```
预习：
1.什么是Pod控制器？Pod控制器都有哪些分类？
2.RS控制器的作用是什么？RS控制器和Pod的关系是什么？
3.RS控制器如何知道自己需要监控的Pod是哪些？依据是什么？
4.什么是DP控制器？
5.DP控制器和RS控制器的区别是什么？
6.尝试编写DP控制器资源配置清单