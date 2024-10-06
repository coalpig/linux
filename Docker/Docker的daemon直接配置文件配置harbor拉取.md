```
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://abc.com/"]
}
EOF
```

推送到harbor的 library
```
docker tag openjdk:9 abc.com/library/openjdk:9
docker push abc.com/library/openjdk:9
```