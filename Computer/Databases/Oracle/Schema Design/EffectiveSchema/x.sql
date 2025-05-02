drop table t;

CREATE TABLE t
(
  dt  date,
  x   int,
  y   varchar2(25),
  primary key(dt)
)
organization index
PARTITION BY RANGE (dt)
subpartition by hash(x)
(
  PARTITION part1 VALUES LESS THAN (to_date('13-mar-2003','dd-mon-yyyy')) tablespace users,
  PARTITION part2 VALUES LESS THAN (to_date('14-mar-2003','dd-mon-yyyy')) tablespace tools,
  PARTITION junk VALUES LESS THAN (MAXVALUE)
)

/
