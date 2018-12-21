-- for non-partitioned table
select --owner
--      ,table_name
      column_name
      ,data_type
      ,decode (nullable,'N','Y','N')  M
      ,num_distinct num_vals
      ,num_nulls
      ,density dnsty
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(low_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(low_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(low_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(low_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(low_value))
  ,'DATE',to_char(1780+to_number(substr(low_value,1,2),'XX')
         +to_number(substr(low_value,3,2),'XX'))||'-'
       ||to_number(substr(low_value,5,2),'XX')||'-'
       ||to_number(substr(low_value,7,2),'XX')||' '
       ||(to_number(substr(low_value,9,2),'XX')-1)||':'
       ||(to_number(substr(low_value,11,2),'XX')-1)||':'
       ||(to_number(substr(low_value,13,2),'XX')-1)
,  low_value
       ) low_v
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(high_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(high_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(high_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(high_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(high_value))
  ,'DATE',to_char(1780+to_number(substr(high_value,1,2),'XX')
         +to_number(substr(high_value,3,2),'XX'))||'-'
       ||to_number(substr(high_value,5,2),'XX')||'-'
       ||to_number(substr(high_value,7,2),'XX')||' '
       ||(to_number(substr(high_value,9,2),'XX')-1)||':'
       ||(to_number(substr(high_value,11,2),'XX')-1)||':'
       ||(to_number(substr(high_value,13,2),'XX')-1)
,  high_value
       ) hi_v
from dba_tab_columns
where owner      like upper('&tab_own')
and   table_name like upper(nvl('&tab_name','WHOOPS')||'%')
ORDER BY owner,table_name,COLUMN_ID;


-- for partitioned table
select cs.owner,
      cs.table_name,
      cs.partition_name,
      cs.column_name
      ,t.data_type
      ,decode (t.nullable,'N','Y','N')  M
      ,cs.num_distinct num_vals
      ,cs.num_nulls
      ,cs.density dnsty
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(cs.low_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(cs.low_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(cs.low_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(cs.low_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(cs.low_value))
  ,'DATE',to_char(1780+to_number(substr(cs.low_value,1,2),'XX')
         +to_number(substr(cs.low_value,3,2),'XX'))||'-'
       ||to_number(substr(cs.low_value,5,2),'XX')||'-'
       ||to_number(substr(cs.low_value,7,2),'XX')||' '
       ||(to_number(substr(cs.low_value,9,2),'XX')-1)||':'
       ||(to_number(substr(cs.low_value,11,2),'XX')-1)||':'
       ||(to_number(substr(cs.low_value,13,2),'XX')-1)
,  cs.low_value
       ) low_v
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(cs.high_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(cs.high_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(cs.high_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(cs.high_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(cs.high_value))
  ,'DATE',to_char(1780+to_number(substr(cs.high_value,1,2),'XX')
         +to_number(substr(cs.high_value,3,2),'XX'))||'-'
       ||to_number(substr(cs.high_value,5,2),'XX')||'-'
       ||to_number(substr(cs.high_value,7,2),'XX')||' '
       ||(to_number(substr(cs.high_value,9,2),'XX')-1)||':'
       ||(to_number(substr(cs.high_value,11,2),'XX')-1)||':'
       ||(to_number(substr(cs.high_value,13,2),'XX')-1)
,  cs.high_value
       ) hi_v
from dba_part_col_statistics cs, dba_tab_columns t
where cs.owner      like upper('&tab_own')
and   cs.table_name like upper(nvl('&tab_name','WHOOPS')||'%')
--and cs.partition_name = 'P_LATEST'
and cs.owner = t.owner
and cs.table_name = t.table_name
and cs.column_name = t.column_name
ORDER BY cs.owner,cs.table_name,t.COLUMN_ID;
