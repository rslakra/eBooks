clear screen
set echo on


@connect /
set linesize 121
column index_name format a30

drop table t1;
drop table t2;

clear screen
create table t1 as select * from all_objects;
alter table t1 add constraint t1_pk primary key(object_id);
alter table t1 add constraint check_gt_zero check (object_id>0);
create trigger t1_trigger before insert on t1
begin
	dbms_output.put_line( 'hello world' );
end;
/
grant select on t1 to scott;
pause

clear screen
select 'indexes', index_name 
  from user_indexes where table_name = 'T1'
union all
select 'constraints', constraint_name 
  from user_constraints where table_name = 'T1'
union all
select 'triggers', trigger_name 
  from user_triggers where table_name = 'T1'
union all
select 'grants', grantee||'/'||privilege
  from user_tab_privs
 where table_name = 'T1';
pause

clear screen
create table t2
partition by hash(object_id) partitions 8
as
select * from t1 where 1=0;
exec dbms_redefinition.can_redef_table( user, 'T1' );
pause

clear screen
exec dbms_redefinition.start_redef_table( user, 'T1', 'T2' )
pause

clear screen
variable nerrors number
begin
	dbms_redefinition.copy_table_dependents
	( user, 'T1', 'T2', 
	  copy_indexes => dbms_redefinition.cons_orig_params,
	  num_errors => :nerrors );
end;
/
print nerrors
pause

clear screen
select table_name, 'indexes', index_name 
  from user_indexes where table_name in ('T1','T2')
union all
select table_name, 'constraints', constraint_name 
  from user_constraints where table_name in ('T1','T2')
union all
select table_name, 'triggers', trigger_name 
  from user_triggers where table_name in ('T1','T2')
union all
select table_name, 'grants', grantee||'/'||privilege
  from user_tab_privs
 where table_name in ('T1','T2');
pause

clear screen
exec dbms_redefinition.finish_redef_table( user, 'T1', 'T2' );
drop table t2;
pause

clear screen
select 'indexes', index_name 
  from user_indexes where table_name = 'T1'
union all
select 'constraints', constraint_name 
  from user_constraints where table_name = 'T1'
union all
select 'triggers', trigger_name 
  from user_triggers where table_name = 'T1'
union all
select 'grants', grantee||'/'||privilege
  from user_tab_privs
 where table_name = 'T1';
pause

clear screen
select dbms_metadata.get_ddl( 'TABLE', 'T1' ) from dual;
