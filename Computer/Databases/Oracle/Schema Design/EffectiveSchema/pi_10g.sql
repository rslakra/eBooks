clear screen
set echo on

@connect /
set echo on
clear screen

create or replace function pi return number
as
    subtype my_number is BINARY_DOUBLE;
    last_pi my_number := 0;
    delta   my_number := 0.000001;
    pi      my_number := 1;
    denom   my_number := 3;
    oper    my_number := -1;
    negone  my_number := -1;
    two     my_number := 2;
begin
    loop
        last_pi := pi;
        pi := pi + oper * 1/denom;
        exit when (abs(last_pi-pi) <= delta );
        denom := denom + two;
        oper := oper * negone;
    end loop;
    return pi * 4;
end;
/
pause

set timing on
exec dbms_output.put_line( pi );
exec dbms_output.put_line( pi );
exec dbms_output.put_line( pi );
set timing off
