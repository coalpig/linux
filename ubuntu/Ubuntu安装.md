## 修改网卡名称为eth0(可选)

出现logo后按F5键，然后按ESC键下方就会出BOOT的内容，添加如下内容即可修改网卡名称为传统的eth0,修改完后按回车键。

F5不行按e也可以
```
net.ifnames=0 biosdevname=0
```


![](attachments/Pasted%20image%2020240815194957.png)


