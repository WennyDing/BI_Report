set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\store_dept_sales_report.&1..csv
set verify off
select 'SG_CLASS_L2,SG_CLASS_L3,SG_CLASS_L4,BU名称,年,月,日期,门店编码,门店名称,区域,部门编码,部门名称,品类编码,品类名称,大类编码,大类名称,销售金额,销售净额,销售毛利,去年同店销售净额,去年同店销售毛利,月累计销售金额,月累计销售净额,月累计销售毛利,去年月累计销售净额,去年月累计销售毛利'
from dual ;
SELECT SG_CLASS_L2||','||
SG_CLASS_L3||','||
SG_CLASS_L4||','||
BU名称||','||
年||','||
月||','||
日期||','||
门店编码||','||
门店名称||','||
区域||','||
部门编码||','||
部门名称||','||
品类编码||','||
品类名称||','||
大类编码||','||
大类名称||','||
销售金额||','||
销售净额||','||
销售毛利||','||
去年同店销售净额||','||
去年同店销售毛利||','||
月累计销售金额||','||
月累计销售净额||','||
月累计销售毛利||','||
去年月累计销售净额||','||
去年月累计销售毛利
FROM vw_store_dept_sales
order by 1 desc;
spool off;
exit;

