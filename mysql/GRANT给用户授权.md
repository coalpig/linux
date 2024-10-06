格式说明:

```
GRANT   ALL PRIVILEGES  ON    *.*    TO   'root'@'10.0.0.%'  IDENTIFIED BY '123456';
授权         权限        ON   权限范围  TO   允许用户登陆的主机    创建密码
```

授权举例：创建远程管理员权限

```
GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.0.0.%'  IDENTIFIED BY '123';
```

授权举例：授权一个普通用户 test@'10.0.0.%' ,权限为 select 、update、delete、insert，范围：test.*

```
grant select,update,delete,insert on test.*  to test@'10.0.0.%' identified by '123';
show grants for test@'10.0.0.%';
```