set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\oms_category_check_log.csv
set verify off
select 'dt,tm' from dual
union
SELECT dt||','||tm FROM CATEGORY_PAY_STAGING WHERE ROWNUM=1
order by 1 desc;
spool off;
exit;
