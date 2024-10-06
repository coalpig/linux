```
apiVersion: v1
kind: Pod
metadata:
  name: tomcat-cp
spec:
  containers:
  - name: tomcat-pod
    image: tomcat
    imagePullPolicy: IfNotPresent
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh","-c","mv /usr/local/tomcat/webapps.dist/ROOT /usr/local/tomcat/webapps"]
```