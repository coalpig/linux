```
#logstash配置
cat > /etc/logstash/conf.d/redis-geoip.conf << 'EOF'
input {
  redis {
    host => "10.0.0.7"
    port => "6379"
    db => "0"
    key => "nginx-log"
    data_type => "list"
  }
}

filter {
  grok {
    match => { "message" => "%{IP:client_ip} - - \[%{HTTPDATE:access_time}\] \"%{DATA:method} %{DATA:uri} %{DATA:http}\" %{NUMBER:status_code:long} %{NUMBER:response_bytes:long} \"(-|%{DATA:referrer})\" \"(-|%{DATA:user_agent})\"" }

        remove_field => [ "message", "ecs" ]
  }

  geoip {
    source => "client_ip"
  }
}

output {
   stdout {}
   if "access" in [tags] {
      elasticsearch {
        hosts => "http://10.0.0.51:9200"
        manage_template => false
        index => "nginx-access-%{+yyyy.MM}"
      }
    }
    if "error" in [tags] {
      elasticsearch {
        hosts => "http://10.0.0.51:9200"
        manage_template => false
        index => "nginx-error-%{+yyyy.MM}"
      }
    }
}
EOF
```