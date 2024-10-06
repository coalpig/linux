
docker 登录 

```
docker login abc.com
```


修改镜像标签  
```
docker tag nginx abc.com/app/nginx
```
  
11.推送镜像  
```
docker push abc.com/app/nginx
```


批量上传镜像到harbor
```
docker images|egrep "openjdk|mysql|maven|nginx"|awk '{print "docker tag",$1":"$2,"abc.com/base/"$1":"$2}'|bash
  
docker images|egrep "abc.com"|awk '{print "docker push "$1":"$2}'|bash
```




