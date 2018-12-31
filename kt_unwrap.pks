CREATE OR REPLACE package kt_unwrap
is
type varchar2_table is table of varchar2(32767);
function unwrap(name in varchar2, type in varchar2 default 'PACKAGE BODY', owner in varchar2 default user)
  return varchar2_table
  pipelined;
  
function get_all_source  return number;
end;
/
