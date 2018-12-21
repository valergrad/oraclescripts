select * from v$option;

-- exec dbms_stats.set_table_prefs('RRS_CORE_DBO', 'NODE', 'PUBLISH', 'false');
-- alter session set optimizer_use_pending_statistics = true;
 
EXEC DBMS_SQLTUNE.create_sqlset(sqlset_name => 'test_bond_sqlset');

DECLARE
  l_cursor  DBMS_SQLTUNE.sqlset_cursor;
BEGIN
  OPEN l_cursor FOR
     SELECT VALUE(a)
     FROM   TABLE(
              DBMS_SQLTUNE.select_cursor_cache(
                --basic_filter   => q'[ parsing_schema_name = 'DSO_REFDATA_USER' or parsing_schema_name = 'DSO_I_REFDATA_DBO' or parsing_schema_name = 'DSO_T_REFDATA_DBO']',
                basic_filter   => q'[sql_text LIKE '%bond_static%' ]',
                --object_filter   => q'[DSO_I_REFDATA_DBO.I_BOND_STATIC]',
                attribute_list => 'ALL')
            ) a;
                                               
 
  DBMS_SQLTUNE.load_sqlset(sqlset_name     => 'test_bond_sqlset',
                           populate_cursor => l_cursor);
END;
/

SELECT *
FROM   dba_sqlset_statements
WHERE  sqlset_name = 'test_bond_sqlset';

declare
    v varchar2(64);
begin
    v := DBMS_SQLPA.create_analysis_task(sqlset_name => 'test_bond_sqlset');
    dbms_output.put_line(v);     
end;

BEGIN
  DBMS_SQLPA.execute_analysis_task(
    task_name       => :v_task,
    execution_type  => 'test execute',
    execution_name  => 'before_change');
END;
/

BEGIN
  DBMS_SQLPA.execute_analysis_task(
    task_name       => :v_task,
    execution_type  => 'test execute',
    execution_name  => 'after_change');
END;
/


BEGIN
  DBMS_SQLPA.execute_analysis_task(
    task_name        => :v_task,
    execution_type   => 'compare performance', 
    execution_params => dbms_advisor.arglist(
                          'comparison_metric', 'buffer_gets',
                          'execution_name1', 'before_change', 
                          'execution_name2', 'after_change')
    );
END;
/


SELECT DBMS_SQLPA.report_analysis_task(:v_task, 'HTML', 'ALL') FROM   dual;

select * from sys.DBA_ADVISOR_FINDINGS where task_name = :v_task;
select * from SYS.DBA_ADVISOR_SQLSTATS where task_name = :v_task;

BEGIN
  DBMS_SQLTUNE.DROP_TUNING_TASK(task_name => :v_task);
END;

exec DBMS_SQLTUNE.drop_sqlset('test_bond_sqlset');

select description, created, owner 
from DBA_SQLSET_REFERENCES 
where sqlset_name = 'test_bond_sqlset';


