
为什么使用ingress，NodePort有什么缺点
- 没有ingress之前，pod对外提供服务只能通过NodeIP:NodePort的形式，但是这种形式有缺点，一个节点上的PORT不能重复利用。比如某个服务占用了80，那么其他服务就不能在用这个端口了。
- NodePort是4层代理，不能解析7层的http，不能通过域名区分流量  
- 为了解决这个问题，我们需要用到资源控制器叫Ingress，工作在7层，作用就是提供一个统一的访问入口并且解析HTTP请求。  
- 虽然我们可以使用nginx/haproxy来实现类似的效果，但是传统部署不能动态的发现我们新创建的资源，必须手动修改配置文件并重启。  
- 而Ingress控制器简单理解就是运行在k8s里的反向代理/负载均衡，可以解析外部7层流量，识别用户访问的域名并转发到k8s内部的Pod中。

ingress 也是一个控制器和资源
通过标签找service
service通过标签找node


![](attachments/Pasted%20image%2020240903151426.png)