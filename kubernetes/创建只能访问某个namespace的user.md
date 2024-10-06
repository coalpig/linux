创建一个用户并且控制权限

kubectl --> 读取用户家目录的.kube/config --> master节点验证角色信息

```
#第1步：创建key
openssl genrsa -out abc.key 2048

#第2步：使用key生成证书
openssl req -new -key abc.key -out abc.csr -subj "/CN=abc/O=abc"

#第3步：使用k8s自己的ca.crt和ca.key签发我们生成abc.crt有效期300天
openssl x509 -req -in abc.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out abc.crt -days 300

#第4步：生成集群配置
kubectl config set-cluster kubernetes --server=https://10.0.0.10:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --kubeconfig=abc.config

#第5步：生成运行环境
kubectl config set-context abc-context --cluster=kubernetes --user=abc --namespace=default --kubeconfig=abc.config

#第5步：设置配置文件里的运行环境
kubectl config set current-context abc-context --kubeconfig abc.config

#第6步：指定用户的证书
kubectl config set-credentials abc --client-certificate=abc.crt --client-key=abc.key --embed-certs=true --kubeconfig=abc.config

#第7步：创建角色
cat > abc-role.yaml << 'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: abc-role
  namespace: default
rules:
- apiGroups: ["", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["*"]
EOF
kubectl apply -f abc-role.yaml 

#第8步：创建角色绑定
cat > abc-rolebinding.yml << 'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: abc-rolebinding
  namespace: default
subjects:
- kind: User
  name: abc
  apiGroup: ""
roleRef:
  kind: Role
  name: abc-role
  apiGroup: rbac.authorization.k8s.io 
EOF
kubectl apply -f abc-rolebinding.yml 

#第9步：将config配置发送到node节点
scp abc.config node1:/root/.kube/config

#第10步：node节点测试访问
kubectl get pods
```
