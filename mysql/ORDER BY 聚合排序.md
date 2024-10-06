

查询所有城市信息，并按照人口数排序输出

```
SELECT * FROM city ORDER BY population;
```

查询中国所有的城市信息，并按照人口数从大到小排序输出

```
SELECT * FROM city WHERE countryCode='CHN' ORDER BY population DESC;
```

每个国家的总人口数，总人口超过5000w的信息,并按总人口数从大到小排序输出

```
SELECT countrycode,SUM(population)
FROM city
GROUP BY countrycode
HAVING SUM(population) > 50000000
ORDER BY SUM(population) DESC;
```