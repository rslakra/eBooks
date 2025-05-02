@connect /

set termout off
@runstats
set termout on

set echo off
clear screen
prompt
prompt
prompt Bind variable comparision -- what happens when you DON'T use em 
prompt
prompt
set echo on
drop table t;
create table t ( x int, y char(80) );
pause

clear screen
create or replace procedure p1
as
begin
    for i in 1 .. 10000
    loop
        execute immediate '
        insert into t (x,y) values ( :x, :y )' using i, i;
    end loop;
end;
/
pause
clear screen
create or replace procedure p2
as
begin
    for i in 1 .. 10000
    loop
        execute immediate '
        insert into t (x,y) values 
		( ' || i || ', ''' || replace(i,'''','''''') || ''' )';
    end loop;
end;
/
pause

clear screen
exec runStats_pkg.rs_start
exec p1
exec runStats_pkg.rs_middle
exec p2
exec runStats_pkg.rs_stop(200)
