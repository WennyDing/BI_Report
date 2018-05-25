set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\jvbi_sale_regression_analyse.csv
set verify off
SELECT col_name FROM (
SELECT 'sale_year,wk,shopid,subclass,item,sale_qty,price,normal_price,discount,�������۱��,�������۱��,��������,��������,��׼����������1,75��λֵ1,��׼��1,����1,��������������1,��׼����������2,75��λֵ2,��׼��2,����2,��������������2,��׼����������3,ƽ��5������,ƽ��9������,ƽ������,������ƽ������,�������׼����������,�������ܲ�������,��������,Ԥ�Ƽ����Բ�������,Ԥ����������' AS col_name,0 AS row_num FROM dual
UNION
select col_name,rownum as row_num from (
select  SALE_YEAR||','||
WK||','||
SHOPID||','||
SUBCLASS||','||
ITEM||','||
SALE_QTY||','||
PRICE||','||
NORMAL_PRICE||','||
DISCOUNT||','||
"�������۱��"||','||
"�������۱��"||','||
"��������"||','||
"��������"||','||
"��׼����������1"||','||
"75��λֵ1"||','||
"��׼��1"||','||
"����1"||','||
"��������������1"||','||
"��׼����������2"||','||
"75��λֵ2"||','||
"��׼��2"||','||
"����2"||','||
"��������������2"||','||
"��׼����������3"||','||
"ƽ��5������"||','||
"ƽ��9������"||','||
"ƽ������"||','||
"������ƽ������"||','||
"�������׼����������"||','||
"�������ܲ�������"||','||
"��������"||','||
"Ԥ�Ƽ����Բ�������"||','||"Ԥ����������"
as col_name
from JVBI_SALE_REGRESSION
order by SALE_YEAR,WK,SHOPID,ITEM
))
order by row_num;
spool off;
exit;