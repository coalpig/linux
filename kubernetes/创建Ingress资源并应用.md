## 创建Ingress资源并应用

创建资源配置：

```
cat > dashboard-ingress.yml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/ingress.class: "nginx"
    ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: "dashboard.k8s.com"
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
EOF
```

应用配置：

```
kubectl apply -f dashboard-ingress.yml
```

关键参数解释：

```
annotations:                                          #注解
     kubernetes.io/ingress.class: "nginx"                    #使用的是nginx类型的ingress
     ingress.kubernetes.io/ssl-passthrough: "true"               #SSL透传
     nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"       #后端使用TLS协议
     nginx.ingress.kubernetes.io/rewrite-target: /       #URL重定向
```
