# 第1章 MySQL体系结构

## 1.MySQL的C/S模型工作结构

![img](./attachments/1717331700327-45a41f66-166a-4dac-acf1-a3d308ea7722.webp)

## 2.MySQL的实例架构

实例：mysqld + Master three + worker thread( IO/SQL/Purge... ) + 预分配内存结构

![img](./attachments/1717331700195-4e3a10eb-e082-4b1f-ae97-f1adb615701b.webp)

## 3.mysqld核心程序工作原理

### 3.1 分层结构

```plain
1.Server层类:似Linux的内核层
连接器
SQL层
2.Engine层:类似文件系统
```

### 3.2 分层原理图

![img](./attachments/1717331700305-e5ee1601-1eb1-41cd-8fd7-2c68027a3e7e.webp)

# 第2章 MySQL逻辑架构

## 1.MySQL逻辑结构和Linux对比

```plain
逻辑结构是为了更方便的操作物理结构

MySQL     Linux
库        目录
表        文件

Linux中一切皆文件
MySQL中一切皆表，一切皆SQL
```

## 2.MySQL逻辑对象的特点

```plain
库 ： 库名 + 库属性
表 ： 列(字段：列名，列属性) + 行（记录）+ 表属性
```

## 3.示意图

![img](./attachments/1717331700184-53b5fd0b-fbb7-4cb8-879a-dfe59dddae58.webp)

# 第3章 MySQL物理架构

## 1.MySQL物理结构

```plain
库：  磁盘上就是一个目录
表：  使用多个文件存储表的信息
```

## 2.MySQL的段，区，页

```plain
扇区、OS block、PAGE、extents 设计理念，都是为了能够从逻辑操作，到物理操作都能够保证尽可能“连续”IO。
程序  -----> OS -----> HDISK 

段 ： segments , 一个表就是一个段，由1-N个区构成。
区 ： extents,  又被称之为“簇”，由64个连续的PAGE构成。默认大小1M。
页 :  PAGE，MySQL 最小IO单元，默认大小 16KB，连续的4个OS block。
OS block : 文件系统块，默认是4KB，连续的8个扇区。
扇区     ： 默认512字节，连续的512字节长度的磁盘区域。
```

## 3.示意图

![img](./attachments/1717331700371-3621b93b-2815-4888-98a2-9821be6c7259.webp)