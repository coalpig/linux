## EmptyDir类型

```
cat > emptyDir.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: busybox-empty
spec:
  containers:
  - name: busybox-pod
    image: busybox
    volumeMounts:
    - mountPath: /data/busybox/
      name: cache-volume
    command: ["/bin/sh","-c","while true;do echo $(date) >> /data/busybox/index.html;sleep 3;done"]
  volumes:
  - name: cache-volume
    emptyDir: {}
EOF
```
