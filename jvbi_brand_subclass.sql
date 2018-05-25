set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\brand_subclass.&1..csv
set verify off
SELECT col_name FROM (
SELECT '����,С�����,�ŵ����,���۽��,���۳ɱ�' AS col_name,0 AS row_num FROM dual
UNION
select col_name,rownum as row_num from (
SELECT TO_CHAR(A.tran_date,'yyyy-mm-dd')||','||
A.subclass||','||
A.LOCATION||','||
SUM(A.total_retail)||','||
SUM(A.total_cost) AS col_name
FROM (SELECT tran_date,LOCATION,item,total_retail,total_cost,dept||CLASS||subclass AS subclass FROM tran_data_history WHERE tran_code=1 AND tran_date>=TRUNC(ADD_MONTHS(SYSDATE,-1),'mm')
AND tran_date<=LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE),-1))) A,
jv_store_vw b,
(SELECT b.item,b.dept FROM item_master b
WHERE SUBSTR(b.dept,1,1)<7) C
WHERE A.LOCATION=b.STORE
AND A.item=C.item
GROUP BY TO_CHAR(A.tran_date,'yyyy-mm-dd'),A.subclass,A.LOCATION
ORDER BY TO_CHAR(A.tran_date,'yyyy-mm-dd'),A.LOCATION,A.subclass
))
order by row_num;
spool off;
exit;