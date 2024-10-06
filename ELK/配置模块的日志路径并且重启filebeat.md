
```
cat > /etc/filebeat/modules.d/nginx.yml << 'EOF'
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log"]
EOF
```

重启filebeat
```
systemctl restart filebeat
```