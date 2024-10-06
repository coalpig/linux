

官方文档：

https://kubernetes.io/zh/docs/reference/using-api/#api-versioning

### 2.1 API概述

```
REST API 是 Kubernetes 的基本结构。 
所有操作和组件之间的通信及外部用户命令都是调用 API 服务器处理的 REST API。 
因此，Kubernetes 平台视一切皆为 API 对象， 且它们在 API 中有相应的定义。
```

### 2.2 API版本控制

```
JSON 和 Protobuf 序列化模式遵循相同的模式更改原则。 以下描述涵盖了这两种格式。
 
API 版本控制和软件版本控制是间接相关的。 API 和发布版本控制提案 描述了 API 版本控制和软件版本控制间的关系。

不同的 API 版本代表着不同的稳定性和支持级别。 你可以在 API 变更文档 中查看到更多的不同级别的判定标准。
```

版本级别说明：

- Alpha:

- 版本名称包含 `alpha`（例如，`v1alpha1`）。
- 软件可能会有 Bug。启用某个特性可能会暴露出 Bug。 某些特性可能默认禁用。
- 对某个特性的支持可能会随时被删除，恕不另行通知。
- API 可能在以后的软件版本中以不兼容的方式更改，恕不另行通知。
- 由于缺陷风险增加和缺乏长期支持，建议该软件仅用于短期测试集群。

- Beta:

- 版本名称包含 `beta` （例如， `v2beta3`）。
- 软件被很好的测试过。启用某个特性被认为是安全的。 特性默认开启。
- 尽管一些特性会发生细节上的变化，但它们将会被长期支持。
- 在随后的 Beta 版或稳定版中，对象的模式和（或）语义可能以不兼容的方式改变。 当这种情况发生时，将提供迁移说明。 模式更改可能需要删除、编辑和重建 API 对象。 编辑过程可能并不简单。 对于依赖此功能的应用程序，可能需要停机迁移。
- 该版本的软件不建议生产使用。 后续发布版本可能会有不兼容的变动。 如果你有多个集群可以独立升级，可以放宽这一限制。

- Stable:

- 版本名称如 `vX`，其中 `X` 为整数。
- 特性的稳定版本会出现在后续很多版本的发布软件中。

### 2.3 API 组

[API 组](https://git.k8s.io/community/contributors/design-proposals/api-machinery/api-group.md) 能够简化对 Kubernetes API 的扩展。 API 组信息出现在REST 路径中，也出现在序列化对象的 `apiVersion` 字段中。

以下是 Kubernetes 中的几个组：

- 核心组的 REST 路径为 `/api/v1`。 核心组并不作为 `apiVersion` 字段的一部分，例如， `apiVersion: v1`。
- 指定的组位于 REST 路径 `/apis/$GROUP_NAME/$VERSION`， 并且使用 `apiVersion: $GROUP_NAME/$VERSION` （例如， `apiVersion: batch/v1`）。 你可以在 [Kubernetes API 参考文档](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#-strong-api-groups-strong-) 中查看全部的 API 组。

所有API组官方说明地址：

https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#-strong-api-groups-strong-

### 2.4 查看API组信息

我们可以使用以下kubectl命令查看API组的信息：

查看所有的API组：

```
kubectl get --raw /
```

查看指定组的信息：

```
#默认返回的格式是没有json格式化的
kubectl get --raw /api/v1

#可以安装jq命令来格式化返回的json数据
kubectl get --raw /api/v1|jq|grep '"name"'

#查看app组信息
kubectl get --raw /apis/apps/v1|jq|grep '"name"'
```
