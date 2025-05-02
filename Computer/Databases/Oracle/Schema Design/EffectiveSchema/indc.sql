clear screen
drop table t1;
drop table idx_stats;
create or replace function is_number( p_str in varchar2 ) return number
as
	l_number number;
begin
	l_number := p_str;
	return 1;
exception
	when others then return 0;
end;
/
set echo on
clear screen
create table t1
as
select * from dba_objects;
insert /*+ append */ into t1 select * from t1;
commit;
insert /*+ append */ into t1 select * from t1;
commit;
pause

clear screen
create index uncompressed_idx
on t1( owner,object_type,object_name );
analyze index uncompressed_idx validate structure;
create table idx_stats as select * from index_stats;
pause

clear screen
drop index uncompressed_idx;
create index compressed_idx
on t1( owner,object_type,object_name )
COMPRESS 3;
analyze index compressed_idx validate structure;
insert into idx_stats select * from index_stats;
pause

clear screen
column val format a25
select * from idx_stats;
pause

clear screen
select * 
  from table(cols_as_rows('select * from idx_stats where rownum=1'))
 where rownum <= 10;
pause
column cname format a25
column t1 format a20
column t2 format a20
clear screen
set pause on
select a.cname, 
       decode( is_number(a.val),0,a.val,round(a.val,2)) t1, 
       decode( is_number(b.val),0,b.val,round(b.val,2)) t2,
	   case when is_number(a.val) = 1 and is_number(b.val) = 1
	        then to_char( decode(a.val,'0',null,round(b.val/a.val*100,2) ), '9,999.00' )
		 end pct
  from table( cols_as_rows( q'|select * 
                                 from idx_stats 
                                where name = 'UNCOMPRESSED_IDX' |' ) ) a,
       table( cols_as_rows( q'|select * 
                                 from idx_stats 
                                where name = 'COMPRESSED_IDX' |' ) ) b
     where a.cname = b.cname
/
set pause off
