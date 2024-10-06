


如何配置Pipelines来
https://www.elastic.co/guide/en/beats/filebeat/current/multiline-examples.html


首先还原nginx配置文件的日志格式



重启nginx

检查日志是否还原
```
tail -f /var/log/nginx/access.log
```


```
10.0.0.1 - - [13/Aug/2024:11:27:09 +0800] "GET /favicon.ico HTTP/1.1" 404 555 "http://10.0.0.7/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36" "-"
```

注释filebeat的配置文件中的jason格式转换

```
  json.keys_under_root: true
  json.overwrite_keys: true
```

重启filebeat检查是否重启成功


开始拆解
可以使用kibana 中的console里面的grok debugger来检查
![](attachments/Pasted%20image%2020240813113139.png)


纵向拆解
```
127.0.0.1  %{IP:clientip}  
-  -  
-  -  
[13/Aug/2024:10:36:26 +0800]  [%{HTTPDATE:access_time}]  
" "  
GET  %{DATA:method}  
/  %{DATA:uri}  
HTTP/1.1 %{DATA:http}  
"  "  
200  %{NUMBER:status_code:long}  
6  %{NUMBER:response_bytes:long}  
"-"  "(-|%{DATA:referrer})"  
"curl/7.29.0"  "(-|%{DATA:user_agent})"  
"-" "(-|%{IP:x_forwarded})"
```

横向拆解
```
%{IP:clientip} - - [%{HTTPDATE:access_time}] "%{DATA:method} %{DATA:uri} %{DATA:http}" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} "(-|%{DATA:referrer})" "(-|%{DATA:user_agent})" "(-|%{IP:x_forwarded})"
```


拆解中出现的问题

```
首先[需要转义
```

```
%{IP:clientip} - - \[%{HTTPDATE:access_time}\] "%{DATA:method} %{DATA:uri} %{DATA:http}" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} "(-|%{DATA:referrer})" "(-|%{DATA:user_agent})" "(-|%{IP:x_forwarded})"
```


检查成功

![](attachments/Pasted%20image%2020240813113842.png)

在console测试
```
GET _ingest/pipeline
PUT _ingest/pipeline/pipeline-nginx-access
{
  "description": "nginx access log",
  "processors": [
    {
      "grok": {
        "field": "message",
        "patterns": [
          "%{IP:clientip} - - \\[%{HTTPDATE:access_time}\\] \"%{DATA:method} %{DATA:uri} %{DATA:http}\" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} \"(-|%{DATA:referrer})\" \"(-|%{DATA:user_agent})\" \"(-|%{IP:x_forwarded})\""
        ]
      }
    },
    {
      "remove": {
        "field": "message"
      }
    }
  ]
}
```


```
        "patterns": [
          "%{IP:clientip} - - \\[%{HTTPDATE:access_time}\\] \"%{DATA:method} %{DATA:uri} %{DATA:http}\" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} \"(-|%{DATA:referrer})\" \"(-|%{DATA:user_agent})\" \"(-|%{IP:x_forwarded})\""
        ]
          #转移[需要两个\\，因为\也是特殊字符，做一个两次转移
          #转移"只需要一个\
```

全选覆盖
```
 {
        "field": "message",
        "patterns": [
          "%{IP:clientip} - - \\[%{HTTPDATE:access_time}\\] \"%{DATA:method} %{DATA:uri} %{DATA:http}\" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} \"(-|%{DATA:referrer})\" \"(-|%{DATA:user_agent})\" \"(-|%{IP:x_forwarded})\""
        ]
      }
```


