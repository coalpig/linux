### 作用

主要应用在group by之后需要的判断。


统计每个国家的总人口数，只显示总人口超过1亿人的信息

```
SELECT countrycode,SUM(population)  
FROM city 
GROUP BY countrycode 
HAVING SUM(population)>100000000;
```