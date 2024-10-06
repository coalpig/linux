```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
  json.keys_under_root: true
  json.overwrite_keys: true

output.elasticsearch:
  hosts: ["10.0.0.51:9200"]
  index: "nginx-%{[agent.version]}-%{+yyyy.MM}"

setup.template.enabled: false  #新解析的JSON字段覆盖现有字段
setup.ilm.enabled: false       #如果日志内容是JSON格式，将JSON键提升为顶级字段

logging.level: info     #打开filebeat日志
logging.to_files: true
logging.files:
  path: /var/log/filebeat  #打开filebeat日志
  name: filebeat
  keepfiles: 7
  permissions: 0644
```