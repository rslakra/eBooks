clear screen
set echo on

@connect /
clear screen

create or replace procedure P 
as
  a positiven := 1 /* binary_integer subtypes */;
  b positiven := 1; 
  c positiven := 1; 
  d positiven:=1;
  t0 integer;
begin
  t0 := Dbms_Utility.Get_Time();
  for j in 1..1000000
  loop
    b := j /* pls_integer to binary_integer conversion */;
    d := 42 /* constant assignment within a loop */;
    c := d + b /* can be combined... */;
    a := b + c /* ...c not used except here */;
  end loop;
  Dbms_Output.Put_Line(Dbms_Utility.Get_Time()-t0);
end P;
/
exec p
exec p
