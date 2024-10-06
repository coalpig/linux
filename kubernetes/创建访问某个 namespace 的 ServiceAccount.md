```
#1.创建ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-sa
  namespace: default
---
#2.编写角色
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-role
rules:                                                #权限规则
- apiGroups: [""]                                   	#核心组API,如果为空""就表示是核心组API
  resources: ["pods"]                           			#核心组API里具体的资源对象
  verbs: ["get", "watch", "list"]   #可操作的权限
  
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list", "delete"]
---
#3.编写角色绑定
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-rb
  namespace: default
subjects:                                               #要绑定的账号
  - kind: ServiceAccount                                #账号类型
    name: pod-sa                                        #账号名称
    namespace: default                                  #命名空间
roleRef:
  apiGroup: rbac.authorization.k8s.io       						#声明一下RABC资源组
  kind: Role                                            #角色类型
  name: pod-role                                        #角色名称

#4.应用并查看
kubectl get sa
kubectl get role
kubectl get rolebindings.rbac.authorization.k8s.io 
kubectl get secrets

#5.查看账户token
kubectl describe secrets pod-sa-token-rk9lc |grep token
```