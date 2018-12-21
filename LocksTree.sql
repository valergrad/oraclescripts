select
   sid, 
   event, 
   p1raw, 
   seconds_in_wait, 
   wait_time
from
   v$session_wait
where
   event = 'library cache pin'
and
   state = 'WAITING';

select * From dba_objects where edition_name is not null;
select * from gv$lock;

with
 locks as (select /*+ MATERIALIZE*/   * from gv$lock)
,s     as (select /*+ MATERIALIZE*/ s.* from gv$session s)
,blockers as
 (select distinct l1.inst_id, l1.sid
    from locks l1, locks l2
   where l1.block > 0
     and l1.id1 = l2.id1
     and l1.id2 = l2.id2
     and l2.request > 0)
,waiters as (select inst_id, sid from s where blocking_session is not null or blocking_instance is not null)
select--+ opt_param('_connect_by_use_union_all' 'false')
 lpad(' ', (level - 1) * 2) || 'INST#' || s.inst_id || ' SID#' || sid as blocking_tree,
 s.program,
 substr(s.username || ' ' || s.client_identifier,1,40) as username,
 event,
-- object_type || ' ' || owner ||'.'|| object_name req_object,
 last_call_et,
 seconds_in_wait as secs_in_wait,
 blocking_session_status as block_sesstat,
 pdml_enabled,
 s.sql_id,
 s.osuser,
 p.spid,
 s.machine as clnt_host,
 s.process as clnt_pid,
 s.port    as clnt_port, 
 substr(trim(nvl(sa1.sql_text,sa2.sql_text)), 1, 100) sql_text,
 decode(sign(nvl(s.row_wait_obj#, -1)), -1, 'NONE', dbms_rowid.rowid_create(1, s.row_wait_obj#, s.row_wait_file#, s.row_wait_block#, s.row_wait_row#)) req_rowid,
 p1text || ' ' || decode(p1text, 'name|mode', chr(bitand(p1,-16777216)/16777215)||chr(bitand(p1, 16711680)/65535)||' '||bitand(p1, 65535), p1text) as
 p1text,
 p1,
 p1raw,
 p2text || ' ' || decode(p2text, 'object #', o.object_name || ' ' || o.owner || '.' || o.object_name, p2text) as
 p2text,
 p2
,
 p2raw,
 p3text,
 p3,
 p3raw
  from s
  left join gv$sqlarea sa1 on s.sql_id = sa1.sql_id and s.inst_id =  sa1.inst_id
  left join gv$sqlarea sa2 on s.prev_sql_id = sa2.sql_id and s.inst_id =  sa2.inst_id
  left join dba_objects o  on s.p2 = o.object_id
  left join gv$process p on s.paddr = p.addr and s.inst_id = p.inst_id
connect by nocycle prior sid = blocking_session and prior s.inst_id = blocking_instance
 start with (s.inst_id, s.sid)
            in (select inst_id, sid from blockers minus select inst_id, sid from waiters)