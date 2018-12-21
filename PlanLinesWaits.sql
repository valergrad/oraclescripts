with ash as (
        select * from ( 
                select -1 SNAP_ID, SAMPLE_ID, SAMPLE_TIME, SESSION_ID, SESSION_SERIAL#, SESSION_TYPE, FLAGS, USER_ID, SQL_ID, IS_SQLID_CURRENT, SQL_CHILD_NUMBER, SQL_OPCODE, SQL_OPNAME, FORCE_MATCHING_SIGNATURE, TOP_LEVEL_SQL_ID, TOP_LEVEL_SQL_OPCODE, SQL_PLAN_HASH_VALUE, SQL_PLAN_LINE_ID, SQL_PLAN_OPERATION, SQL_PLAN_OPTIONS, SQL_EXEC_ID, SQL_EXEC_START, PLSQL_ENTRY_OBJECT_ID, PLSQL_ENTRY_SUBPROGRAM_ID, PLSQL_OBJECT_ID, PLSQL_SUBPROGRAM_ID, QC_INSTANCE_ID, QC_SESSION_ID, QC_SESSION_SERIAL#, PX_FLAGS, EVENT, EVENT_ID, SEQ#, P1TEXT, P1, P2TEXT, P2, P3TEXT, P3, WAIT_CLASS, WAIT_CLASS_ID, WAIT_TIME, SESSION_STATE, TIME_WAITED, BLOCKING_SESSION_STATUS, BLOCKING_SESSION, BLOCKING_SESSION_SERIAL#, BLOCKING_INST_ID, BLOCKING_HANGCHAIN_INFO, CURRENT_OBJ#, CURRENT_FILE#, CURRENT_BLOCK#, CURRENT_ROW#, TOP_LEVEL_CALL#, TOP_LEVEL_CALL_NAME, CONSUMER_GROUP_ID, XID, REMOTE_INSTANCE#, TIME_MODEL, IN_CONNECTION_MGMT, IN_PARSE, IN_HARD_PARSE, IN_SQL_EXECUTION, IN_PLSQL_EXECUTION, IN_PLSQL_RPC, IN_PLSQL_COMPILATION, IN_JAVA_EXECUTION, IN_BIND, IN_CURSOR_CLOSE, IN_SEQUENCE_LOAD, CAPTURE_OVERHEAD, REPLAY_OVERHEAD, IS_CAPTURED, IS_REPLAYED, SERVICE_HASH, PROGRAM, MODULE, ACTION, CLIENT_ID, MACHINE, PORT, ECID, DBREPLAY_FILE_ID, DBREPLAY_CALL_COUNTER, TM_DELTA_TIME, TM_DELTA_CPU_TIME, TM_DELTA_DB_TIME, DELTA_TIME, DELTA_READ_IO_REQUESTS, DELTA_WRITE_IO_REQUESTS, DELTA_READ_IO_BYTES, DELTA_WRITE_IO_BYTES, DELTA_INTERCONNECT_IO_BYTES, PGA_ALLOCATED, TEMP_SPACE_ALLOCATED from v$active_session_history where :source = 'ASH'
                union all
                select    SNAP_ID, SAMPLE_ID, SAMPLE_TIME, SESSION_ID, SESSION_SERIAL#, SESSION_TYPE, FLAGS, USER_ID, SQL_ID, IS_SQLID_CURRENT, SQL_CHILD_NUMBER, SQL_OPCODE, SQL_OPNAME, FORCE_MATCHING_SIGNATURE, TOP_LEVEL_SQL_ID, TOP_LEVEL_SQL_OPCODE, SQL_PLAN_HASH_VALUE, SQL_PLAN_LINE_ID, SQL_PLAN_OPERATION, SQL_PLAN_OPTIONS, SQL_EXEC_ID, SQL_EXEC_START, PLSQL_ENTRY_OBJECT_ID, PLSQL_ENTRY_SUBPROGRAM_ID, PLSQL_OBJECT_ID, PLSQL_SUBPROGRAM_ID, QC_INSTANCE_ID, QC_SESSION_ID, QC_SESSION_SERIAL#, PX_FLAGS, EVENT, EVENT_ID, SEQ#, P1TEXT, P1, P2TEXT, P2, P3TEXT, P3, WAIT_CLASS, WAIT_CLASS_ID, WAIT_TIME, SESSION_STATE, TIME_WAITED, BLOCKING_SESSION_STATUS, BLOCKING_SESSION, BLOCKING_SESSION_SERIAL#, BLOCKING_INST_ID, BLOCKING_HANGCHAIN_INFO, CURRENT_OBJ#, CURRENT_FILE#, CURRENT_BLOCK#, CURRENT_ROW#, TOP_LEVEL_CALL#, TOP_LEVEL_CALL_NAME, CONSUMER_GROUP_ID, XID, REMOTE_INSTANCE#, TIME_MODEL, IN_CONNECTION_MGMT, IN_PARSE, IN_HARD_PARSE, IN_SQL_EXECUTION, IN_PLSQL_EXECUTION, IN_PLSQL_RPC, IN_PLSQL_COMPILATION, IN_JAVA_EXECUTION, IN_BIND, IN_CURSOR_CLOSE, IN_SEQUENCE_LOAD, CAPTURE_OVERHEAD, REPLAY_OVERHEAD, IS_CAPTURED, IS_REPLAYED, SERVICE_HASH, PROGRAM, MODULE, ACTION, CLIENT_ID, MACHINE, PORT, ECID, DBREPLAY_FILE_ID, DBREPLAY_CALL_COUNTER, TM_DELTA_TIME, TM_DELTA_CPU_TIME, TM_DELTA_DB_TIME, DELTA_TIME, DELTA_READ_IO_REQUESTS, DELTA_WRITE_IO_REQUESTS, DELTA_READ_IO_BYTES, DELTA_WRITE_IO_BYTES, DELTA_INTERCONNECT_IO_BYTES, PGA_ALLOCATED, TEMP_SPACE_ALLOCATED from dba_hist_active_sess_history where :source = 'AWR' ) t
        where 1=1 
              and sql_id is not null
              and sql_exec_start is not null
              and sql_id = :sql_id
              and sql_exec_id = 16777215 + :sql_exec_id
              --and sql_plan_hash_value = :sql_plan_hash_value                             
 ),
 plan as (
    select * from ( 
                select SQL_ID, PLAN_HASH_VALUE, timestamp, ID, OPERATION, OPTIONS, OBJECT_NODE, OBJECT#, OBJECT_OWNER, OBJECT_NAME, OBJECT_ALIAS, OBJECT_TYPE, OPTIMIZER, PARENT_ID, DEPTH, POSITION, SEARCH_COLUMNS, COST, CARDINALITY, BYTES, OTHER_TAG, PARTITION_START, PARTITION_STOP, PARTITION_ID, OTHER, DISTRIBUTION, CPU_COST, IO_COST, TEMP_SPACE, ACCESS_PREDICATES, FILTER_PREDICATES, PROJECTION, TIME, QBLOCK_NAME, REMARKS, OTHER_XML, EXECUTIONS, LAST_STARTS, STARTS, LAST_OUTPUT_ROWS, OUTPUT_ROWS, LAST_CR_BUFFER_GETS, CR_BUFFER_GETS, LAST_CU_BUFFER_GETS, CU_BUFFER_GETS, LAST_DISK_READS, DISK_READS, LAST_DISK_WRITES, DISK_WRITES, LAST_ELAPSED_TIME, ELAPSED_TIME, POLICY, ESTIMATED_OPTIMAL_SIZE, ESTIMATED_ONEPASS_SIZE, LAST_MEMORY_USED, LAST_EXECUTION, LAST_DEGREE, TOTAL_EXECUTIONS, OPTIMAL_EXECUTIONS, ONEPASS_EXECUTIONS, MULTIPASSES_EXECUTIONS, ACTIVE_TIME, MAX_TEMPSEG_SIZE, LAST_TEMPSEG_SIZE from V$SQL_PLAN_STATISTICS_ALL where :source = 'ASH' 
                union all
                select SQL_ID, PLAN_HASH_VALUE, timestamp, ID, OPERATION, OPTIONS, OBJECT_NODE, OBJECT#, OBJECT_OWNER, OBJECT_NAME, OBJECT_ALIAS, OBJECT_TYPE, OPTIMIZER, PARENT_ID, DEPTH, POSITION, SEARCH_COLUMNS, COST, CARDINALITY, BYTES, OTHER_TAG, PARTITION_START, PARTITION_STOP, PARTITION_ID, OTHER, DISTRIBUTION, CPU_COST, IO_COST, TEMP_SPACE, ACCESS_PREDICATES, FILTER_PREDICATES, PROJECTION, TIME, QBLOCK_NAME, REMARKS, OTHER_XML, 0 executions,  null LAST_STARTS,  null STARTS,  null LAST_OUTPUT_ROWS,  null  OUTPUT_ROWS,  null LAST_CR_BUFFER_GETS,  null CR_BUFFER_GETS,  null LAST_CU_BUFFER_GETS,  null CU_BUFFER_GETS,  null LAST_DISK_READS,  null DISK_READS,  null LAST_DISK_WRITES,  null DISK_WRITES,  null LAST_ELAPSED_TIME,  null  ELAPSED_TIME,  null POLICY,  null ESTIMATED_OPTIMAL_SIZE,  null ESTIMATED_ONEPASS_SIZE,  null LAST_MEMORY_USED,  null LAST_EXECUTION,  null LAST_DEGREE,  null TOTAL_EXECUTIONS,  null OPTIMAL_EXECUTIONS,  null ONEPASS_EXECUTIONS,  null MULTIPASSES_EXECUTIONS,  null ACTIVE_TIME,  null  MAX_TEMPSEG_SIZE,  null LAST_TEMPSEG_SIZE from dba_hist_sql_plan where :source = 'AWR' ) t
    where 1 = 1
          and t.sql_id = :sql_id
          and t.plan_hash_value = decode(:sql_plan_hash_value,null,t.plan_hash_value,:sql_plan_hash_value)           
 ), 
 events as ( 
   select sql_plan_line_id
        ,nvl (event, 'on CPU') event
        ,round (avg (time_waited) / 1000) avg_wait
        ,round (extract (day from (min (sample_time) - min (sql_exec_start)) * 24 * 60 * 60)) start_time
        ,round (extract (day from (max (sample_time) - min (sql_exec_start)) * 24 * 60 * 60)) finish_time
        ,count (*) cnt
        ,count (distinct session_id) max_slaves
        ,trunc (max (px_flags / 2097152)) dop
    from ash
    group by sql_plan_line_id, event
 ), 
 objects as 
 (
    select sql_plan_line_id
            ,current_obj#  
            ,count(*) cnt            
    from ash
    group by sql_plan_line_id, current_obj#
 ),
 objects_with_names as
 (
    select sql_plan_line_id, do.object_name, sum(cnt) cnt 
    from objects o, dba_objects do 
    where o.current_obj# = do.object_id
    group by sql_plan_line_id, do.object_name 
 ),
 objects_formatted as
 (
    select sql_plan_line_id, listagg (o.object_name || '(' || o.cnt ||  ')', ', ') within group (order by o.cnt desc) objects
    from objects_with_names o    
    group by sql_plan_line_id
 ),
 ash_plan as ( 
   select e.sql_plan_line_id line_id
        ,min (start_time) stime
        ,max (finish_time) ftime
        ,max (dop) dop
        ,max (max_slaves) max_sl
        ,sum (e.cnt) cnt
        ,listagg (event || '(' || e.cnt || ',' || avg_wait || ')', ', ') within group (order by e.cnt desc) event
        ,max(o.objects) objects
    from events e, objects_formatted o
    where e.sql_plan_line_id = o.sql_plan_line_id    
    group by e.sql_plan_line_id 
 ),
 plan_text as ( select rownum rn, plan_table_output from table(dbms_xplan.display_awr(sql_id => :sql_id, plan_hash_value => :sql_plan_hash_value, format => 'ALL +OUTLINE +ALIAS +PEEKED_BINDS' )) ),
 start_plan_line as ( select min(rn) start_line from plan_text where plan_table_output like 'Plan hash value%' ),
 plan_text_formatted as 
 (
    select rn - start_line - 3 id, plan_table_output from plan_text, start_plan_line 
    where rn > start_line + 2 
 )
   select 
         stime
        ,ftime
        ,dop
        ,max_sl
        ,cnt
        ,event
        ,p.plan_table_output
        ,objects      
    from plan_text_formatted p, ash_plan
   where line_id(+) = p.id - 2
order by p.id;   