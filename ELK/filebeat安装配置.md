```
#下载地址
https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.9.1-x86_64.rpm

#安装
rpm -ivh filebeat-7.9.1-x86_64.rpm

#备份配置文件
cp /etc/filebeat/filebeat.yml /opt/

#修改配置文件
cat > /etc/filebeat/filebeat.yml << 'EOF'
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
output.elasticsearch:
  hosts: ["10.0.0.51:9200"]
EOF

#启动
systemctl start filebeat
```

