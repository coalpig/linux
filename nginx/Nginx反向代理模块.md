---
tags:
  - Nginx/模块
  - Nginx/反向代理
---
- ~ 1.官方地址

```plain
https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass
```

- ~ 2.关键指令

```plain
proxy_pass http://要转发到的后端服务器IP地址;	

proxy_set_header Host $http_host;		#lb服务器将用户访问网站的HOST信息传递后后端的web服务器
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;	#将用户的真实IP传递给后端的web服务器
proxy_set_header X-Forwarded-Proto $scheme;   # 确保后端应用程序知道原始请求是通过什么类型的协议发起的

proxy_connect_timeout 30;				#代理与后端服务器连接超时时间(代理连接超时)
proxy_read_timeout 60;					#代理等待后端服务器的响应时间
proxy_buffering on;						  #把后端返回的内容先放到缓冲区当中，然后再返回给客户端,边收边传,不是全部接收完再传给客户端
proxy_buffer_size 32k;					#设置nginx代理保存用户头信息的缓冲区大小
proxy_buffers 4 128k;					  #proxy_buffers缓冲区
```

- ~ 3.配置举例

简单代理配置：

```plain
location / {
    proxy_pass http://10.0.0.7;
    proxy_set_header Host $http_host;
	  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

完善代理配置：

```plain
location / {
    # 主要的代理传递指令
    proxy_pass http://10.0.0.7;
    
    # 设置头信息，确保后端可以接收到正确的客户端数据
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # WebSocket 支持
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    # 连接与超时设置
    proxy_connect_timeout 30s;  # 后端服务器连接超时时间
    proxy_read_timeout 60s;     # 从后端服务器读取数据的超时时间
    proxy_send_timeout 60s;     # 发送请求到后端服务器的超时时间

    # 缓存和性能优化
    proxy_buffering on;        # 启用缓存响应内容
    proxy_buffers 16 32k;      # 调整缓存大小
    proxy_buffer_size 64k;     # 单个连接的缓冲区大小
}
```

- ~ 2.反向代理到单台web服务器

> 2.1 实验环境

```plain
lb-5  Nginx反向代理
web-7 web服务器
```

> 2.2 web-7部署测试环境

```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
server {
    listen       80;
    server_name  proxy.abc.com;
    
    location / {
        root  /code/proxy;
        index index.html;
    }
}
EOF
mkdir /code/proxy -p
echo web-7 > /code/proxy/index.html
chown -R www:www /code/
systemctl restart nginx
```

> 2.3 lb-5安装Nginx

```plain
cat > /etc/yum.repos.d/nginx.repo << 'EOF'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
yum install nginx -y
```

> 2.4 lb-5编写Nginx反向代理配置文件

```plain
groupadd -g 1000 www
useradd -u 1000 -g 1000 -M -s /sbin/nologin www
sed -i '/^user/c user  www;' /etc/nginx/nginx.conf
rm -rf /etc/nginx/conf.d/default.conf

cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
server {
    listen       80;
    server_name  proxy.abc.com;
    
    location / {
        proxy_pass http://10.0.0.7;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

systemctl restart nginx
```

> 2.5 windows修改hosts解析

```plain
10.0.0.5 proxy.abc.com
```


## 第5章 反向代理参数配置优化

- ~ 未优化前

```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
upstream web_pool {
	server 10.0.0.7;
	server 10.0.0.8;
}

server {
    listen       80;
    server_name  kod.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	      proxy_connect_timeout 30;
        proxy_send_timeout 60;
        proxy_read_timeout 60;
        proxy_buffering on;
        proxy_buffer_size 32k;
        proxy_buffers 4 128k;
    }
}

server {
    listen       80;
    server_name  blog.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        proxy_set_header Host $http_host;
	      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	      proxy_connect_timeout 30;
        proxy_send_timeout 60;
        proxy_read_timeout 60;
        proxy_buffering on;
        proxy_buffer_size 32k;
        proxy_buffers 4 128k;
    }
}
EOF

systemctl restart nginx
```

- ~ 优化步骤

第一步：将相同的代理参数写入到一个文件里

```plain
cat > /etc/nginx/proxy_params << 'EOF'
proxy_set_header Host $http_host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_connect_timeout 30;
proxy_send_timeout 60;
proxy_read_timeout 60;
proxy_buffering on;
proxy_buffer_size 32k;
proxy_buffers 4 128k; 
EOF
```

第二步：跳转的配置文件里包含即可

```plain
cat > /etc/nginx/conf.d/proxy.conf << 'EOF'
upstream web_pool {
	server 10.0.0.7;
	server 10.0.0.8;
}

server {
    listen       80;
    server_name  kod.abc.com blog.abc.com;
    
    location / {
        proxy_pass http://web_pool;
        include proxy_params;
    }
}
EOF

systemctl restart nginx
```
