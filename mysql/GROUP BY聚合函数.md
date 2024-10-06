### 3.1 聚合函数

```
count()            统计数量
sum()              求和
avg()              平均数
max()              最大值
min()              最小值
group_concat()     列转行
```

### 3.2 group by 分组功能原理

```
1.按照分组条件进行排序
2.进行分组列的去重复
3.聚合函数将其他列的结果进行聚合。
```

示意图：

![](attachments/Pasted%20image%2020240904132556.png)


### 3.3 group by练习

统计city表的行数

```
SELECT COUNT(*) FROM city;
```

统计中国城市的个数

```
SELECT COUNT(*) FROM city WHERE countryCode='CHN';
```

统计中国的总人口数

```
SELECT SUM(Population) FROM city WHERE countryCode='CHN';
```

统计每个国家的城市个数

```
SELECT countryCode,COUNT(NAME) FROM city GROUP BY countryCode;
```

统计每个国家的总人口数

```
SELECT countryCode,SUM(Population) FROM city GROUP BY countryCode;
```

统计中国每个省的城市个数及城市名列表

```
SELECT district, COUNT(NAME),GROUP_CONCAT(NAME)
FROM city 
WHERE countrycode='CHN'  GROUP BY district;
```