查询数据

### 2.1 查询数据库服务器配置参数

```
select @@port;
select @@server_id;
select @@basedir;
select @@datadir;
select @@socket;
select @@innodb_flush_log_at_trx_commit;
```

替代方法：

```
show variables;
show variables like '%trx%';
```

### 2.2 查询内置函数

```
help Functions;
select DATABASE();
select NOW();
select USER();
select CONCAT("hello world");
select user,host from mysql.user;
SELECT CONCAT("数据库用户:",USER,"@",HOST,";") FROM mysql.user;
```

### 2.3 多子句执行顺序

```
select     列   
from       表  
where      条件  
group by   列 
having     条件 
order by   列 
limit      条件
```

### 2.4 查询表中所有数据(小表)

```
use world;
select id,name,countrycode,district,population 
from city;
```

或者

```
select id,name,countrycode,district,population 
from world.city;
```

或者

select * from city;

### 2.5 查询部分列数据

导入提前准备好的数据文件

```
mysql -uroot -p123456 < world.sql
```

查询所有城市名及人口信息

```
select name,population from city;
```

查询city表中，所有中国的城市信息

```
select *  from city where countrycode = 'CHN';
```

查询人口数小于100人城市信息

```
SELECT * FROM city WHERE Population<100;
```

查询中国,人口数超过500w的所有城市信息

```
SELECT * FROM city WHERE countryCode='CHN' AND Population<5000000;
```

查询中国或美国的城市信息

```
SELECT * FROM city WHERE countryCode='CHN' OR countryCode='USA';

SELECT * FROM city WHERE countryCode IN ('CHN','USA');
```

查询人口数为100w-200w（包括两头）城市信息

```
SELECT * FROM city WHERE Population >= 1000000 AND Population <= 2000000;

SELECT * FROM city WHERE Population BETWEEN 1000000 AND 2000000;
```

查询中国或美国，人口数大于500w的城市

```
SELECT * FROM city WHERE (countryCode='CHN' OR countryCode='USA') AND Population > 5000000;

SELECT * FROM city WHERE countryCode IN ('CHN','USA') AND Population > 5000000;
```

查询城市名为qing开头的城市信息

```
SELECT * FROM city WHERE NAME LIKE 'qing%';
```