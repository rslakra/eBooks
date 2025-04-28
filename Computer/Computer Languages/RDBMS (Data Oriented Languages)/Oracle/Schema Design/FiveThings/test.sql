create table t1 ( x int primary key, y int )compress;
alter table t1 add z number;
alter table t1 drop column y;
alter table t1 set unused column y;
alter table t1 modify z number(12);
