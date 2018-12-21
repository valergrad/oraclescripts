  SELECT to_char(substr(sql_text,1,100)) short_text, 
         p.sql_id,
         trunc(begin_interval_time) start_date,
         count(distinct snap_id) snaps,
         plan_hash_value plan_hash,                               
         sum(executions_delta) execs,
         round(sum(buffer_gets_delta) / sum(executions_delta)) buffer_gets_pq,
         round(sum(disk_reads_delta) / sum(executions_delta)) disk_reads_pq,
         round(sum(rows_processed_delta) / sum(executions_delta)) rows_processed_pq,                                              
         round(sum(elapsed_time_delta) / sum(executions_delta) / 1000000, 3) elapsed_time_pq,
         round(sum(cpu_time_delta) / sum(executions_delta)     / 1000000, 3) cpu_time_pq,
         round(sum(iowait_delta)/ sum(executions_delta)        / 1000000, 3) iowait_delta_pq,
         round( sum(physical_read_bytes_delta) / sum(buffer_gets_delta) * 100, 2 ) iowait_prc, 
         round(sum(plsexec_time_delta)/ sum(executions_delta)  / 1000000, 3) plsq_time_pq,         
         round(sum(clwait_delta)/ sum(executions_delta)        / 1000000, 3) clwait_delta_pq,
         round(sum(apwait_delta)/ sum(executions_delta)        / 1000000, 3) apwait_delta_pq,
         round(sum(ccwait_delta)/ sum(executions_delta)        / 1000000, 3) ccwait_delta_pq,
         round(sum(direct_writes_delta)/ sum(executions_delta) / 1000000, 3) direct_writes_delta_pq,                  
         sum(invalidations_delta) invalids,
         sum(parse_calls_delta) parses,         
         round(sum(sorts_delta) / sum(executions_delta)) sorts_pq,
         round(sum(fetches_delta) / sum(executions_delta)) fetches_pq,
         round(sum(px_servers_execs_delta) / sum(executions_delta)) px_servers_exec_pq,
         round(sum(io_interconnect_bytes_delta)/ sum(executions_delta)) io_interconnect_pq,
         round(sum(physical_read_bytes_delta)/ sum(executions_delta)) physical_read_bytes_pq,
         round(sum(physical_write_bytes_delta)/ sum(executions_delta)) physical_write_bytes_pq
    FROM dba_hist_sqlstat p natural join dba_hist_ash_snapshot s natural join v$database db natural join ( select instance_number from v$instance ) i, dba_hist_sqltext s  
    where 1=1 
      and begin_interval_time between sysdate - 1 and sysdate      
      and p.sql_id in ( 'dds9n4p0j0cpv' )                                             
      and p.sql_id = s.sql_id
   group by p.sql_id, plan_hash_value, trunc(begin_interval_time), to_char(substr(sql_text,1,100))
   having sum(executions_delta) > 0
   order by 2,3;  