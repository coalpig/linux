

目前我们已经知道可以对资源进行操作了，但是我们还需要再了解几个概念才能在k8s创建RBAC资源。

### Rule 规则

角色就是一组权限的集合

### Role和ClusterRole 角色和集群角色

Role

```
Role定义的规则只适用单个命名空间，也就是和namespace关联的。
在创建Role时，必须指定该Role所属的名字空间。
```

ClusterRole

```
与之相对，ClusterRole 则是一个集群作用域的资源。
这两种资源的名字不同（Role 和 ClusterRole）是因为 Kubernetes 对象要么是名字空间作用域的，要么是集群作用域的，不可两者兼具。

ClusterRole 有若干用法。你可以用它来：
1.定义对某个命名空间域对象的访问权限，并将在各个命名空间内完成授权；
2.为命名空间作用域的对象设置访问权限，并跨所有命名空间执行授权；
3.为集群作用域的资源定义访问权限。
```

总结：

```
如果你希望在名字空间内定义角色，应该使用 Role； 
如果你希望定义集群范围的角色，应该使用 ClusterRole。
```

### RoleBinding和ClusterRoleBinding 角色绑定和集群角色绑定

Subject 主题

k8s里定义了3中主题资源，分别是user,group和Service Account

User Account和Service Account

```
User Account：
用户账号，用户是外部独立服务管理的，不属于k8s内部的API

ServiceAccount：
也是一种账号，但他并不是给k8s集群的用户用的，而是给运行Pod里的进程用的，他为Pod里的进程提供了必要的身份证明。
```

[https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/service-accounts-admin/](https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/service-accounts-admin/)

![](https://cdn.nlark.com/yuque/0/2024/png/830385/1725849383267-2efba75b-a91a-4250-8fd6-58f72d3c1adf.png?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_46%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)

RoleBinding和ClusterRoleBinding

```
角色绑定（Role Binding）是将角色中定义的权限赋予一个或者一组用户。 
它包含若干 主体（用户、组或服务账户）的列表和对这些主体所获得的角色的引用。 

RoleBinding 在指定的名字空间中执行授权，
ClusterRoleBinding 在集群范围执行授权。
```

### RBAC关系图

![](https://cdn.nlark.com/yuque/0/2024/png/830385/1725447127633-aeb9cfd9-47ee-4ad3-9dcd-c112f2365fbb.png?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_27%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)

