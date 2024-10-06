```
rpm -ivh kibana-7.9.1-x86_64.rpm
cat > /etc/kibana/kibana.yml << 'EOF'
server.port: 5601
server.host: "10.0.0.51"
elasticsearch.hosts: ["http://10.0.0.51:9200"]
kibana.index: ".kibana"
EOF
systemctl start kibana
```