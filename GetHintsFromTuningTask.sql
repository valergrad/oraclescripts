
begin  
 dbms_output.put_line('task id: '||
 dbms_sqltune.create_tuning_task(
    task_name=>'test',
    description=>'test tuning task',
    scope=>dbms_sqltune.scope_comprehensive,
    time_limit=>30,
    sql_id=>'f3ywyn4m23rs3'
  )
 );
    dbms_sqltune.execute_tuning_task('test');
end;
/


select * from dba_advisor_recommendations;
select task_name from dba_advisor_tasks where how_created != 'AUTO' and status = 'COMPLETED' and execution_type = 'TUNE SQL';
select * from dba_advisor_objects where owner=input_task_owner and task_name=input_task_name and type='SQL';
select * from dba_advisor_objects where attr1 = '14r04b77yhx14';
select * from dba_advisor_tasks where advisor_name = 'SQL Tuning Advisor';
select * from dba_advisor_rationale;
select * from sys.dba_advisor;

select * from dba_sql_profiles where name  = 'coe_52bta0acqnvvu_2518552343'; 
select * from dba_sqltune_plans where execution_name = 'EXEC_119257' and other_xml is not null ;


-- get hints from tuning task
declare
  -- input variables
  input_task_owner dba_advisor_tasks.owner%type:='SYS';
  input_task_name dba_advisor_tasks.task_name%type:='SYS_AUTO_SQL_TUNING_TASK';
  input_show_outline boolean:=false;
  -- local variables
  task_id  dba_advisor_tasks.task_id%type;
  outline_data xmltype;
  benefit number;
begin
  for o in ( select * from dba_advisor_objects where owner=input_task_owner and task_name=input_task_name and type='SQL')
  loop
          -- get the profile hints (opt_estimate)
          dbms_output.put_line('--- PROFILE HINTS from '||o.task_name||' ('||o.object_id||') statement '||o.attr1||':');
          dbms_output.put_line('/*+');
          for r in (
            select hint,benefit from (
             select case when attr5 like 'OPT_ESTIMATE%' then cast(attr5 as varchar2(4000)) when attr1 like 'OPT_ESTIMATE%' then attr1 end hint,benefit
             from dba_advisor_recommendations t join dba_advisor_rationale r using (task_id,rec_id)
             where t.owner=o.owner and t.task_name = o.task_name and r.object_id=o.object_id and t.type='SQL PROFILE'
             --and r.message='This attribute adjusts optimizer estimates.'
            ) order by to_number(regexp_replace(hint,'^.*=([0-9.]+)[^0-9].*$','1'))
          ) loop
           dbms_output.put_line('   '||r.hint); benefit:=to_number(r.benefit)/100;
          end loop;
          dbms_output.put_line('*/');
          -- get the outline hints
          begin
          select outline_data into outline_data from (
              select case when other_xml is not null then extract(xmltype(other_xml),'/*/outline_data/hint') end outline_data
              from dba_advisor_tasks t join dba_sqltune_plans p using (task_id)
              where t.owner=o.owner and t.task_name = o.task_name and p.object_id=o.object_id  and t.advisor_name='SQL Tuning Advisor' --11gonly-- and execution_type='TUNE SQL'
              and p.attribute='Using SQL profile'
          ) where outline_data is not null;
          exception when no_data_found then null;
          end;
          exit when not input_show_outline;
          dbms_output.put_line('--- OUTLINE HINTS from '||o.task_name||' ('||o.object_id||') statement '||o.attr1||':');
          dbms_output.put_line('/*+');
          for r in (
              select (extractvalue(value(d), '/hint')) hint from table(xmlsequence(extract( outline_data , '/'))) d
          ) loop
           dbms_output.put_line('   '||r.hint);
          end loop;
          dbms_output.put_line('*/');
          dbms_output.put_line('--- Benefit: '||to_char(to_number(benefit),'FM99.99')||'%');
  end loop;
  dbms_output.put_line('');
end;
/