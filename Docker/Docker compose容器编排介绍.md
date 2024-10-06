
docker-compose介绍

```
Compose 是用于定义和运行多容器 Docker 应用程序的工具。
通过Compose，您可以使用YML文件来配置应用程序需要的所有服务。
写好yaml文件之后，只需要运行一条命令，就会按照资源清单里的配置运行相应的容器服务。
```

Compose 使用的三个步骤：

```
1.使用 Dockerfile 定义应用程序的环境。
2.使用 docker-compose.yml 定义构成应用程序的服务，这样它们可以在隔离环境中一起运行。
3.最后，执行 docker-compose up 命令来启动并运行整个应用程序。
```

官方版本说明:

```
https://docs.docker.com/compose/compose-file/compose-versioning/
```


