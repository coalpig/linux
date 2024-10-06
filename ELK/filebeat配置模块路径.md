```
cat > /etc/filebeat/filebeat.yml << 'EOF'
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: true

output.elasticsearch:
  hosts: ["http://10.0.0.51:9200"]
  indices:
    - index: "nginx-access-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        fileset.name: "access"
    - index: "nginx-error-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        fileset.name: "error"

setup.ilm.enabled: false
setup.template.enabled: false
EOF
```