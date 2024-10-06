```shell
systemctl stop  firewalld   NetworkManager  

systemctl disable  firewalld   NetworkManager 

systemctl is-active  firewalld   NetworkManager  

systemctl is-enabled  firewalld   NetworkManager  
sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config 

setenforce 0

getenforce 
```
