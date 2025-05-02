clear screen
set echo on
set linesize 121
drop table t;

clear screen
create table t ( str_date, date_date, number_date, data )
as
select to_char( dt+rownum,'yyyymmdd' ),
       dt+rownum,
       to_number( to_char( dt+rownum,'yyyymmdd' ) ),
	   rpad('*',45,'*')
  from (select to_date('01-jan-1995','dd-mon-yyyy') dt
          from all_objects)
/
create index t_str_date_idx on t(str_date);
create index t_date_date_idx on t(date_date);
create index t_number_date_idx on t(number_date);
pause

clear screen
begin
	dbms_stats.gather_table_stats
	( user, 'T', 
	  method_opt=> 'for all indexed columns', 
	  cascade=> true );
end;
/
pause
set autotrace on explain
clear screen
select * 
  from t
 where str_date between '20001231' and '20010101';
pause
clear screen
select * 
  from t
 where number_date between 20001231 and 20010101;
pause 
clear screen
select * from t where date_date 
    between to_date('20001231','yyyymmdd') and to_date('20010101','yyyymmdd');
set autotrace off
pause
clear screen
