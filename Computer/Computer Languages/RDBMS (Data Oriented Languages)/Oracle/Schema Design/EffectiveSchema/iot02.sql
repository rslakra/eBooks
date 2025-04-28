clear screen
@connect iot_heap/iot_heap
set linesize 121
set echo on

 
REM drop table stock_ticker_iot;
REM drop table stock_ticker_heap;
clear screen
/*
create table stock_ticker_iot
( sym varchar2(4),
  dt  date,
  val number,
  primary key(sym,dt)
)
organization index
compress 1
/
create table stock_ticker_heap
( sym varchar2(4),
  dt  date,
  val number,
  primary key(sym,dt)
)
organization heap 
/
*/
pause

clear screen
/*
insert into stock_ticker_heap
select distinct substr(object_name,1,4), trunc(sysdate-50), 1 
  from all_objects;
commit;

begin
    for i in 1 .. 50
    loop
        insert into stock_ticker_heap
        select sym, dt+i, val+i 
          from stock_ticker_heap
         where dt = trunc(sysdate-50);
        commit;
    end loop;
end;
/
*/
pause

clear screen
/*
insert into stock_ticker_iot
select * from stock_ticker_heap;
commit;
exec dbms_stats.gather_table_stats( user, 'stock_ticker_iot', cascade=> true );
exec dbms_stats.gather_table_stats( user, 'stock_ticker_heap', cascade=> true );
*/
pause
set termout off
select avg(val) val
  from stock_ticker_heap
 where sym = :s;
select avg(val) val
  from stock_ticker_iot
 where sym = :s;
select dt, 
       avg(val) over (order by dt rows 5 preceding) val,
       count(*) over ( order by dt rows 5 preceding) cnt
  from stock_ticker_heap
 where sym = :s
   and dt > sysdate-20;
select dt, 
       avg(val) over (order by dt rows 5 preceding) val,
       count(*) over ( order by dt rows 5 preceding) cnt
  from stock_ticker_iot
 where sym = :s
   and dt > sysdate-20;

set termout on

clear screen
select count(*), count(distinct sym), count(distinct dt) 
  from stock_ticker_iot
/
variable s varchar2(4);
begin
   select sym into :s from stock_ticker_heap where rownum = 1;
end;
/
print s
pause

clear screen
set pagesize 999
set pause on
set autotrace on 
select avg(val) val
  from stock_ticker_heap
 where sym = :s;
pause

clear screen
select avg(val) val
  from stock_ticker_iot
 where sym = :s;
pause

clear screen
select dt, 
       avg(val) over (order by dt rows 5 preceding) val,
       count(*) over ( order by dt rows 5 preceding) cnt
  from stock_ticker_heap
 where sym = :s
   and dt > sysdate-20;
pause

clear screen
select dt, 
       avg(val) over (order by dt rows 5 preceding) val,
       count(*) over ( order by dt rows 5 preceding) cnt
  from stock_ticker_iot
 where sym = :s
   and dt > sysdate-20;
pause

clear screen
set pause off
set autotrace off
select segment_name, blocks from user_segments where segment_name like 'S%';

@connect /
pause
clear screen
