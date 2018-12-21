WITH sga
     AS (  SELECT sga.*,
                    NVL ("'KGLH0 shared pool'", 0)
                  + NVL ("'fixed_sga '", 0)
                  + NVL ("'krcc extent chunk    large po", 0)
                  + NVL ("'PRTDS shared pool'", 0)
                  + NVL ("'db_block_hash_buckets shared ", 0)
                  + NVL ("'buffer_cache '", 0)
                  + NVL ("'free memory    large pool'", 0)
                  + NVL ("'free memory    streams pool'", 0)
                  + NVL ("'PX msg pool    large pool'", 0)
                  + NVL ("'KGLHD shared pool'", 0)
                  + NVL ("'qesblFilter_seg large pool'", 0)
                  + NVL ("'PRTMV shared pool'", 0)
                  + NVL ("'free memory    java pool'", 0)
                  + NVL ("'log_buffer '", 0)
                  + NVL ("'free memory    shared pool'", 0)
                  + NVL ("'SQLA shared pool'", 0)
                     total_sga
             FROM (  SELECT p.snap_id,
                            p.dbid,
                            p.name || ' ' || p.pool name,
                            bytes,
                            begin_interval_time
                       FROM SYS.DBA_HIST_SGASTAT p, sys.dba_hist_ash_snapshot s
                      WHERE     p.snap_id = s.snap_id
                            AND s.begin_interval_time between sysdate - 1 and sysdate
                   ORDER BY name) PIVOT (SUM (bytes)
                                     FOR name
                                     IN ('KGLH0 shared pool',
                                        'fixed_sga ',
                                        'krcc extent chunk    large pool',
                                        'PRTDS shared pool',
                                        'db_block_hash_buckets shared pool',
                                        'buffer_cache ',
                                        'free memory    large pool',
                                        'free memory    streams pool',
                                        'PX msg pool    large pool',
                                        'KGLHD shared pool',
                                        'qesblFilter_seg large pool',
                                        'PRTMV shared pool',
                                        'free memory    java pool',
                                        'log_buffer ',
                                        'free memory    shared pool',
                                        'SQLA shared pool')) sga
         ORDER BY begin_interval_time),
     pga
     AS (  SELECT pga.*
             FROM (  SELECT p.*, begin_interval_time
                       FROM SYS.DBA_HIST_PGASTAT p, sys.dba_hist_ash_snapshot s
                      WHERE     p.snap_id = s.snap_id
                            AND s.begin_interval_time between sysdate - 1 and sysdate
                   ORDER BY name) PIVOT (SUM (VALUE)
                                     FOR name
                                     IN ('aggregate PGA auto target',
                                        'aggregate PGA target parameter',
                                        'bytes processed',
                                        'cache hit percentage',
                                        'extra bytes read/written',
                                        'global memory bound',
                                        'max processes count',
                                        'maximum PGA allocated',
                                        'maximum PGA used for auto workareas',
                                        'maximum PGA used for manual workareas',
                                        'PGA memory freed back to OS',
                                        'process count',
                                        'recompute count (total)',
                                        'total freeable PGA memory',
                                        'total PGA allocated',
                                        'total PGA inuse',
                                        'total PGA used for auto workareas',
                                        'total PGA used for manual workareas')) pga
         ORDER BY begin_interval_time),
     os
     AS (  SELECT os.*
             FROM (  SELECT p.snap_id,
                            p.dbid,
                            stat_name,
                            VALUE,
                            begin_interval_time
                       FROM SYS.DBA_HIST_OSSTAT p, sys.dba_hist_ash_snapshot s
                      WHERE     p.snap_id = s.snap_id
                            AND s.begin_interval_time between sysdate - 1 and sysdate
                   ORDER BY stat_name) PIVOT (SUM (VALUE)
                                          FOR stat_name
                                          IN ('NUM_CPUS',
                                             'IDLE_TIME',
                                             'BUSY_TIME',
                                             'USER_TIME',
                                             'SYS_TIME',
                                             'IOWAIT_TIME',
                                             'NICE_TIME',
                                             'RSRC_MGR_CPU_WAIT_TIME',
                                             'LOAD',
                                             'NUM_CPU_CORES',
                                             'NUM_CPU_SOCKETS',
                                             'PHYSICAL_MEMORY_BYTES',
                                             'VM_IN_BYTES',
                                             'VM_OUT_BYTES',
                                             'TCP_SEND_SIZE_MIN',
                                             'TCP_SEND_SIZE_DEFAULT',
                                             'TCP_SEND_SIZE_MAX',
                                             'TCP_RECEIVE_SIZE_MIN',
                                             'TCP_RECEIVE_SIZE_DEFAULT',
                                             'TCP_RECEIVE_SIZE_MAX',
                                             'GLOBAL_SEND_SIZE_MAX',
                                             'GLOBAL_RECEIVE_SIZE_MAX')) os
         ORDER BY begin_interval_time)
  SELECT sga.snap_id,
         sga.begin_interval_time,
         ROUND (sga.total_sga / 1024 / 1024 / 1024, 1) total_sga,
         "'SQLA shared pool'" / 1024/ 1024/1024 shared_pool,
         ROUND (pga."'total PGA allocated'" / 1024 / 1024 / 1024, 1) + ROUND (pga."'total PGA inuse'" / 1024 / 1024 / 1024, 1) total_pga,
         "'buffer_cache '" cache,         
         ROUND (
              (  os."'VM_IN_BYTES'"
               - LAG (os."'VM_IN_BYTES'") OVER (ORDER BY sga.snap_id))
            / 1024
            / 1024
            / 1024,
            1)
            swap,
         ROUND (os."'PHYSICAL_MEMORY_BYTES'" / 1024 / 1024 / 1024, 1) os_memory
    FROM sga, pga, os
   WHERE sga.snap_id = pga.snap_id AND sga.snap_id = os.snap_id
ORDER BY sga.snap_id;

