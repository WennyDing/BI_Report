set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\����ڻ�_subclass-loc����.csv
set verify off
select col_name from (
select '����,С�����,�ŵ�,���۽��' from dual;
SELECT TO_CHAR(c.tran_date,'yyyy-mm-dd') "����",
A.dept||A.CLASS||A.subclass "С�����",
b.STORE "�ŵ�",
SUM(c.total_retail) "���۽��"
FROM item_master A,jv_store_vw b,tran_data_history c
WHERE A.item=c.item
AND b.STORE=c.LOCATION
AND tran_code=1
AND c.TRAN_DATE BETWEEN TO_DATE('2016-8-22','yyyy-mm-dd') AND TO_DATE('2016-10-9','yyyy-mm-dd')
GROUP BY c.tran_date,A.dept,A.CLASS,A.subclass,b.STORE
ORDER BY 1,3,2;
spool off;
exit;