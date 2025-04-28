clear screen
connect /
drop table t;

set echo on
set linesize 121

clear screen
create table t as
select 'Y' processed_flag, a.* from all_objects a;
pause

clear screen
create or replace view v
as
select t.*,
       case when processed_flag = 'N' then 'N'
            else NULL
        end processed_flag_indexed
  from t;

create index t_idx on
t( case when processed_flag = 'N' then 'N'
        else NULL
    end );
pause

clear screen
analyze index t_idx validate structure;

select name, del_lf_rows, lf_rows, lf_blks
  from index_stats;
pause

clear screen
update t set processed_flag = 'N'
  where rownum <= 100;

analyze index t_idx validate structure;

select name, del_lf_rows, lf_rows, lf_blks
  from index_stats;
pause
set termout off
select rowid, object_name
  from v
 where processed_flag_indexed = 'N'
   and rownum = 1;
set termout on
clear screen
set autotrace on
set pause on
select rowid, object_name
  from v
 where processed_flag_indexed = 'N'
   and rownum = 1;
set autotrace off
set pause off
pause
clear screen
