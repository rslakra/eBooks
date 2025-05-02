clear screen
set echo on

@connect /

drop table emp;

clear screen
create table emp as select * from scott.emp;
create or replace type ename_type as table of varchar2(30)
/
pause

clear screen
column enames format a40
select deptno, cast( collect(ename) as ename_type ) enames
  from emp
 group by deptno;
