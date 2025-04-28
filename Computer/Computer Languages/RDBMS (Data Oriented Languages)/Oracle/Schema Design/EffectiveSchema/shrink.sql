clear screen
@connect /
compute sum of sum_blks on report
break on report
set echo on

drop table t;

clear screen
create table t 
ENABLE ROW MOVEMENT
as
select * 
  from all_objects;

select count(*) from t;
pause

clear screen
set autotrace on statistics
select count(*) from t;
set autotrace off
pause

clear screen
select blocks, count(*), sum(blocks) sum_blks
  from user_extents 
 where segment_name = 'T' group by blocks;
pause

clear screen
delete from t where mod(object_id,2) = 0;
commit;
pause

clear screen
alter table t shrink space compact;
alter table t shrink space;
pause

clear screen
select blocks, count(*), sum(blocks) sum_blks
  from user_extents 
 where segment_name = 'T' group by blocks;
pause

clear screen
set autotrace on statistics
select count(*) from t;
set autotrace off
