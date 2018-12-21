 -- parallellism & plan
 select session_id, 
    px,  
   listagg( case when sql_plan_line_id is null then 'null' else to_char(sql_plan_line_id) end || '(' || cnt || ')' || ' ') within group ( order by cnt desc) plan_lines,
   sum(cnt) cnt    
   from ( select session_id,
         sql_plan_line_id,
         sql_plan_operation, 
         program,
         case when program like 'oracle@' || host_name || '%' then '~' || substr( program, 10 + length(host_name), 4) else program end px,   
         count (*) cnt
    from dba_hist_active_sess_history ash, v$instance inst
   where ash.sql_id = :sql_id and sql_exec_id = (16777215 + :exec_id)
group by session_id,
         sql_plan_line_id,
         sql_plan_operation,     
         program, 
         inst.host_name 
)
group by session_id, px
order by px;