```
[root@web-7 ~]# cat /etc/filebeat/filebeat.yml
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

output.redis:
  hosts: ["10.0.0.7"]
  key: "nginx-log"
  db: 0
  timeout: 5

setup.ilm.enabled: false
setup.template.enabled: false

```