clear screen
et echo on

drop table t;
create table t 
as
select owner, 
       object_id id1, cast( object_id as binary_double ) id2
  from all_objects
/

select owner, (sum(ln(id1))) - (sum(ln(id2)))  delta
  from t 
 group by owner
having (sum(ln(id1))) <> (sum(ln(id2))) 
/
pause

@trace
select (sum(ln(id1))) from t group by owner;
select (sum(ln(id2))) from t group by owner;
@connect /
!tk
