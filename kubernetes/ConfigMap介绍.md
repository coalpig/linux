1）为什么要用configMap？

将配置文件和POD解耦，为了方便修改配置而不需要重新制作镜像，将配置文件单独的存储在k8s的数据库里，然后相应的Pod只需要挂在并引用即可。

2）congiMap里的配置文件是如何存储的？

键值对  
key:value  
  
文件名:配置文件的内容

3）configMap支持的配置类型

直接定义的键值对  
基于文件创建的键值对

4）configMap创建方式

命令行  
资源配置清单

5）configMap的配置文件如何传递到POD里

变量传递  
数据卷挂载

6）使用configMap的限制条件

1.ConfigMap必须在Pod之前创建，Pod才能引用他  
2.ConfigMap受限于命名空间限制，只有处于同一个命名空间中的Pod才可以被引用
