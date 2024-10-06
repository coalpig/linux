## 根据Node标签选择POD创建在指定的Node上

### 5.1 方法1: 直接选择Node节点名称

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-nodename
spec:
  nodeName: node2
  containers:
  - name: busybox-pod
    image: busybox
    volumeMounts:
    - mountPath: /data/pod/
      name: hostpath-volume
    command: ["/bin/sh","-c","while true;do echo $(date) >> /data/pod/index.html;sleep 3;done"]
  volumes:
  - name: hostpath-volume
    hostPath:
      path: /data/node/
      type: DirectoryOrCreate
```

### 5.2 方法2: 根据Node标签选择Node节点

节点添加标签

kubectl label nodes node3 disktype=SSD

资源配置清单

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-nodename
spec:
  nodeSelector:
    disktype: SSD
  containers:
  - name: busybox-pod
    image: busybox
    volumeMounts:
    - mountPath: /data/pod/
      name: hostpath-volume
    command: ["/bin/sh","-c","while true;do echo $(date) >> /data/pod/index.html;sleep 3;done"]
  volumes:
  - name: hostpath-volume
    hostPath:
      path: /data/node/
      type: DirectoryOrCreate
```
