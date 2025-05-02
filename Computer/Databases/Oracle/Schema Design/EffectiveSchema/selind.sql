clear screen
set tab off
drop table project;
set echo off

clear screen
prompt The goal is to make TEAMID, JOB unique across ACTIVE projects
prompt
prompt
prompt
set echo on
create table project
(project_ID number primary key,
 teamid number,
 job varchar2(100),
 status varchar2(20) check (status in ('ACTIVE', 'INACTIVE'))
);
pause

clear screen
create UNIQUE index
job_unique_in_teamid on project
( case when status = 'ACTIVE' then teamid else null end,
  case when status = 'ACTIVE' then job    else null end
)
/
pause

clear screen
insert into project 
(project_id, teamid,   job, status) values
(         1,    100, 'job', 'INACTIVE' );
insert into project 
(project_id, teamid,   job, status) values
(         2,    100, 'job', 'INACTIVE' );
pause
insert into project 
(project_id, teamid,   job, status) values
(         3,    100, 'job', 'ACTIVE' );
pause
insert into project 
(project_id, teamid,   job, status) values
(         4,    100, 'job', 'ACTIVE' );
