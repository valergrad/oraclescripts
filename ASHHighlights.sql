with ash as (
        select * from ( 
                select -1 snap_id, host_name, sample_id, sample_time, session_id, session_serial#, session_type, flags, user_id, sql_id top_level_sql_id, is_sqlid_current, sql_child_number, sql_opcode, sql_opname, force_matching_signature, top_level_sql_id sql_id, top_level_sql_opcode, sql_plan_hash_value, sql_plan_line_id, sql_plan_operation, sql_plan_options, sql_exec_id, sql_exec_start, plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id, qc_instance_id, qc_session_id, qc_session_serial#, px_flags, event, event_id, seq#, p1text, p1, p2text, p2, p3text, p3, wait_class, wait_class_id, wait_time, session_state, time_waited, blocking_session_status, blocking_session, blocking_session_serial#, blocking_inst_id, blocking_hangchain_info, current_obj#, current_file#, current_block#, current_row#, top_level_call#, top_level_call_name, consumer_group_id, xid, remote_instance#, time_model, in_connection_mgmt, in_parse, in_hard_parse, in_sql_execution, in_plsql_execution, in_plsql_rpc, in_plsql_compilation, in_java_execution, in_bind, in_cursor_close, in_sequence_load, capture_overhead, replay_overhead, is_captured, is_replayed, service_hash, program, module, action, client_id, machine, port, ecid, dbreplay_file_id, dbreplay_call_counter, tm_delta_time, tm_delta_cpu_time, tm_delta_db_time, delta_time, delta_read_io_requests, delta_write_io_requests, delta_read_io_bytes, delta_write_io_bytes, delta_interconnect_io_bytes, pga_allocated, temp_space_allocated from gv$active_session_history ash, gv$instance inst where ash.inst_id = inst.inst_id and :source = 'ASH'
                union all
                select    snap_id, host_name, sample_id, sample_time, session_id, session_serial#, session_type, flags, user_id, sql_id top_level_sql_id, is_sqlid_current, sql_child_number, sql_opcode, sql_opname, force_matching_signature, top_level_sql_id sql_id, top_level_sql_opcode, sql_plan_hash_value, sql_plan_line_id, sql_plan_operation, sql_plan_options, sql_exec_id, sql_exec_start, plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id, qc_instance_id, qc_session_id, qc_session_serial#, px_flags, event, event_id, seq#, p1text, p1, p2text, p2, p3text, p3, wait_class, wait_class_id, wait_time, session_state, time_waited, blocking_session_status, blocking_session, blocking_session_serial#, blocking_inst_id, blocking_hangchain_info, current_obj#, current_file#, current_block#, current_row#, top_level_call#, top_level_call_name, consumer_group_id, xid, remote_instance#, time_model, in_connection_mgmt, in_parse, in_hard_parse, in_sql_execution, in_plsql_execution, in_plsql_rpc, in_plsql_compilation, in_java_execution, in_bind, in_cursor_close, in_sequence_load, capture_overhead, replay_overhead, is_captured, is_replayed, service_hash, program, module, action, client_id, machine, port, ecid, dbreplay_file_id, dbreplay_call_counter, tm_delta_time, tm_delta_cpu_time, tm_delta_db_time, delta_time, delta_read_io_requests, delta_write_io_requests, delta_read_io_bytes, delta_write_io_bytes, delta_interconnect_io_bytes, pga_allocated, temp_space_allocated from 
                    ( select ash.*, db.inst_id, inst.instance_number, instance_name, host_name from dba_hist_active_sess_history ash, gv$database db, gv$instance inst where db.inst_id = inst.inst_id and ash.instance_number = inst.instance_number and ash.dbid = db.dbid ) hist where :source = 'AWR' )
        where 1=1 
              --and sql_id is not null              
              --and sql_exec_start is not null              
              and sample_time between  sysdate - 1 and sysdate                                                                                  
 ),
ash_sqls as (
    select sql_id top_level_sql_id, count(*) cnt from ash
    group by sql_id
    having count(*) > ( select count(*) from ash ) / 1000 
    order by cnt
),  
ash_sql_texts as 
(
   select t.*, to_char (substr (trim(replace(s.sql_text, chr(10), ' ') ), 1, 100)) short_text from ash_sqls t, dba_hist_sqltext s
    where t.top_level_sql_id = s.sql_id    
),
 res as (  
 select 'username' type, ( select t.username from dba_users t where t.user_id = ash.user_id) entity, 
        collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct 
        from ash, ash_sql_texts s where ash.top_level_sql_id = s.top_level_sql_id(+)  group by user_id  
 union all 
 select 'program' type, regexp_replace( program, '(\(P[[:digit:]]{3}\))', '') entity, 
        collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct from ash, ash_sql_texts s 
        where ash.top_level_sql_id = s.top_level_sql_id(+)  group by regexp_replace( program, '(\(P[[:digit:]]{3}\))', '')
 union all
 select 'module' type,  module entity, collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct from ash, ash_sql_texts s 
        where ash.top_level_sql_id = s.top_level_sql_id(+)  group by module
 union all
 select 'action' type, regexp_replace(action, 'query=adhoc(.)+', 'query=adhoc') entity, 
     collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
     round( 100 * count(*)/ ( select count(*) from ash), 2) pct from ash, ash_sql_texts s 
     where ash.top_level_sql_id = s.top_level_sql_id(+)  group by regexp_replace(action, 'query=adhoc(.)+', 'query=adhoc') 
 union all
 select 'top_sql' type, ash.top_level_sql_id entity, 
       collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
       round( 100 * count(*)/ ( select count(*) from ash), 2) pct
       from ash, ash_sql_texts s where ash.sql_id = s.top_level_sql_id(+)
 group by ash.top_level_sql_id
 union all
 select 'machine' type, machine, collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct 
        from ash, ash_sql_texts s 
        where ash.top_level_sql_id = s.top_level_sql_id(+) group by machine
 union all
 select 'object' type, o.owner || '.' || o.object_name entity, 
        collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct 
        from ash t, dba_objects o, ash_sql_texts s 
        where t.top_level_sql_id = s.top_level_sql_id(+)  and t.current_obj# = o.data_object_id group by o.owner, o.object_name
 union all
 select 'top_text' type, translate(substr(s.short_text,1,100), '0123456789', 'XXXXXXXXXX')  entity, 
        collect(unique (lpad(to_char(s.cnt), 7, ' ') || ' '|| rpad(s.top_level_sql_id, 20, ' ') || ' ' || s.short_text )  ) sqls, 
        round( 100 * count(*)/ ( select count(*) from ash), 2) pct 
        from ash, ash_sql_texts s where ash.top_level_sql_id = s.top_level_sql_id(+)  
        group by translate(substr(s.short_text,1,100), '0123456789', 'XXXXXXXXXX')          
 )
 select * from res order by pct desc;    