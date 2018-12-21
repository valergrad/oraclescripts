/*+ pl_sql */
with ash
     as (  select plsql_entry_object_id
                 ,plsql_entry_subprogram_id
                 ,plsql_object_id
                 ,plsql_subprogram_id
                 ,count (*) cnt                 
             from dba_hist_active_sess_history
            where sample_time > sysdate - 1 and sample_time < sysdate            
         group by plsql_entry_object_id
                 ,plsql_entry_subprogram_id
                 ,plsql_object_id
                 ,plsql_subprogram_id
         )
  select ash.cnt, p2.owner || '.' || p2.object_name || '.' || p2.procedure_name entry_proc, p4.owner || '.' || p4.object_name || '.' || p4.procedure_name called_proc,
    plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id
    from ash, dba_procedures p2, dba_procedures p4
   where ash.plsql_entry_object_id = p2.object_id(+) and ash.plsql_entry_subprogram_id = p2.subprogram_id(+) and ash.plsql_object_id = p4.object_id(+) and ash.plsql_subprogram_id = p4.subprogram_id(+)
order by cnt desc;
