--- statistics of physical reads  
  select owner
        ,object_name
        ,sum (lio) lio
        ,sum (phio) phio
        ,sum (dio) dio
        ,round ( (sum (phio) + sum (dio)) / decode (sum (phio) + sum (dio) + sum (lio), 0, 1, sum (phio) + sum (dio) + sum (lio)), 3) coef_read        
    from (  select owner
                  ,object_name
                  ,max (logical_reads_total) lio
                  ,max (physical_reads_total) phio
                  ,max (physical_reads_direct_total) dio
              from dba_hist_seg_stat s
                  ,dba_hist_seg_stat_obj o
                  ,dba_hist_snapshot snap
                  ,gv$database db
                  ,gv$instance inst
             where     s.ts# = o.ts#
                   and s.obj# = o.obj#
                   and s.dataobj# = o.dataobj#
                   and s.snap_id = snap.snap_id
                   and db.inst_id = inst.inst_id
                   and s.instance_number = inst.instance_number
                   and s.dbid = db.dbid
                   and snap.dbid = db.dbid
                   and snap.instance_number = db.inst_id
                   and snap.begin_interval_time > sysdate - 7
          group by owner, object_name, subobject_name)
group by owner, object_name
--having object_name = 'I_OPTION_STATIC_NAT_P'
order by phio desc, coef_read desc;

-- contains of buffer cache
select
   o.owner          owner,
   o.object_name    object_name,
   o.subobject_name subobject_name,
   o.object_type    object_type,
   count(distinct file# || block#)         num_blocks
from
   dba_objects  o,
   v$bh         bh
where
   o.data_object_id  = bh.objd
and
   o.owner not in ('SYS','SYSTEM')
   --and o.owner = 'DSO_I_REFDATA_DBO'
and
   bh.status != 'free'
   --and (  object_name like 'I_OPTION_STATIC_NAT_P'  )
group by
   o.owner,
   o.object_name,
   o.subobject_name,
   o.object_type
order by
   count(distinct file# || block#) desc;      
;
