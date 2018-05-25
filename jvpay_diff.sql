set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\jvpay_diff.&1..csv
set verify off
select 'LOCATION,DT,RMS_TOTAL_RETAIL,JVBI_TOTAL_RETAIL,DIFF' from dual;
SELECT AA.LOCATION||','||AA.dt||','||BB.total_retail||','||AA.total_retail||','||(BB.total_retail-AA.total_retail)
FROM 
(SELECT shopid AS LOCATION,dt,total_retail FROM JVPAY_J_DIFF@JVBI) AA,
(
SELECT LOCATION,TO_CHAR(tran_date,'yyyymm') AS dt,SUM(total_retail) AS total_retail FROM tran_data_history A,backupwt.peter_store b
WHERE 
A.LOCATION=b.STORE
AND A.tran_code=1
AND tran_date>=LAST_DAY(ADD_MONTHS(TO_DATE(TO_CHAR(SYSDATE,'yyyy-mm-dd'),'yyyy-mm-dd'),-2))+1
AND tran_date<=LAST_DAY(ADD_MONTHS(TO_DATE(TO_CHAR(SYSDATE,'yyyy-mm-dd'),'yyyy-mm-dd'),-1))
GROUP BY LOCATION,TO_CHAR(tran_date,'yyyymm')) BB
WHERE AA.LOCATION=BB.LOCATION
AND AA.dt=BB.dt
order by BB.total_retail-AA.total_retail asc;
spool off;
exit;