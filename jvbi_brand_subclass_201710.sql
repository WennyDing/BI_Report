set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\brand_subclass.&1..csv
set verify off
SELECT col_name FROM (
SELECT '日期,小类编码,门店编码,销售金额,销售成本' AS col_name,0 AS row_num FROM dual
UNION
select col_name,rownum as row_num from (
SELECT TO_CHAR(A.tran_date,'yyyy-mm-dd')||','||
A.subclass||','||
A.LOCATION||','||
SUM(A.total_retail)||','||
SUM(A.total_cost) AS col_name
FROM (SELECT tran_date,LOCATION,item,total_retail,total_cost,dept||CLASS||subclass AS subclass FROM tran_data_history WHERE tran_code=1 AND tran_date>=TRUNC(ADD_MONTHS(SYSDATE,-3),'mm')
AND tran_date<=LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE),-3))) A,
jv_store_vw b,
(SELECT b.item,b.dept FROM backupwt.item_master_2017 b
WHERE SUBSTR(b.dept,1,1) in ('1','2','3','4','5','6')) C
WHERE A.LOCATION=b.STORE
AND A.item=C.item
GROUP BY TO_CHAR(A.tran_date,'yyyy-mm-dd'),A.subclass,A.LOCATION
ORDER BY TO_CHAR(A.tran_date,'yyyy-mm-dd'),A.LOCATION,A.subclass
))
order by row_num;
spool off;
exit;