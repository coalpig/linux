```
部署keepalived
1.master1配置步骤
yum install -y keepalived
cat >/etc/keepalived/keepalived.conf <<EOF
global_defs {
    router_id master-01
}
vrrp_script CheckMaster {
    script "curl -k https://10.0.0.10:6443"
    interval 3
    timeout 9
    fall 2
    rise 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 50
    priority 150
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass 111111
    }

    virtual_ipaddress {
        10.0.0.10/24 dev eth0
    }

    track_script {
        CheckMaster
    }
}
EOF
systemctl enable keepalived && systemctl restart keepalived
service keepalived status


2.master2配置步骤
yum install -y keepalived
cat >/etc/keepalived/keepalived.conf <<EOF
global_defs {
    router_id master-02
}
vrrp_script CheckMaster {
    script "curl -k https://10.0.0.10:6443"
    interval 3
    timeout 9
    fall 2
    rise 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 50
    priority 100
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass 111111
    }

    virtual_ipaddress {
        10.0.0.10/24 dev eth0
    }

    track_script {
        CheckMaster
    }
}
EOF
systemctl enable keepalived && systemctl restart keepalived
service keepalived status


3.master3配置步骤
yum install -y keepalived
cat >/etc/keepalived/keepalived.conf <<EOF
global_defs {
    router_id master-03
}
vrrp_script CheckMaster {
    script "curl -k https://10.0.0.10:6443"
    interval 3
    timeout 9
    fall 2
    rise 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 50
    priority 50
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass 111111
    }

    virtual_ipaddress {
        10.0.0.10/24 dev eth0
    }

    track_script {
        CheckMaster
    }
}
EOF
systemctl enable keepalived && systemctl restart keepalived
service keepalived status

```