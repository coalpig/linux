- 以挂载卷方式引用的configmap必须先于POD被创建，也就是说，这个POD启动时，configmap必须已经创建好了。
- 必须处于同一个命名空间的configmap才能被命名空间引用。
- configmap更新到POD里有一定延迟
- 一个confimap资源里可以有多个键值，这些键值也可以被单独的引用
- configmap只负责挂载配置，并不负责重启POD里的应用

