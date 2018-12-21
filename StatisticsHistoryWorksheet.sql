-- get retention interval
select dbms_stats.get_stats_history_availability, dbms_stats.get_stats_history_retention from dual;

-- get update time for stats
select owner
      ,table_name
      ,partition_name
      ,stats_update_time
  from dba_tab_stats_history
 where owner = :cur_user
       and table_name = :cur_table;
       and partition_name = :cur_partition;
              
-- get difference in statistics between two intervals
select *
  from table (dbms_stats.diff_table_stats_in_history (ownname        => :cur_user
                                                     ,tabname        => :cur_table
                                                     ,time1          => sysdate - 3
                                                     ,time2          => sysdate - 2
                                                     ,pctthreshold   => 1));                                                     
