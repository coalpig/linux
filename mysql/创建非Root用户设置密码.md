创建用户(不包含权限)
create user 用户名@'登录主机地址'
create user 用户名@'登录主机地址' identified by '密码';

```
#创建账号
create user abc@'10.0.0.%';

#创建用户的同时设置密码
create user abc@'10.0.0.%' identified by 'abc';

```