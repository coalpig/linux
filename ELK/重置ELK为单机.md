```
systemctl stop elasticsearch.service

rm -rf /var/lib/elasticsearch/*

cat > /etc/elasticsearch/elasticsearch.yml << 'EOF'    
node.name: node-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 127.0.0.1,10.0.0.51
http.port: 9200
discovery.seed_hosts: ["10.0.0.51"]
cluster.initial_master_nodes: ["10.0.0.51"]
EOF

systemctl restart elasticsearch.service 

systemctl stop kibana.service

rm -rf /var/lib/kibana/*

cat > /etc/kibana/kibana.yml << 'EOF'
server.port: 5601
server.host: "10.0.0.51"
elasticsearch.hosts: ["http://10.0.0.51:9200"]
kibana.index: ".kibana"
EOF

systemctl start kibana
```