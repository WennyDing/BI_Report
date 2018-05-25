set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\brand_class.&1..csv
set verify off
SELECT col_name FROM (
SELECT cast('����,Brand,�ŵ����,���۽��,���۳ɱ�' as nvarchar2(50)) AS col_name,0 AS row_num FROM dual
UNION
select col_name,rownum as row_num from (
SELECT TO_CHAR(A.tran_date,'yyyy-mm-dd')||','||
C.brand||','||
A.LOCATION||','||
SUM(A.total_retail)||','||
SUM(A.total_cost) as col_name
FROM (SELECT tran_date,LOCATION,item,total_retail,total_cost FROM tran_data_history WHERE tran_code=1 AND tran_date>=TRUNC(ADD_MONTHS(SYSDATE,-1),'mm')
AND tran_date<=LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE),-1))) A,
jv_store_vw b,jvbi_brand_item C
WHERE A.LOCATION=b.STORE
AND A.item=C.item
GROUP BY TO_CHAR(A.tran_date,'yyyy-mm-dd'),C.brand,A.LOCATION
order by TO_CHAR(A.tran_date,'yyyy-mm-dd'),a.LOCATION
))
order by row_num;
spool off;
exit;