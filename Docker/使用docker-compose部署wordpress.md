

```
version: '3'
services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    user: 2000:2000
    environment:
      - "MYSQL_ROOT_PASSWORD=123"
      - "MYSQL_DATABASE=wordpress"
      - "MYSQL_USER=wordpress"
      - "MYSQL_PASSWORD=wordpress"
    volumes:
      - "/data/wordpress:/var/lib/mysql"
    ports:
      - "3306:3306"
    command:
      --character-set-server=utf8 
      --collation-server=utf8_bin
          
  nginx_php:
    image: nginx_php:v1
    container_name: nginx_php
    ports:
      - "80:80"
          
networks:
  default:
    external: true
    name: wordpress 
```
