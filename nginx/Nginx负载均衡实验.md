---
tags:
  - nginx/负载均衡
---

- ~ 1.根据域名配置转发

需求：

```plain
blog.abc.com  --> blog_pool
kod.abc.com --> kod_pool
```

多个负载均衡池配的反向代理配置：

```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
upstream blog_pool {
	server 10.0.0.7;
}

upstream kod_pool {
    server 10.0.0.8;
}

server {
    listen       80;
    server_name  blog.abc.com;
    
    location / {
        proxy_pass http://blog_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen       80;
    server_name  kod.abc.com;
    
    location / {
        proxy_pass http://kod_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

EOF
systemctl restart nginx
```

两个域名访问相同负载均衡地址池：

```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
upstream web_pool {
	server 10.0.0.7;
	server 10.0.0.8;
}


server {
    listen       80;
    server_name  blog.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen       80;
    server_name  kod.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

EOF
systemctl restart nginx
```

精简配置:
 
```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
upstream web_pool {
	server 10.0.0.7;
	server 10.0.0.8;
}

server {
    listen       80;
    server_name  blog.abc.com kod.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

systemctl restart nginx
```

- ~ 2.动静分离

所有图片类型的数据都转发到 专门的图片服务器

```plain
upstream static {
    server 172.16.1.7;
    server 172.16.1.8;
}

upstream web {
    server 172.16.1.8;
    server 172.16.1.9;
    server 172.16.1.10;
    server 172.16.1.11;
}

server {
    listen 80;
    server_name blog.abc.com;
    
    location / {
    	  proxy_pass http://web;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    location ~ \.(gif|jpg|jpeg|png|bmp|swf|css|js)$ {
    	  proxy_pass http://static;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
