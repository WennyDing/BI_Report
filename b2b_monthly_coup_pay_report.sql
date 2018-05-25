set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\b2b_monthly_coup_pay_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT CAST('dt,shopid,store_name,pos_id,listno,pos_pay_value,coupon_type,coupon_name,cpvalue,coup_pay_qty,coup_pay_value' AS NVARCHAR2(200)) AS col_name,0 FROM dual
UNION 
SELECT col_name,ROWNUM FROM (
SELECT TO_CHAR(dt,'yyyy-mm-dd')||','||
       shopid||','||
       store_name||','||
     pos_id||','||
     listno||','||
     pos_pay_value||','||
     coupon_type||','||
     coupon_name||','||
     cpvalue||','||
     coup_pay_qty||','||
     coup_pay_value AS col_name
FROM b2b_monthly_coup_pay_vw
)ORDER BY 2);
spool off;
exit;