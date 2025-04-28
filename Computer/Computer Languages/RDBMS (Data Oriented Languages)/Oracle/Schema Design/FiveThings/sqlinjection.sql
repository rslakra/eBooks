drop table user_table;
set echo on
clear screen
create table user_table 
( username varchar2(30), password varchar2(30) );

insert into user_table values ( 'tom', 'top_secret_password' );
insert into user_table values ( 'sue', 'top_secret_password' );

commit;
pause

set echo off
clear screen
accept Uname prompt "Enter username: "
prompt enter things like  
prompt x' or 'x' = 'x
prompt x' or decode( rownum,1,'x') = 'x
accept Pword prompt "Enter password: "
set echo on

select count(*)
  from user_table
 where username = '&Uname'
   and password = '&Pword'
/
pause

clear screen
variable uname varchar2(30);
variable pword varchar2(30);
exec :uname := 'tom'
exec :pword := 'x'' or ''x'' = ''x'
pause 

select count(*)
  from user_table
 where username = :uname
   and password = :pword
/

