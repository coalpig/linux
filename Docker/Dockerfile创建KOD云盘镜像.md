
```
基于Dockerfile构建云盘镜像

1.先创建目录
[root@docker-11 ~]# cd dockerfile/
[root@docker-11 ~/dockerfile]# ls
nginx_base
[root@docker-11 ~/dockerfile]# mkdir kod
[root@docker-11 ~/dockerfile]# cd kod/
[root@docker-11 ~/dockerfile/kod]# 

2.收集配置文件
mkdir conf
cd conf
cat > local.repo << EOF
[local]
name=local
enable=1
gpgcheck=0
baseurl=http://10.0.0.100
EOF
docker cp b7757c17bf36:/etc/php-fpm.d/www.conf  .
docker cp b7757c17bf36:/etc/nginx/conf.d/cloud.conf  .
docker cp b7757c17bf36:/etc/supervisord.conf  .
docker cp b7757c17bf36:/etc/supervisord.d/nginx_php.ini  .

3.准备代码目录
mkdir code/
cd code
docker cp b7757c17bf36:/code/ .
tar zcvf code.tar.gz code

4.编写Dockerfile
FROM centos:7
RUN rm -rf /etc/yum.repos.d/*
ADD conf/local.repo /etc/yum.repos.d/local.repo
RUN yum install nginx php-fpm php-mbstring php-gd supervisor -y
ADD conf/www.conf /etc/php-fpm.d/www.conf
ADD conf/cloud.conf /etc/nginx/conf.d/cloud.conf
ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx_php.ini /etc/supervisord.d/nginx_php.ini
ADD code/code.tar.gz /
RUN chown -R nginx:nginx /code/
EXPOSE 80
CMD ["supervisord","-c","/etc/supervisord.conf"]

5.构建镜像
docker build -t kod:v2 .

6.启动容器测试
docker run -d --name kod_v1 -p 8080:80 kod:v1 
```
