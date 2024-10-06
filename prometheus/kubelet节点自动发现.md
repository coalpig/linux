kubelet节点自动发现

prometheus自动发现kubelet访问的是10250端口，但是必须是https协议，而且必须提供证书，我们可以直接使用k8s的证书。除此之外访问集群资源还需要相应的权限，还需要带上我们刚才为prometheus创建的service-account-token,实际上我们为prometheus创建的RBAC资源产生的secrets会以文件挂载的形式挂载到Pod里，所以我们查询的时候只要带上这个token就具备了查询集群资源的权限。另外我们还设置了跳过证书检查。


```
    - job_name: 'kubelet'
      kubernetes_sd_configs:
      - role: node
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
```

配置解释

```
- job_name: 'kubelet'
  kubernetes_sd_configs:
  - role: node
  scheme: https		#配置用于请求的协议
  tls_config:			#tls配置
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt		#ca证书
    insecure_skip_verify: true		#禁用证书检查
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token	#serviceaccount授权，默认securt会以文件形式挂载到pod里
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
```

