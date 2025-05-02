drop table t;
CREATE TABLE t
(
  sym varchar2(4),
  dt  date,
  x   int,
  y   varchar2(25),
  primary key(sym,dt)
)
organization index
PARTITION BY RANGE (dt)
(
  PARTITION part1 VALUES LESS THAN (to_date('13-mar-2003','dd-mon-yyyy')) ,
  PARTITION part2 VALUES LESS THAN (to_date('14-mar-2003','dd-mon-yyyy')) ,
  PARTITION junk VALUES LESS THAN (MAXVALUE)
)
/
