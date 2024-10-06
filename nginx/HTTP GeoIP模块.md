---
tags:
  - Nginx/模块
---

> 官方文档

https://nginx.org/en/docs/http/ngx_http_geoip_module.html

https://github.com/leev/ngx_http_geoip2_module

- ~ 版本区别

**ngx_http_geoip_module** 和 **ngx_http_geoip2_module** 都是 Nginx 用于地理位置识别的模块，但它们使用不同版本的 MaxMind GeoIP 数据库，并有一些关键的技术和功能差异。

>ngx_http_geoip_module

- **数据源**：使用的是较旧的 MaxMind GeoIP 数据库（现在称为 GeoIP Legacy）。
- **功能**：支持基于 IP 地址的国家和城市定位，以及其他一些基本的地理信息，如地区、互联网服务提供商（ISP）等。
- **配置**：相对简单，主要是在 Nginx 配置文件中指定数据库文件的位置，并设置相应的变量。
- **限制**：不支持较新的 GeoIP2 数据库格式，功能上相对有限。

>ngx_http_geoip2_module

- **数据源**：使用的是更新的 MaxMind GeoIP2 数据库，也支持 GeoLite2 数据库，提供更精准和更详细的地理位置数据。
- **功能**：除了支持国家和城市定位外，还支持更多细致的数据，如邮政编码、经纬度、时区等。
- **配置**：配置更灵活，支持多种查询和多个数据库同时使用，能够定义复杂的条件和输出更多的变量。
- **兼容性**：兼容 GeoIP2 和 GeoLite2 数据格式，与 MaxMind 的最新数据库和 API 保持一致。

- ~ 主要技术差异

1. **数据库格式**：**ngx_http_geoip2_module** 能够使用更现代的数据库格式（mmdb），而 **ngx_http_geoip_module** 使用的是旧格式（dat）。
2. **功能丰富度**：GeoIP2 提供更丰富的数据和更精细的控制，而 GeoIP Legacy 主要集中在基础的国家和城市数据。
3. **配置灵活性**：**ngx_http_geoip2_module** 在配置上提供更多的灵活性，支持条件判断和复杂的配置设置。

- ~ 升级建议

由于 MaxMind 已经停止更新 GeoIP Legacy 数据库，推荐使用 **ngx_http_geoip2_module**，尤其是在新的部署和需要更详尽数据的应用场景中。这不仅确保了更好的数据准确性和详细程度，也保证了对未来可能的数据库格式或 API 变化的兼容性。

使用 **ngx_http_geoip2_module** 通常需要在编译 Nginx 时明确添加此模块，并确保有适当的 GeoIP2 或 GeoLite2 数据库文件。这为提供基于地理位置的定制内容、安全控制和用户分析等功能提供了支持。

- ~ 关键指令

Syntax:	geoip_country file;

Default:	—

Context:	http



Syntax:	geoip_city file;

Default:	—

Context:	http



Syntax:	geoip_proxy address | CIDR;

Default:	—

Context:	http

This directive appeared in versions 1.3.0 and 1.2.1.



Syntax:	geoip_proxy_recursive on | off;

Default:	

geoip_proxy_recursive off;

Context:	http

- ~ 指令解释

**geoip_country**  file         国家信息的 GeoIP 数据库文件的路径

**geoip_city** file              城市级地理位置查找的数据库文件的路径

**geoip_proxy** address   告诉Nginx哪些是Nginx代理的IP

**geoip_proxy_recursive** on    Nginx 知道在解析代理链中的 IP 地址时，哪些 IP 是代理 IP（这些是不需要进一步解析为客户端位置的），并且确保只有代理之外的 IP 地址被认为是实际的客户端 IP 地址

- ~ 参考配置

>geoip

http {

​    geoip_country         GeoIP.dat;

​    geoip_city                GeoLiteCity.dat;

​    geoip_proxy            192.168.100.0/24;

​    geoip_proxy_recursive on;

​    ....

>geoip2

http {

​    \# 指定 GeoIP2 数据库文件的位置，这里使用的是城市数据库

​    geoip2 /etc/nginx/geoip/GeoLite2-City.mmdb {

​        \# 从 GeoLite2-City 数据库中获取国家ISO代码，并将其存储在变量$geoip2_metadata_country_iso_code中

​        $geoip2_metadata_country_iso_code country iso_code;

​        \# 从 GeoLite2-City 数据库中获取城市名称（英文），并将其存储在变量$geoip2_data_city_name中

​        $geoip2_data_city_name city names en;

​    }



​    \# 指定另一个 GeoIP2 数据库文件的位置，这次使用的是国家数据库

​    geoip2 /etc/nginx/geoip/GeoLite2-Country.mmdb {

​        \# 从 GeoLite2-Country 数据库中获取国家ISO代码，并将其存储在变量$geoip2_data_country_code中

​        $geoip2_data_country_code country iso_code;

​    }



​    \# 定义一个服务器监听请求

​    server {

​        \# 定义处理所有请求的位置块

​        location / {

​            \# 如果从IP解析得到的国家代码为"CN"（中国），则重定向到特定的中国域名

​            if ($geoip2_data_country_code = 'CN') {

​                return 302 http://cn.example.com$request_uri;

​            }



​            \# 如果不满足上述条件，将请求转发到后端服务器

​            proxy_pass http://backend;

​        }

​    }

}

- ~ 日志解析变量

>geoip

"geoip_country_code": "$geoip_country_code"

>geoip2

log_format main '$remote_addr - $remote_user [$time_local] "$request" '

​                '$status $body_bytes_sent "$http_referer" '

​                '"$http_user_agent" "$http_x_forwarded_for" '

​                'country=$geoip2_data_country_code city="$geoip2_data_city_name"';



access_log /var/log/nginx/access.log main;

- ~ 配置步骤

>第一步：下载GeoIP的数据库文件

![](attachments/GeoLite2-Country_20240524.tar.gz)

![](attachments/GeoLite2-City_20240524.tar.gz)

tar zxf GeoLite2-Country_20240524.tar.gz -C /opt/

tar zxf GeoLite2-City_20240524.tar.gz -C /opt/

>第二步：编译安装libmaxminddb依赖

![](attachments/libmaxminddb-1.9.1.tar.gz)

yum install gcc -y

![](attachments/libmaxminddb-1.9.1.tar_2.gz)

wget https://github.com/maxmind/libmaxminddb/releases/download/1.9.1/libmaxminddb-1.9.1.tar.gz

tar zxf libmaxminddb-1.9.1.tar.gz

cd libmaxminddb

./configure

make

make check

make install

echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf

ldconfig

>第三步：编译ngx_http_geoip2_module模块

![](attachments/ngx_http_geoip2_module-master.zip)

>下载ngx_http_geoip2_module模块

wget ![](attachments/ngx_http_geoip2_module-3.4.tar.gz)

tar zxf ngx_http_geoip2_module-3.4.tar.gz -C /opt/

ls -l /opt/ngx_http_geoip2_module-3.4

>下载Nginx源码


yum install openssl-devel pcre-devel -y

groupadd -g 1000 www

useradd -u 1000 -g 1000 -M -s /sbin/nologin www

wget https://nginx.org/download/nginx-1.26.0.tar.gz

tar zxf nginx-1.26.0.tar.gz

cd nginx-1.26.0

>动态编译方法（二选一）

进入nginx源码目录

cd nginx-1.26.0

./configure --with-compat --add-dynamic-module=/opt/ngx_http_geoip2_module-3.4

make modules

ls -l objs/ngx_http_geoip2_module.so

可以将编译后的文件复制到其他目录

mkdir /opt/ngx_module

cp objs/ngx_http_geoip2_module.so /opt/ngx_module/

ls -l /opt/ngx_module/

在Nginx主配置文件里添加动态加载模块

load_module /opt/ngx_module/ngx_http_geoip2_module.so;

>静态编译方法（二选一）

静态编译模块

cd nginx-1.26.0

./configure --user=www --group=www --prefix=/opt/nginx-1.26.0 --with-http_stub_status_module --with-http_ssl_module --with-pcre --add-module=/opt/ngx_http_geoip2_module-3.4

make

make install

编译完成后需要替换掉原来的nginx文件

 cp objs/nginx /opt/nginx-1.26.0/sbin/nginx

检查新命令是否加入了模块

[root@web-7 /mnt/nginx-1.26.0]# /opt/nginx-1.26.0/sbin/nginx -V

nginx version: nginx/1.26.0

built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)

built with OpenSSL 1.0.2k-fips  26 Jan 2017

TLS SNI support enabled

configure arguments: --user=www --group=www --prefix=/opt/nginx-1.26.0 --with-http_stub_status_module --with-http_ssl_module --with-pcre --add-module=/opt/ngx_http_geoip2_module-3.4

>第四步：修改Nginx配置添加GeoIP解析字段

[root@VM-12-17-centos nginx-1.26.0]# cat /opt/nginx-1.26.0/conf/nginx.conf

user  www;

worker_processes  1;



events {

​    worker_connections  1024;

}





http {

​    include       mime.types;

​    default_type  application/octet-stream;



​    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '

​                      '$status $body_bytes_sent "$http_referer" '

​                      '"$http_user_agent" "$http_x_forwarded_for" '

​                      'country=$geoip2_data_country_code city="$geoip2_data_city_name"';





​    access_log  logs/access.log  main;



​    sendfile        on;

​    \#tcp_nopush     on;



​    keepalive_timeout  65;



​    gzip  on;



​    geoip2 /opt/GeoLite2-Country_20240524/GeoLite2-Country.mmdb {

​        auto_reload 5m;

​        $geoip2_metadata_country_build metadata build_epoch;

​        $geoip2_data_country_code default=US source=$remote_addr country iso_code;

​        $geoip2_data_country_name country names en;

​    }



​    geoip2 /opt/GeoLite2-City_20240524/GeoLite2-City.mmdb {

​        $geoip2_data_city_name default=London city names en;

​    }



​    server {

​        listen       8080;

​        server_name  localhost;



​        location / {

​            root   html;

​            index  index.html index.htm;

​        }

​    }

}

>第七步：访问并测试

74.122.101.12 - - [26/May/2024:18:08:05 +0800] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36" "-" country=TR city="Istanbul"



211.72.89.21 - - [26/May/2024:18:08:31 +0800] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36" "-" country=TW city="Kaohsiung City"