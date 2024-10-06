内连接 join 取交集

```
mysql> select * from teacher join course on teacher.tno=course.tno ;
+-----+--------+------+--------+-----+
| tno | tname  | cno  | cname  | tno |
+-----+--------+------+--------+-----+
| 101 | oldboy | 1001 | linux  | 101 |
| 102 | hesw   | 1002 | python | 102 |
| 103 | oldguo | 1003 | mysql  | 103 |
+-----+--------+------+--------+-----+
3 rows in set (0.00 sec)

mysql> select * from teacher,course where teacher.tno=course.tno;
+-----+--------+------+--------+-----+
| tno | tname  | cno  | cname  | tno |
+-----+--------+------+--------+-----+
| 101 | oldboy | 1001 | linux  | 101 |
| 102 | hesw   | 1002 | python | 102 |
| 103 | oldguo | 1003 | mysql  | 103 |
+-----+--------+------+--------+-----+
3 rows in set (0.00 sec)
```
