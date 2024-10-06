---
tags:
  - ansible/剧本
---

```
1.安装mysql
yum install mysql

yum:
  name: mariadb-server
  state: installed

2.启动
systemctl start mysql

systemd:
  name: mariadb
  state: started
  
3.创建root账号密码
mysqladmin password

- name: create root password
  mysql_user:
    name: root
    password: 123
    login_unix_socket: /var/run/mysqld/mysqld.sock

4.创建数据库
create database wordpress;

- name: Create database
  mysql_db:
    login_user: root
	login_password: 123
    name: wordpress
    state: presen

5.创建远程授权账号
mysql -uroot -p123
grant all privileges on wordpress.* to wordpress@'172.16.1.%' identified by 'wordpress';

- name: Create database user
  mysql_user:
    login_user: root
	login_password: 123
    name: wordpress
    password: wordpress
	host: 172.16.1.%
    priv: 'wordpress.*:ALL'
    state: present

6.导入数据库
mysql -uroot -p123 < web.sql

- name: Restore database ignoring errors
  mysql_db:
    login_user: root
	login_password: 123
    name: wordpress
    state: import
    target: /tmp/web.sql
    force: yes

7.重启数据库
systemctl start mysql

systemd:
  name: mariadb
  state: restarted


-----------------------------------------------
1.安装mysql
- name: install mysql
  yum:
    name: mariadb-server
    state: installed

2.copy配置文件
- name: copy conf
  template:
    src: my.cnf.j2
	dest: /etc/my.cnf

3.导入数据库
- name: Restore database ignoring errors
  mysql_db:
    name: wordpress
    state: import
    target: /tmp/web.sql
    force: yes
	
4.重启数据库
systemd:
  name: mariadb
  state: restarted
```




