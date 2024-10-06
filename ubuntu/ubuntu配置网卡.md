修改网卡配置注意事项

```
1.ubuntu从17.10开始，已放弃在/etc/network/interfaces里固定IP的配置，即使配置也不会生效，而是改成netplan方式。
2.配置写在/etc/netplan/01-netcfg.yaml或者类似名称的yaml文件里。
3.修改配置以后不用重启，执行 netplan apply 命令可以让配置直接生效。
```

修改命令如下：

```
sudo vim /etc/netplan/00-installer-config.yaml 
# This is the network config written by 'subiquity'
network:
  ethernets:
     ens33:
        addresses:
        - 10.0.0.100/24
        gateway4: 10.0.0.2
        nameservers:
          addresses:
          - 10.0.0.2
          search:
          - 10.0.0.2
  version: 2
```

使配置生效命令如下：

```
sudo netplan apply
```


将网卡名eth0改为myeth0
```
sudo ip link set dev eth0 name myeth0
```
然后再修改以下配置文件网卡名称
