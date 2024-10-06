```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
  json.keys_under_root: true
  json.overwrite_keys: true


- type: log
  enabled: true
  paths:
    - /var/log/nginx/error.log

output.elasticsearch:
  hosts: ["10.0.0.51:9200"]
  indices:
    - index: "nginx-access%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        log.file.path: "access.log"  #根据路径配置索引

    - index: "nginx-error-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        log.file.path: "error.log"    #根据路径配置索引

setup.ilm.enabled: false
setup.template.enabled: false

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```