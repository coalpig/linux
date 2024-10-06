
### 3.1 type类型说明

[https://kubernetes.io/docs/concepts/storage/volumes/#hostpath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)

```
DirectoryOrCreate  目录不存在就自动创建
Directory          目录必须存在
FileOrCreate       文件不存在则创建
File               文件必须存在
```

### 3.2 创建hostPath类型volume资源配置清单

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox-nodename
spec:
  nodeName: node2
  volumes:
  - name: hostpath-volume
    hostPath:
      path: /data/node/
      type: DirectoryOrCreate   
  containers:
  - name: busybox-pod
    image: busybox
    volumeMounts:
    - mountPath: /data/pod/
      name: hostpath-volume
    command: ["/bin/sh","-c","while true;do echo $(date) >> /data/pod/index.html;sleep 3;done"]
```
