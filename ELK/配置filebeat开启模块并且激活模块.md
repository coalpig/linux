
```
cat > /etc/filebeat/filebeat.yml << 'EOF'
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: true 

processors:
  - drop_fields:
      fields: ["ecs","log"]

output.elasticsearch:
  hosts: ["10.0.0.51:9200"]

  indices:
    - index: "nginx-access-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        event.dataset: "nginx.access"

    - index: "nginx-error-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        event.dataset: "nginx.error"

setup.ilm.enabled: false
setup.template.enabled: false

logging.level: info
logging.to_files: true
EOF

```

激活模块
```shell
filebeat modules list
filebeat modules enable nginx
filebeat modules list
```
