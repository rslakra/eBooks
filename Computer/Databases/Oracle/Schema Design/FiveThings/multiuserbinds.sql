create table job_parameters
( jobid number primary key,
  iterations number,
  table_idx number );


create or replace procedure dont_bind( p_job in number )
as
    l_rec job_parameters%rowtype;
begin
    select * into l_rec from job_parameters where jobid = p_job;
    for i in 1 .. l_rec.iterations
    loop
        execute immediate
        'insert into t' || l_rec.table_idx || '
         values ( ' ||  i || ' )';
        commit;
    end loop;
    delete from job_parameters where jobid = p_job;
end;
/

create or replace procedure bind( p_job in number )
as
    l_rec job_parameters%rowtype;
begin
    select * into l_rec from job_parameters where jobid = p_job;
    for i in 1 .. l_rec.iterations
    loop
        execute immediate
        'insert into t' || l_rec.table_idx || ' values ( :x )' using i;
        commit;
    end loop;
    delete from job_parameters where jobid = p_job;
end;
/

create or replace procedure simulation
( p_procedure in varchar2, p_jobs in number, p_iters in number )
authid current_user
as
    l_job number;
    l_cnt number;
begin
    for i in 1 .. p_jobs
    loop
        begin
            execute immediate 'drop table t' || i;
        exception
            when others then null;
        end;
        execute immediate 'create table t' || i || ' ( x int )';
    end loop;

    for i in 1 .. p_jobs
    loop
        dbms_job.submit( l_job, p_procedure || '(JOB);' );
        insert into job_parameters
        ( jobid, iterations, table_idx )
        values ( l_job, p_iters, i );
    end loop;

    statspack.snap;
    commit;
    loop
        dbms_lock.sleep(30);
        select count(*) into l_cnt from job_parameters;
        exit when (l_cnt = 0);
    end loop;
    statspack.snap;
end;
/
