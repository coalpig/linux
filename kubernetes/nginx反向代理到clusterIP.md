
实现的原理就是
```
server {
    listen       80;
    server_name  proxy.abc1.com;
    
    location / {
        proxy_pass http://ClusterIP; #注意这里要填ClusterIP
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen       80;
    server_name  proxy.abc2.com;
    
    location / {
        proxy_pass http://ClusterIP; #注意这里要填ClusterIP
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```