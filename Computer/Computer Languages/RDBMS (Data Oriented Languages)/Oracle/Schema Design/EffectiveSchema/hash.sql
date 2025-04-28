clear screen
drop table hash_lookup;
drop table heap_lookup;
drop cluster hash_cluster;
set echo on

clear screen
create cluster Hash_Cluster
( id number )
SINGLE TABLE
hashkeys 50000   -- number of distinct lookups we expect over time
size 125         -- size of data associated with key
/
pause


clear screen
create table heap_lookup
( OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID,
  DATA_OBJECT_ID, OBJECT_TYPE, CREATED, LAST_DDL_TIME,
  TIMESTAMP, STATUS, TEMPORARY, GENERATED, SECONDARY, 
  primary key(object_id) 
)
as
select * from all_objects;

create table hash_lookup
( OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID,
  DATA_OBJECT_ID, OBJECT_TYPE, CREATED, LAST_DDL_TIME,
  TIMESTAMP, STATUS, TEMPORARY, GENERATED, SECONDARY, 
  primary key(object_id)
)
cluster hash_cluster(object_id)
as
select * from heap_lookup;
pause
clear screen
begin
    dbms_stats.gather_table_stats
    ( user, 'HEAP_LOOKUP', cascade=>true );
    dbms_stats.gather_table_stats
    ( user, 'HASH_LOOKUP', cascade=>true );
end;
/
pause

clear screen
declare
    type array is table of number;
    l_object_ids array;
    l_rec        heap_lookup%rowtype;
begin
    select object_id bulk collect into l_object_ids
      from heap_lookup;

    execute immediate q'|
        alter session set events '10046 trace name context forever, level 12'
    |';

    for k in 1 .. l_object_ids.count 
    loop
        select * into l_rec 
          from heap_lookup 
         where object_id = l_object_ids(k);
        select * into l_rec 
          from hash_lookup 
         where object_id = l_object_ids(k);
    end loop;
end;
/
pause
@connect /
!tkprof `ls -t $ORACLE_HOME/admin/$ORACLE_SID/udump/*ora_*.trc | head -1` tk.prf sys=no
edit tk.prf
clear screen
