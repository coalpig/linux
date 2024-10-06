iptables模式
- iptables模式下，kube-proxy通过映射Linux内核的iptables规则，实现从Service到后端Endpoint列表的负载转发规则
- 但是如果某个后端Endpoint在转发时不可用，则请求就会失败
- 所以应该通过为Pod设置readinessprobe来保证只有达到ready状态的Endpoint才会被设置为Service的后端Endpoint，也就是[就绪性探针](就绪性探针.md)

![](attachments/Pasted%20image%2020240902235138.png)


ipvs模式
- 除了iptables模式，k8s还支持ipvs模式
- ipvs在k8s 1.11版本达到Stable阶段
- kube-proxy通过设置Linux内核的netlink接口设置IPVS规则，转发效率和支持的吞吐率都是最高的。
- ipvs模块要求Linux内核开启IPVS模块
- 如果操作系统未启用IPVS内核模块，kube-proxy会自动切换到iptables模式

ipvs模式支持更多的负载均衡策略
```
修改默认策略需要在kube-proxy中配置–ipvs-scheduler参数来实现，但是这个参数是全局的，对所有Service类型都生效。
 
rr    轮询
lc    最小连接数
dh    目的地址哈希
sh    源地址哈希
sed   最短期望延时
nq    永不排队
```

![](attachments/Pasted%20image%2020240902235335.png)