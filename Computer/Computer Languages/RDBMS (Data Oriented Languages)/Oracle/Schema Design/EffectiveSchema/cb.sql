clear screen
set echo on

@connect /

drop table emp;

clear screen
create table emp as select * from scott.emp;
pause

column empname format a15
column scbp format a23

set feedback off
clear screen
select rpad('*',2*level,'*')||ename empname, 
       sys_connect_by_path(ename,'/') scbp,
       connect_by_root empno "root empno", connect_by_isleaf  "is leaf"
  from emp
 start with ename in ( 'CLARK', 'BLAKE', 'JONES' )
 connect by prior empno = mgr
/
pause
set feedback on


clear screen
update emp 
   set mgr = ( select empno 
                 from emp 
                where ename = 'SMITH' ) 
 where ename = 'JONES';
pause

set feedback off
clear screen
select rpad('*',2*level,'*')||ename empname,
       sys_connect_by_path(ename,'/') scbp,
       connect_by_root ename "root ename",
       connect_by_isleaf  "is leaf"
  from emp
 start with ename in ( 'CLARK', 'BLAKE', 'JONES' )
 connect by prior empno = mgr
/
pause
set feedback on

set feedback off
clear screen
select rpad('*',2*level,'*')||ename empname,
       sys_connect_by_path(ename,'/') scbp,
       connect_by_root ename "root ename",
       connect_by_isleaf  "is leaf", connect_by_iscycle cycle
  from emp
 start with ename in ( 'CLARK', 'BLAKE', 'JONES' )
 connect by NOCYCLE prior empno = mgr
/
pause
set feedback on
