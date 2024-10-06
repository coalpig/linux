MySQL中不能重复授权。是相加关系。

```
revoke delete on test.* from 'test'@'10.0.0.%' ;
show grants for test@'10.0.0.%';
```
