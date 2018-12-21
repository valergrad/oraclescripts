 with ash as (
        select * from ( 
                select -1 snap_id, sample_id, sample_time, session_id, session_serial#, session_type, flags, user_id, sql_id, is_sqlid_current, sql_child_number, sql_opcode, sql_opname, force_matching_signature, top_level_sql_id, top_level_sql_opcode, sql_plan_hash_value, sql_plan_line_id, sql_plan_operation, sql_plan_options, sql_exec_id, sql_exec_start, plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id, qc_instance_id, qc_session_id, qc_session_serial#, px_flags, event, event_id, seq#, p1text, p1, p2text, p2, p3text, p3, wait_class, wait_class_id, wait_time, session_state, time_waited, blocking_session_status, blocking_session, blocking_session_serial#, blocking_inst_id, blocking_hangchain_info, current_obj#, current_file#, current_block#, current_row#, top_level_call#, top_level_call_name, consumer_group_id, xid, remote_instance#, time_model, in_connection_mgmt, in_parse, in_hard_parse, in_sql_execution, in_plsql_execution, in_plsql_rpc, in_plsql_compilation, in_java_execution, in_bind, in_cursor_close, in_sequence_load, capture_overhead, replay_overhead, is_captured, is_replayed, service_hash, program, module, action, client_id, machine, port, ecid, dbreplay_file_id, dbreplay_call_counter, tm_delta_time, tm_delta_cpu_time, tm_delta_db_time, delta_time, delta_read_io_requests, delta_write_io_requests, delta_read_io_bytes, delta_write_io_bytes, delta_interconnect_io_bytes, pga_allocated, temp_space_allocated from gv$active_session_history where :source = 'ASH'
                union all
                select  /*+ leading(s) use_nl(h) */  snap_id, sample_id, sample_time, session_id, session_serial#, session_type, flags, user_id, sql_id, is_sqlid_current, sql_child_number, sql_opcode, sql_opname, force_matching_signature, top_level_sql_id, top_level_sql_opcode, sql_plan_hash_value, sql_plan_line_id, sql_plan_operation, sql_plan_options, sql_exec_id, sql_exec_start, plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id, qc_instance_id, qc_session_id, qc_session_serial#, px_flags, event, event_id, seq#, p1text, p1, p2text, p2, p3text, p3, wait_class, wait_class_id, wait_time, session_state, time_waited, blocking_session_status, blocking_session, blocking_session_serial#, blocking_inst_id, blocking_hangchain_info, current_obj#, current_file#, current_block#, current_row#, top_level_call#, top_level_call_name, consumer_group_id, xid, remote_instance#, time_model, in_connection_mgmt, in_parse, in_hard_parse, in_sql_execution, in_plsql_execution, in_plsql_rpc, in_plsql_compilation, in_java_execution, in_bind, in_cursor_close, in_sequence_load, capture_overhead, replay_overhead, is_captured, is_replayed, service_hash, program, module, action, client_id, machine, port, ecid, dbreplay_file_id, dbreplay_call_counter, tm_delta_time, tm_delta_cpu_time, tm_delta_db_time, delta_time, delta_read_io_requests, delta_write_io_requests, delta_read_io_bytes, delta_write_io_bytes, delta_interconnect_io_bytes, pga_allocated, temp_space_allocated from dba_hist_active_sess_history h 
                natural join dba_hist_snapshot s                
                where :source = 'AWR'
                and dbid in ( select v.dbid from v$database v )
                and s.begin_interval_time between sysdate - 1 and sysdate                                                
                )
        where 1=1 
              and sql_id is not null
              and sql_exec_start is not null
              and sample_time between  sysdate - 1/24 and sysdate
              --and nvl(qc_session_id,-1) = nvl(nvl(729, qc_session_id), -1)               
              --and sql_id = '2x4651qtk9pjb'              
              --and top_level_sql_id = 'crpdrp564mcxj'
              --and sql_plan_hash_value = 1392571480                                                     
             -- and ( program = 'RA.InputStore.PortfolioLoader.exe' or module = 'RA.InputStore.PortfolioLoader.exe' )
              --and ( module = 'CVA.Trade.Reconciliation.Reporting.exe'  )                                                                        
 ),
  obj
     as (  select sql_id, sql_exec_start, listagg (case when rn <= 5 then object_name || '(' || cnt || ')' else '' end, ',') within group (order by cnt desc) obj_list
             from (select sql_id
                         ,sql_exec_start
                         ,owner
                         ,object_name
                         ,cnt
                         ,row_number () over (partition by sql_id, sql_exec_start order by cnt desc) rn
                     from (  select sql_id
                                   ,sql_exec_start
                                   ,o.owner
                                   ,o.object_name
                                   ,count (*) cnt
                               from ash, dba_objects o
                              where ash.current_obj# = o.object_id
                           group by sql_id
                                   ,sql_exec_start
                                   ,owner
                                   ,object_name))
         group by sql_id, sql_exec_start) 
    ,spaces
     as (  select sql_id, sql_exec_start, listagg (case when rn <= 5 then tablespace_name || '(' || cnt || ')' else '' end, ',') within group (order by cnt desc) spaces_list
             from (select sql_id
                         ,sql_exec_start
                         ,tablespace_name
                         ,cnt
                         ,row_number () over (partition by sql_id, sql_exec_start order by cnt desc) rn
                     from (  select sql_id
                                   ,sql_exec_start
                                   ,tablespace_name
                                   ,count (*) cnt
                               from ash, dba_data_files o
                              where ash.current_file# = o.file_id
                           group by sql_id
                                   ,sql_exec_start
                                   ,tablespace_name))
         group by sql_id, sql_exec_start) 
 select qc_session_id sess
       ,t.sql_id
       ,t.sql_exec_id - 16777216 + 1 exec_id
       ,sql_plan_hash_value plan_hash
       ,dop       
       ,round(avg_sl,2) avg_sl  
   --    ,round( 1 - avg_sl / decode(dop,null,1,0,1,dop),2) skew        
       ,to_char(t.sql_exec_start, 'YY-MM-DD HH24:MI:SS') sql_exec_start
       ,durab         
       ,to_char (substr (trim(replace(s.sql_text, chr(10), ' ') ), 1, 100)) short_text
       ,sql_text
       /*,( select replace(replace(replace(replace( rtrim(xmlagg(xmlelement(e,plan_table_output,'\n').extract('//text()') ).getclobval(),','), q'[\n]', chr(13)), chr(38) || 'gt;', '>'), chr(38) || 'quot;'), chr(38) || 'apos;', '''') as list
           from table(dbms_xplan.display_awr(sql_id => t.sql_id, plan_hash_value => case when :all_plans = 'Y' then null else sql_plan_hash_value end, format => 'ALL +OUTLINE +ALIAS +PEEKED_BINDS' )) 
          --from table(dbms_xplan.display_cursor(t.sql_id, 0, 'ALL ALLSTATS LAST -PROJECTION'))
       ) awr_plan           
       */,t.module
       ,t.action       
       ,u.username
       ,machine        
       ,cnt
       ,pga
       ,temp
       ,sql_child_number chld 
       ,force_matching_signature signature
       ,top_level_sql_id
     --  ,obj.obj_list obj_list
      --,spaces.spaces_list spaces_list                                       
 from (  select qc_session_id,                 
                 sql_exec_id,
                 sql_plan_hash_value,
                 trunc(max(px_flags)/2097152) dop,                 
                 sql_exec_start,                                                                                    
                 sql_id,     
                 top_level_sql_id,    
                 user_id,        
                 sql_child_number, 
                 force_matching_signature,                 
                 round( max (pga)  / 1024 / 1024 / 1024, 2) pga,
                 round( max( temp) / 1024 / 1024 / 1024, 2) temp,
                 max(sample_time) - min(sql_exec_start) durab,                 
                 count(*) cnt, 
                 avg(slaves) avg_sl,               
                 max(module) module,
                 max(action) action,
                 max(machine) machine                                                  
            from (  select sample_time,
                           sql_id,
                           top_level_sql_id,
                           sql_plan_hash_value,
                           sql_exec_id,
                           sql_exec_start,
                           user_id,
                           sql_child_number, 
                           force_matching_signature,
                           nvl(qc_session_id,session_id) qc_session_id,                                                      
                           sum (pga_allocated) pga,      
                           sum(temp_space_allocated) temp,                 
                           max(module) module,
                           max(px_flags) px_flags,
                           max(action) action,
                           max(machine) machine,
                           count(*) slaves                                                                                 
                      from ash                                                                                                                                          
                  group by sql_id, sql_plan_hash_value, sql_exec_id, sample_time, sql_exec_start, nvl(qc_session_id,session_id), top_level_sql_id, user_id, sql_child_number, force_matching_signature, machine
                  )
        group by sql_id, sql_plan_hash_value, sql_exec_id, sql_exec_start, qc_session_id, top_level_sql_id, user_id, sql_child_number, force_matching_signature, machine
        -- having  max(sample_time) - min(sample_time) > interval '10' second 
      ) t
       left join dba_hist_sqltext s on t.sql_id = s.sql_id and s.dbid in ( select v.dbid from v$database v )
       left join dba_users u on t.user_id = u.user_id
      -- left join obj on (t.sql_id = obj.sql_id and t.sql_exec_start = obj.sql_exec_start)
       --left join spaces on (t.sql_id = spaces.sql_id and t.sql_exec_start = spaces.sql_exec_start)
 where 1=1      
 --and lower(s.sql_text) like '%%'  
 --and u.username = 'DSO_INVENTORY_USER'
 order by sql_exec_start, sess, durab desc, qc_session_id, pga desc;
 
 select * from v$database;
 select * from dba_hist_sqltext