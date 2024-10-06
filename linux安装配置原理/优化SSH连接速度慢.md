```shell
sed -i '/#UseDNS yes/c UseDNS no' /etc/ssh/sshd_config

sed -i '/GSSAPIAuthentication/c GSSAPIAuthentication no' /etc/ssh/sshd_config

egrep -n '^(GSSAPIA|UseDNS)' /etc/ssh/sshd_config

systemctl restart sshd
```