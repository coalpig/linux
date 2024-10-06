```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
  json.keys_under_root: true
  json.overwrite_keys: true
  tags: ["access"]

- type: log
  enabled: true
  paths:
    - /var/log/nginx/error.log
  tags: ["error"]

- type: log
  enabled: true
  paths:
    - /var/log/elasticsearch/elasticsearch.log
  multiline.pattern: ^\[ 
  multiline.negate: true
  multiline.match: after
  tags: ["es"]

output.elasticsearch:
  hosts: ["http://10.0.0.51:9200"]
  indices:
    - index: "nginx-access-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        tags: "access"

    - index: "nginx-error-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        tags: "error"

    - index: "es-%{[agent.version]}-%{+yyyy.MM}"
      when.contains:
        tags: "es"

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