with snapshots as ( 
select snap_id, begin_interval_time,
nvl( ( ms1 - lag(ms1) over ( order by snap_id )),0) ms1,
nvl( ( ms2 - lag(ms2) over ( order by snap_id )),0) ms2,
nvl( ( ms4 - lag(ms4) over ( order by snap_id )),0) ms4,
nvl( ( ms8 - lag(ms8) over ( order by snap_id )),0) ms8,
nvl( ( ms16 - lag(ms16) over ( order by snap_id )),0) ms16,
nvl( ( ms32 - lag(ms32) over ( order by snap_id )),0) ms32,
nvl( ( ms64 - lag(ms64) over ( order by snap_id )),0) ms64,
nvl( ( ms128 - lag(ms128) over ( order by snap_id )),0) ms128,
nvl( ( ms256 - lag(ms256) over ( order by snap_id )),0) ms256,
nvl( ( ms512 - lag(ms512) over ( order by snap_id )),0) ms512,
nvl( ( ms1024 - lag(ms1024) over ( order by snap_id )),0) ms1024,
nvl( ( ms2048 - lag(ms2048) over ( order by snap_id )),0) ms2048,
nvl( ( ms4096 - lag(ms4096) over ( order by snap_id )),0) ms4096,
 ( nvl(ms1 - lag(ms1) over ( order by snap_id ),0)) + ( nvl(ms2 - lag(ms2) over ( order by snap_id ),0)) + ( nvl(ms4 - lag(ms4) over ( order by snap_id ),0)) + ( nvl(ms8 - lag(ms8) over ( order by snap_id ),0)) + 
( nvl(ms16 - lag(ms16) over ( order by snap_id ),0)) + ( nvl(ms32 - lag(ms32) over ( order by snap_id ),0)) + ( nvl(ms64 - lag(ms64) over ( order by snap_id ),0)) + ( nvl(ms128 - lag(ms128) over ( order by snap_id ),0)) + 
( nvl(ms256 - lag(ms256) over ( order by snap_id ),0)) + ( nvl(ms512 - lag(ms512) over ( order by snap_id ),0)) + ( nvl(ms1024 - lag(ms1024) over ( order by snap_id ),0)) + ( nvl(ms2048 - lag(ms2048) over ( order by snap_id ),0)) + 
( nvl(ms4096 - lag(ms4096) over ( order by snap_id ),0) )  total
        from ( select min(snap_id) snap_id
              ,wait_time_milli
              ,max(wait_count) wait_count             
              ,min(begin_interval_time) begin_interval_time                            
          from sys.dba_hist_event_histogram p natural join dba_hist_ash_snapshot s natural join v$database db natural join ( select instance_number from v$instance )
         where begin_interval_time between sysdate - 14 and sysdate 
         --and event_name = 'db file scattered read'
         --and event_name = 'db file sequential read'
         and event_name = :wait_name         
         group by round((snap_id+29)/:interval), wait_time_milli
          ) pivot ( 
            sum(wait_count)
            for wait_time_milli in ( 1 ms1,2 ms2,4 ms4, 8 ms8,16 ms16,32 ms32,64 ms64,128 ms128,256 ms256,512 ms512, 1024 ms1024, 2048 ms2048,4096 ms4096 ) ) ), 
 report as ( select snap_id, to_char(begin_interval_time, 'DD-MON-YYYY HH24:MI') snap_time, 
 round( ( ms1 * 1 + ms2 * 2 + ms4 * 4 + ms8 * 8 + ms16 * 16 + ms32 * 32 + ms64 * 64 + ms128 * 128 + ms256 * 256 + ms512 * 512 + ms1024 * 1024 + ms2048 * 2048 + ms4096 *  4096 ) / 2 / greatest(total,1), 2) ms_avg,
 total,
 ( ms1 * 1 + ms2 * 2 + ms4 * 4 + ms8 * 8 + ms16 * 16 + ms32 * 32 + ms64 * 64 + ms128 * 128 + ms256 * 256 + ms512 * 512 + ms1024 * 1024 + ms2048 * 2048 + ms4096 *  4096 ) / 2  total_time,
round( ms1 / greatest(total, 1) * 100, 2) ms1,
round( ms2 / greatest(total, 1) * 100, 2) ms2,
round( ms4 / greatest(total, 1) * 100, 2) ms4,
round( ms8 / greatest(total, 1) * 100, 2) ms8,
round( ms16 / greatest(total, 1) * 100, 2) ms16,
round( ms32 / greatest(total, 1) * 100, 2) ms32,
round( ms64 / greatest(total, 1) * 100, 2) ms64,
round( ms128 / greatest(total, 1) * 100, 2) ms128,
round( ms256 / greatest(total, 1) * 100, 2) ms256,
round( ms512 / greatest(total, 1) * 100, 2) ms512,
round( ms1024 / greatest(total, 1) * 100, 2) ms1024,
round( ms2048 / greatest(total, 1) * 100, 2) ms2048,
round( ms4096 / greatest(total, 1) * 100, 2) ms4096
 from snapshots 
 where total > 0 
 )
 select *
 from report 
 order by snap_id;            