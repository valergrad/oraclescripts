-- changed parameters
with t as (select min (snap_id) min_snap from dba_hist_parameter),
s as ( select snap_id, parameter_name, value, lag (value) over (partition by parameter_name order by snap_id) prev_value from dba_hist_parameter)    
select *
  from s natural join dba_hist_snapshot sn join t on 1 = 1
where snap_id > min_snap
    and nvl (value, '##') != nvl (prev_value, '##')
--and parameter_name !=  'resource_manager_plan'   
order by snap_id;
