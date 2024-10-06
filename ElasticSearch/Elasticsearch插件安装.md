> [!info]- elasticsearch-head介绍
> 
> ```
> 官方地址：
> https://github.com/mobz/elasticsearch-head
> 
> elasticsearch-head是一款用来管理Elasticsearch集群的第三方插件工具。
> elasticsearch-Head插件在5.0版本之前可以直接以插件的形式直接安装，但是5.0以后安装方式发生了改变，需要nodejs环境支持，或者直接使用别人封装好的docker镜像，更推荐的是谷歌浏览器的插件。
> ```

> [!info]- elasticsearch-head的三种安装方式
> 
> ```
> 1.npm安装方式
> 2.docker安装
> 3.google浏览器插件（推荐）
> ```

> [!install]- docker安装elasticsearch-head
> 
> ```
> docker run -p 9100:9100 mobz/elasticsearch-head:7
> ```

> [!install]- npm安装elasticsearch-head
> 
> ```
> cd /opt/
> wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz
> tar xf node-v12.13.0-linux-x64.tar.xz
> mv node-v12.13.0-linux-x64 node
> echo 'export PATH=$PATH:/opt/node/bin' >> /etc/profile
> source /etc/profile 
> npm -v
> node -v 
> 
> git clone git://github.com/mobz/elasticsearch-head.git
> unzip elasticsearch-head-master.zip
> cd elasticsearch-head-master
> 
> npm install -g cnpm --registry=https://registry.npm.taobao.org
> cnpm install
> cnpm run start
> ```

> [!config]- 修改Elasticsearch配置文件，添加如下参数并重启
> 
> 
> ```
> http.cors.enabled: true 
> http.cors.allow-origin: "*"
> ```

> [!config]- 谷歌浏览器插件安装
> 
> 
> 更多工具-->拓展程序-->开发者模式-->选择解压缩后的插件目录
> 


