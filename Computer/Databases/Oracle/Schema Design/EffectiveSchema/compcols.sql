clear screen

drop type myTableType;

create or replace type myScalarType as object
( rnum number, cname varchar2(30), val varchar2(4000) )
/
create or replace type myTableType as table of myScalarType
/

create or replace 
function cols_as_rows( p_query in varchar2 ) return myTableType
-- this function is designed to be installed ONCE per database, and
-- it is nice to have ROLES active for the dynamic sql, hence the
-- AUTHID CURRENT_USER
authid current_user
-- this function is a pipelined function -- meaning, it'll send
-- rows back to the client before getting the last row itself
-- in 8i, we cannot do this
PIPELINED
as
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_descTbl       dbms_sql.desc_tab;
    l_rnum          number := 1;
begin
	-- parse, describe and define the query.  Note, unlike print_table
	-- i am not altering the session in this routine.  the 
	-- caller would use TO_CHAR() on dates to format and if they
	-- want, they would set cursor_sharing.  This routine would
	-- be called rather infrequently, I did not see the need
	-- to set cursor sharing therefore.
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );
    for i in 1 .. l_colCnt loop    
        dbms_sql.define_column( l_theCursor, i, l_columnValue, 4000 );
    end loop;

	-- Now, execute the query and fetch the rows.  Iterate over 
	-- the columns and "pipe" each column out as a separate row
	-- in the loop.  increment the row counter after each 
	-- dbms_sql row
    l_status := dbms_sql.execute(l_theCursor);
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
    loop
        for i in 1 .. l_colCnt 
        loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            pipe row 
            (myScalarType( l_rnum, l_descTbl(i).col_name, l_columnValue ));
        end loop;
        l_rnum := l_rnum+1;
    end loop;

	-- clean up and return...
    dbms_sql.close_cursor(l_theCursor);
    return;
end cols_as_rows;
/

select * 
  from TABLE( cols_as_rows('select * 
                              from emp 
                             where rownum = 1') );

REM 
REM column t1 format a30
REM column t2 format a30
REM 
REM select a.rnum, a.cname, a.val t1, b.val  t2
REM   from table( cols_as_rows( 'select * from user_tables where table_name = ''T1'' ' ) ) a,
REM        table( cols_as_rows( 'select * from user_tables where table_name = ''T2'' ' ) ) b
REM  where a.rnum = b.rnum 
REM    and a.cname = b.cname
REM    and ( a.val <> b.val or ((a.val is null or b.val is null) and a.val||b.val is not null) ) 
REM 
REM /
REM select a.rnum, a.cname, a.val t1, b.val  t2
REM   from table( cols_as_rows( 'select * from user_indexes where index_name = ''T1_PK'' ' ) ) a,
REM        table( cols_as_rows( 'select * from user_indexes where index_name = ''T2_PK'' ' ) ) b
REM  where a.rnum = b.rnum 
REM    and a.cname = b.cname
REM    and ( a.val <> b.val or ((a.val is null or b.val is null) and a.val||b.val is not null) ) 
REM 
REM /


create or replace function 
cols_as_rows8i( p_query in varchar2 ) return myTableType
authid current_user
as
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_descTbl       dbms_sql.desc_tab;
    l_data          myTableType := myTableType();
    l_rnum          number := 1;
begin
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    for i in 1 .. l_colCnt loop    
        dbms_sql.define_column( l_theCursor, i, l_columnValue, 4000 );
    end loop;
    l_status := dbms_sql.execute(l_theCursor);
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
    loop
        for i in 1 .. l_colCnt 
        loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            l_data.extend;
            l_data(l_data.count) := 
              myScalarType( l_rnum, l_descTbl(i).col_name, l_columnValue );
        end loop;
        l_rnum := l_rnum+1;
    end loop;

    dbms_sql.close_cursor(l_theCursor);
    return l_data;
end cols_as_rows8i;
/

select * 
  from TABLE( cast( cols_as_rows8i('select * 
                                      from emp 
                                     where rownum = 1')
                    as myTableType ) );
