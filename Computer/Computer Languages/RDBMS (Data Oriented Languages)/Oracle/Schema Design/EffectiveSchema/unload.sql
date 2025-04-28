clear screen
@connect /
set linesize 121

set echo off
drop table t
/
drop table all_objects_unload
/
!msu -u ora10g rm /tmp/allobjects.dat
set echo on
clear screen

create or replace directory tmp as '/tmp'
/
pause

create table all_objects_unload
organization external
( type oracle_datapump
  default directory TMP
  location( 'allobjects.dat' )
)
as
select * from all_objects
/
pause

clear screen
!head /tmp/allobjects.dat
pause

select count(*) 
  from all_objects_unload
/
select owner, object_name, object_type 
  from all_objects_unload
 where rownum < 5;

pause


drop table all_objects_unload;

create table t
( OWNER            VARCHAR2(30),
  OBJECT_NAME      VARCHAR2(30),
  SUBOBJECT_NAME   VARCHAR2(30),
  OBJECT_ID        NUMBER,
  DATA_OBJECT_ID   NUMBER,
  OBJECT_TYPE      VARCHAR2(19),
  CREATED          DATE,
  LAST_DDL_TIME    DATE,
  TIMESTAMP        VARCHAR2(19),
  STATUS           VARCHAR2(7),
  TEMPORARY        VARCHAR2(1),
  GENERATED        VARCHAR2(1),
  SECONDARY        VARCHAR2(1)
)
organization external
( type oracle_datapump
  default directory TMP
  location( 'allobjects.dat','allobjects.dat' )
)
/
pause

select count(*) from t
/

