set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\jvbi_daily_batch_monitor.&1..csv
set verify off
select 'DT,JOB_ID,PRO_NAME,LOG_DESC,STATUS,ERROR_MSG' from dual;
SELECT to_char(dt,'yyyy-mm-dd hh24:mi:ss')||','||
job_id||','||
pro_name||','||
log_desc||','||
status||','||
error_msg 
FROM JVBI_SYSTEM_LOG
WHERE TO_CHAR(dt,'yyyy-mm-dd')=TO_CHAR(SYSDATE,'yyyy-mm-dd')
and status>0
order by dt,job_id,status;
spool off;
exit;