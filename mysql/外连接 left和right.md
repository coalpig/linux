### 外连接 left join , right join

```
mysql> select * from teacher left join course on teacher.tno=course.tno; 
+-----+--------+------+--------+------+
| tno | tname  | cno  | cname  | tno  |
+-----+--------+------+--------+------+
| 101 | oldboy | 1001 | linux  |  101 |
| 102 | hesw   | 1002 | python |  102 |
| 103 | oldguo | 1003 | mysql  |  103 |
| 104 | oldx   | NULL | NULL   | NULL |
| 105 | oldw   | NULL | NULL   | NULL |
+-----+--------+------+--------+------+
5 rows in set (0.00 sec)

mysql> select * from teacher right join course on teacher.tno=course.tno;    
+------+--------+------+--------+-----+
| tno  | tname  | cno  | cname  | tno |
+------+--------+------+--------+-----+
|  101 | oldboy | 1001 | linux  | 101 |
|  102 | hesw   | 1002 | python | 102 |
|  103 | oldguo | 1003 | mysql  | 103 |
| NULL | NULL   | 1004 | k8s    | 108 |
+------+--------+------+--------+-----+
4 rows in set (0.00 sec)
```
