## 查看资源并获取token

```
kubectl get pod -n kubernetes-dashboard -o wide
kubectl get svc -n kubernetes-dashboard
kubectl get secret  -n kubernetes-dashboard
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```
