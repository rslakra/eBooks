clear screen
@connect iot_heap/iot_heap
set linesize 121
set echo on

 
drop table stock_ticker_iot;
drop table stock_ticker_heap;
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
insert into stock_ticker_heap
select distinct substr(object_name,1,4), trunc(sysdate-50), 1 
  from all_objects;

update stock_ticker_heap set sym = 'ORCL' where sym = '/100'
/
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
insert into stock_ticker_iot
select * from stock_ticker_heap;
commit;
exec dbms_stats.gather_table_stats( user, 'stock_ticker_iot', cascade=> true );
exec dbms_stats.gather_table_stats( user, 'stock_ticker_heap', cascade=> true );

