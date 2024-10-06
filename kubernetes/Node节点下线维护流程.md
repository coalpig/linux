

### 下线流程

如果我们的Node节点需要关机维护，那么这时候正确的处理流程应该是如何呢？我们首先要确保新的Pod不会被调度到需要下线的节点，其次再将需要下线的节点上的Pod驱逐到其他节点上，等维护好之后再重新配置可以调度。流程梳理如下：

1.配置该Node不可被调度

2.驱逐Node上正在运行的Pod

3.下线节点进行维护

4.维护好后开机启动服务

5.恢复该Node可以被正常调度

### 设置节点不可被调度

```
kubectl cordon node2
```

### 驱逐节点的Pod

前面提到的NoExecute这个Taint效果对节点上正在运行的Pod有以下影响：

- 没有设置NoExecute的Pod会立刻被驱逐
- 配置了对应Toleration的Pod，如果没有为tolerationSeconds赋值，则会一直留在这一节点中。

```
kubectl taint node node2 test=node2:NoExecute
```

### 节点重新被调度

```
kubectl uncordon node2
```
