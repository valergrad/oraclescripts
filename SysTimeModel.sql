with report as ( select tm.snap_id, to_char(tm.begin_interval_time, 'DD-MON-YYYY HH24:MI') stime,
round( 100 * ( db_time - lag(db_time) over ( order by snap_id ))/param1.value / param2.value / extract( day from ( end_interval_time - begin_interval_time ) * 24 * 60 * 60 ), 2)  db_time,
round( ( sql_execution - lag(sql_execution) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) sql_exec,
round( ( db_cpu - lag(db_cpu) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) db_cpu,
round( ( conn_mgmt - lag(conn_mgmt) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) conn,
round( ( parse - lag(parse) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) parse,
round( ( hard_parse - lag(hard_parse) over ( order by snap_id ) ) /  case when :pct = 'Y' then ( parse - lag(parse) over ( order by snap_id ) ) / 100  else 1 end , 2) hard_parse,
round( ( hp_sharing - lag(hp_sharing) over ( order by snap_id )) / ( case when :pct = 'Y' then ( parse - lag(parse) over ( order by snap_id )) / 100  else 1 end  ), 2) hp_sharing,
round( ( hp_binds - lag(hp_binds) over ( order by snap_id ) ) / ( case when :pct = 'Y' then ( parse - lag(parse) over ( order by snap_id ) / 100 ) else 1 end ) ,2) hp_binds,
round( ( failed_parse - lag(failed_parse) over ( order by snap_id )) / ( case when :pct = 'Y' then ( parse - lag(parse) over ( order by snap_id )) / 100  else 1 end  ), 2) failed_parse,
round( ( out_of_mem - lag(out_of_mem) over ( order by snap_id )) / ( case when :pct = 'Y' then ( nvl(parse - lag(parse) over ( order by snap_id ),0)) / 100  else 1 end  ), 2) out_of_mem,
round( ( plsql_compile - lag(plsql_compile) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100 else 1 end  ), 2) plsql_compile,
round( ( plsql_exec - lag(plsql_exec) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) plsql_exec,
round( ( plsql_rpc - lag(plsql_rpc) over ( order by snap_id ) ) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )  ) / 100 else 1 end ) , 2) plsql_rpc,
round( ( java_exec - lag(java_exec) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id ) ) / 100  else 1 end  ), 2) java_exec,
round( ( rebinding - lag(rebinding) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id ))  / 100  else 1 end  ), 2) rebinding,
round( ( sequences - lag(sequences) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end  ), 2) sequences,
round( ( bckgrnd_all -lag(bckgrnd_all) over ( order by snap_id )) / ( case when :pct = 'Y' then ( db_time - lag(db_time) over ( order by snap_id )) / 100  else 1 end), 2) bckgrnd_all,
round( ( bckgrnd_cpu - lag(bckgrnd_cpu) over ( order by snap_id )) / ( case when :pct = 'Y' then ( bckgrnd_all - lag(bckgrnd_all) over ( order by snap_id )) / 100  else 1 end  ), 2) bckgrnd_cpu,
round( ( rman - lag(rman) over ( order by snap_id )) / ( case when :pct = 'Y' then ( bckgrnd_cpu - lag(bckgrnd_cpu) over ( order by snap_id )) / 100  else 1 end  ), 2) rman
  from (select snap_id
              ,stat_name
              ,value
              ,begin_interval_time 
              ,end_interval_time             
          from sys.dba_hist_sys_time_model p natural join dba_hist_ash_snapshot s natural join v$database db natural join ( select instance_number from v$instance )
         where begin_interval_time between sysdate - 2 and sysdate and snap_id = snap_id                             
         )                      
         PIVOT (SUM (value/1000/1000)
                                     FOR stat_name
                                     IN ('hard parse (bind mismatch) elapsed time' hp_binds,
'inbound PL/SQL plsql_rpc elapsed time' plsql_rpc,
'hard parse elapsed time' hard_parse,
'Java execution elapsed time' java_exec,
'repeated bind elapsed time' rebinding,
'PL/SQL compilation elapsed time' plsql_compile,
'parse time elapsed' parse,
'failed parse elapsed time' failed_parse,
'connection management call elapsed time' conn_mgmt,
'RMAN cpu time (backup/restore)' rman,
'background cpu time' bckgrnd_cpu,
'PL/SQL execution elapsed time' plsql_exec,
'DB CPU' db_cpu,
'sql execute elapsed time' sql_execution,
'hard parse (sharing criteria) elapsed time' hp_sharing,
'DB time' db_time,
'failed parse (out of shared memory) elapsed time' out_of_mem,
'sequence load elapsed time' sequences,
'background elapsed time' bckgrnd_all
) ) tm,  v$parameter param1, v$parameter param2 
where param1.name = 'cpu_count'
and param2.name = 'parallel_threads_per_cpu' )
select * from report
order by snap_id;


/*
1) background elapsed time
    2) background cpu time
          3) RMAN cpu time (backup/restore)
1) DB time
    2) DB CPU
    2) connection management call elapsed time
    2) sequence load elapsed time
    2) sql execute elapsed time
    2) parse time elapsed
          3) hard parse elapsed time
                4) hard parse (sharing criteria) elapsed time
                    5) hard parse (bind mismatch) elapsed time
          3) failed parse elapsed time
                4) failed parse (out of shared memory) elapsed time
    2) PL/SQL execution elapsed time
    2) inbound PL/SQL rpc elapsed time
    2) PL/SQL compilation elapsed time
    2) Java execution elapsed time
    2) repeated bind elapsed time
    https://docs.oracle.com/cd/E18283_01/server.112/e17110/dynviews_3015.htm#sthref3486
*/    