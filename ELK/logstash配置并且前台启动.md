```

#安装
rpm -ivh logstash-7.9.1.rpm

#logstash配置
cat > /etc/logstash/conf.d/redis.conf << 'EOF'
input {
  redis {
    host => "10.0.0.7"
    port => "6379"
    db => "0"
    key => "nginx-log"
    data_type => "list"
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

#前台测试启动
/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/redis.conf
```