clear screen
@connect /

set echo off
drop table compressed
/
drop table uncompressed
/
drop table all_objects_unload
/
set echo on

clear screen
create or replace directory tmp as '/tmp'
/
exec utl_file.FREMOVE( 'TMP', 'allobjects.dat' );
pause
clear screen
!ls -l /tmp/allobjects.dat
create table all_objects_unload
organization external
( type oracle_datapump
  default directory TMP
  location( 'allobjects.dat' )
)
as
select * from dba_objects
/
!ls -l /tmp/allobjects.dat
pause

clear screen
create table uncompressed
pctfree 0
as
select *
  from all_objects_unload
 order by owner, object_type, object_name;

exec dbms_stats.gather_table_stats( user, 'UNCOMPRESSED' );
pause

clear screen
create table compressed
COMPRESS
as
select *
  from all_objects_unload
 order by owner, object_type, object_name;

exec dbms_stats.gather_table_stats( user, 'COMPRESSED' );
pause

clear screen
select cblks comp_blks, uncblks uncomp_blks,
       round(cblks/uncblks*100,2) pct
  from (
select max(decode(table_name,'COMPRESSED',blocks,null)) cblks,
  max(decode(table_name,'UNCOMPRESSED',blocks,null)) uncblks
  from user_tables
 where table_name in ( 'COMPRESSED', 'UNCOMPRESSED' )
       )
/
pause

clear screen
drop table compressed;
create table compressed
COMPRESS
as
select *
  from all_objects_unload
 order by dbms_random.random;

exec dbms_stats.gather_table_stats( user, 'COMPRESSED' );
pause

clear screen
select cblks comp_blks, uncblks uncomp_blks,
       round(cblks/uncblks*100,2) pct
  from (
select max(decode(table_name,'COMPRESSED',blocks,null)) cblks,
  max(decode(table_name,'UNCOMPRESSED',blocks,null)) uncblks
  from user_tables
 where table_name in ( 'COMPRESSED', 'UNCOMPRESSED' )
       )
/
pause

clear screen
column val format a30
select * from table( cols_as_rows( q'|
select
count(OWNER) OWNER_cnt,
count(distinct OWNER) OWNER_dcnt,
max(vsize(OWNER)) OWNER_sz,
count(OBJECT_NAME) OBJECT_NAME_cnt,
count(distinct OBJECT_NAME) OBJECT_NAME_dcnt,
max(vsize(OBJECT_NAME)) OBJECT_NAME_sz,
count(SUBOBJECT_NAME) SUBOBJECT_NAME_cnt,
count(distinct SUBOBJECT_NAME) SUBOBJECT_NAME_dcnt,
max(vsize(SUBOBJECT_NAME)) SUBOBJECT_NAME_sz,
count(OBJECT_ID) OBJECT_ID_cnt,
count(distinct OBJECT_ID) OBJECT_ID_dcnt,
max(vsize(OBJECT_ID)) OBJECT_ID_sz,
count(DATA_OBJECT_ID) DATA_OBJECT_ID_cnt,
count(distinct DATA_OBJECT_ID) DATA_OBJECT_ID_dcnt,
max(vsize(DATA_OBJECT_ID)) DATA_OBJECT_ID_sz,
count(OBJECT_TYPE) OBJECT_TYPE_cnt,
count(distinct OBJECT_TYPE) OBJECT_TYPE_dcnt,
max(vsize(OBJECT_TYPE)) OBJECT_TYPE_sz,
count(CREATED) CREATED_cnt,
count(distinct CREATED) CREATED_dcnt,
max(vsize(CREATED)) CREATED_sz,
count(LAST_DDL_TIME) LAST_DDL_TIME_cnt,
count(distinct LAST_DDL_TIME) LAST_DDL_TIME_dcnt,
max(vsize(LAST_DDL_TIME)) LAST_DDL_TIME_sz,
count(TIMESTAMP) TIMESTAMP_cnt,
count(distinct TIMESTAMP) TIMESTAMP_dcnt,
max(vsize(TIMESTAMP)) TIMESTAMP_sz,
count(STATUS) STATUS_cnt,
count(distinct STATUS) STATUS_dcnt,
max(vsize(STATUS)) STATUS_sz,
count(TEMPORARY) TEMPORARY_cnt,
count(distinct TEMPORARY) TEMPORARY_dcnt,
max(vsize(TEMPORARY)) TEMPORARY_sz,
count(GENERATED) GENERATED_cnt,
count(distinct GENERATED) GENERATED_dcnt,
max(vsize(GENERATED)) GENERATED_sz,
count(SECONDARY) SECONDARY_cnt,
count(distinct SECONDARY) SECONDARY_dcnt,
max(vsize(SECONDARY)) SECONDARY_sz
from all_objects_unload
|' ) ) ;
pause


clear screen
drop table compressed;
create table compressed
COMPRESS
as
select *
  from all_objects_unload
 order by timestamp, owner, object_type, status;

exec dbms_stats.gather_table_stats( user, 'COMPRESSED' );
pause

clear screen
select cblks comp_blks, uncblks uncomp_blks,
       round(cblks/uncblks*100,2) pct
  from (
select max(decode(table_name,'COMPRESSED',blocks,null)) cblks,
  max(decode(table_name,'UNCOMPRESSED',blocks,null)) uncblks
  from user_tables
 where table_name in ( 'COMPRESSED', 'UNCOMPRESSED' )
       )
/
pause
clear screen
