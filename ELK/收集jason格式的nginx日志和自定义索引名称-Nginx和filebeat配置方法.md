
```
$remote_addr 	10.0.0.1
- 				-
$remote_user 	-
[$time_local] 	[08/Oct/2020:10:27:44 +0800]
$request		GET /zhangya HTTP/1.1
$status 		404
$body_bytes_sent	555
$http_referer		-
$http_user_agent	Chrome
$http_x_forwarded_for -

```

操作步骤:
1.停止filebeat和nginx
```
systemctl stop filebeat nginx
```

2.清空Nginx日志
```
> /var/log/nginx/access.log
```

3.删除ES索引

4.修改Nginx日志为json格式:
```
vim /etc/nginx/nginx.conf
log_format json '{ "time_local": "$time_local", '
                          '"remote_addr": "$remote_addr", '
                          '"referer": "$http_referer", '
                          '"request": "$request", '
                          '"status": $status, '
                          '"bytes": $body_bytes_sent, '
                          '"http_user_agent": "$http_user_agent", '
                          '"x_forwarded": "$http_x_forwarded_for", '
                          '"up_addr": "$upstream_addr",'
                          '"up_host": "$upstream_http_host",'
                          '"upstream_time": "$upstream_response_time",'
                          '"request_time": "$request_time"'
    ' }';
    access_log  /var/log/nginx/access.log  json;
```
	
5.重启nginx
```
nginx -t 
systemctl restart nginx 
```

6.访问并测试
```
curl 127.0.0.1 
tail -f /var/log/nginx/access.log
```

```
确定修改后的日志结果:
{ 
  "time_local": "08/Oct/2020:11:10:17 +0800", 
  "remote_addr": "127.0.0.1", 
  "referer": "-", 
  "request": "GET / HTTP/1.1", 
  "status": 200, 
  "bytes": 5, 
  "agent": "curl/7.29.0", 
  "x_forwarded": "-", 
  "up_addr": "-",
  "up_host": "-",
  "upstream_time": "-",
  "request_time": "0.000"
}
```

7.修改filebeat配置文件
```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
  json.keys_under_root: true      #开启json格式支持
  json.overwrite_keys: true       #开启json格式支持

output.elasticsearch:
  hosts: ["10.0.0.51:9200"]
  index: "nginx-%{[agent.version]}-%{+yyyy.MM}"

setup.template.enabled: false
setup.ilm.enabled: false

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644

```

8.重启filebeat
```
systemctl restart filebeat
```

9.访问并测试

10.kibana删除旧索引,创建新索引