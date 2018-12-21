select tablespace_name, begin_interval_time
        ,round (tablespace_maxsize * block_size / 1024 / 1024 / 1024) total
        ,round (tablespace_usedsize * block_size / 1024 / 1024 / 1024) used
        ,round ( (tablespace_maxsize - tablespace_usedsize) * block_size / 1024 / 1024 / 1024) left                
    from ( sys.dba_hist_tbspc_space_usage t natural join dba_hist_snapshot s ) 
    join dba_hist_tablespace ss on tablespace_id = ts# 
    join dba_tablespaces on tablespace_name = tsname
--   where tsname = 'RRS_DATA'
order by begin_interval_time, tablespace_name;

select * from v$asm_diskgroup;

