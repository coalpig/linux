> [!install]- 安装kibana
> 
> ```
> rpm -ivh kibana-7.9.1-x86_64.rpm
> ```
> 

> [!config]- 配置kibana
> 
> 
> > ```
> > egrep -v "#|^$" /etc/kibana/kibana.yml
> > vim /etc/kibana/kibana.yml
> > ```
> 
> > ```
> > server.port: 5601
> > server.host: "10.0.0.51"
> > elasticsearch.hosts: ["http://10.0.0.51:9200"]
> > kibana.index: ".kibana"
> > ```

> [!systemd]- 启动kibana
> 
> ```
> systemctl start kibana
> ```

> [!test]- 检查测试
> 
> 
> ```
> http://10.0.0.51:5601/
> ```
