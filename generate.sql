create table test_source as select * from dba_source;
create table test_unwrapped_full ( type varchar2(30), object_name varchar(30), line number, text varchar2(4000) );


declare 
 i number;
begin
    i := kt_unwrap.get_all_source;
end;
/

