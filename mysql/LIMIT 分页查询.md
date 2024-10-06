

查询中国所有的城市信息，并按照人口数从大到小排序输出，只显示前十名

```
select * 
from city 
where countrycode = 'CHN' 
order by population desc 
limit 10 ;
```

查询中国所有的城市信息，并按照人口数从大到小排序输出，只显示6-10名

```
select * 
from city 
where countrycode = 'CHN' 
order by population desc 
limit 5,5

select * 
from city 
where countrycode = 'CHN' 
order by population desc 
limit 5 offset 5;
```

解释:

```
-- limit M,N : 跳过M行，显示N行
-- limit N offset M : 跳过M行，显示N行
```