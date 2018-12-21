--- top waits at database for some period
-- lev - it is number of intervals to show 
with t
     as (select snap_id
               ,event_name
               ,time_waited_micro - lag (time_waited_micro) over (partition by event_name order by snap_id) time_waited_micro
               ,begin_interval_time
               ,end_interval_time               
           from sys.dba_hist_system_event p natural join dba_hist_ash_snapshot s natural join v$database db natural join (select instance_number from gv$instance)
          where end_interval_time >= sysdate - 1 and begin_interval_time < sysdate and wait_class != 'Idle')
    ,min_max_times as (select min (begin_interval_time) tmin, max (begin_interval_time) tmax from t)
    ,total_times as ( select sum(time_waited_micro) sum_time,  begin_interval_time from t group by begin_interval_time )
    ,intervals
     as (    select level lev, tmin + (tmax - tmin) / :lev * (level - 1) start_time, tmin + (tmax - tmin) / :lev * (level) end_time
               from min_max_times
         connect by level <= :lev)
    ,total_times_intervals as (
        select intervals.*, sum(tt.sum_time) sum_time from total_times tt , intervals 
        where tt.begin_interval_time >= intervals.start_time and tt.begin_interval_time < intervals.end_time
        group by lev, start_time, end_time
    )         
    ,unsorted_agg
     as (  select event_name, sum (time_waited_micro) sum_time
             from t
         group by event_name
         order by sum_time desc)
    ,sorted_agg
     as (select /*+ MATERIALIZE */
               event_name, sum_time, rownum rn
           from unsorted_agg
          where rownum <= 15)
    ,result
     as (select null start_time
               ,max (case when rn = 1 then event_name else null end) s1
               ,max (case when rn = 2 then event_name else null end) s2
               ,max (case when rn = 3 then event_name else null end) s3             
               ,max (case when rn = 4 then event_name else null end) s4
               ,max (case when rn = 5 then event_name else null end) s5
               ,max (case when rn = 6 then event_name else null end) s6
               ,max (case when rn = 7 then event_name else null end) s7
               ,max (case when rn = 8 then event_name else null end) s8
               ,max (case when rn = 9 then event_name else null end) s9
           from sorted_agg
         union all
           select min (t.begin_interval_time)            
                 ,to_char (round( 100 * sum (case when a.rn = 1 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s1
                 ,to_char (round( 100 * sum (case when a.rn = 2 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s2
                 ,to_char (round( 100 * sum (case when a.rn = 3 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s3
                 ,to_char (round( 100 * sum (case when a.rn = 4 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s4
                 ,to_char (round( 100 * sum (case when a.rn = 5 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s5
                 ,to_char (round( 100 * sum (case when a.rn = 6 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s6
                 ,to_char (round( 100 * sum (case when a.rn = 7 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s7                                                                   
                 ,to_char (round( 100 * sum (case when a.rn = 8 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s8
                 ,to_char (round( 100 * sum (case when a.rn = 9 then time_waited_micro else 0 end) / tt.sum_time, 2) ) s9                                  
             from t,  sorted_agg a, total_times_intervals tt
            where t.begin_interval_time >= tt.start_time and t.end_interval_time <= tt.end_time and t.event_name = a.event_name             
         group by tt.lev, tt.start_time, tt.end_time, tt.sum_time)
  select *
    from result
order by start_time nulls first;



