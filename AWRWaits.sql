

with snapshots as ( select                     
                    wait_class,
                    event_name,
                    max(total_waits) - min(total_waits) waits,
                    max(total_timeouts)  - min(total_timeouts) timeouts,
                    round( (max(time_waited_micro) - min(time_waited_micro)) ) time_waited                                       
 From ( select snap_id, dbid, instance_number, wait_class, event_name, total_waits_fg total_waits, total_timeouts_fg total_timeouts, time_waited_micro_fg time_waited_micro from dba_hist_system_event  
        union all
        select snap_id, dbid, instance_number, 'NOT IN WAIT' wait_class, stat_name as event_name, 0 as total_waits, 0 as total_timeouts, value as time_waited_micro from dba_hist_sys_time_model
        where stat_name in ( 'DB time', 'DB CPU' ) 
 ) p
 natural join dba_hist_ash_snapshot s natural join v$database db natural join ( select instance_number from v$instance )  
         where begin_interval_time between sysdate - 7 and sysdate
         --and snap_id >= 11713 and snap_id <= 11714
         group by wait_class, event_name
          )
         select s.wait_class, s.event_name, s.time_waited / 1000/1000 time_waited , waits, timeouts, round( decode(waits, 0, 0, time_waited) / decode(waits,0,1, waits) / 1000, 2) average_wait, round( 100 * time_waited / max(time_waited) over () , 2 ) pct from snapshots s
         where wait_class not in ( 'Idle' )
         order by time_waited desc; 
