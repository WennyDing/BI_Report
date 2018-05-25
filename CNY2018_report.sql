set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\CNY2018_report.&1..csv
set verify off
select 'YYYY,DISTRICT_NAME,销售业绩,毛利额,毛利率,销售预算,剔除B2B业绩,B2B业绩,客流量,客单'from dual ;
select YYYY||','||
DISTRICT_NAME||','||
销售业绩||','||
毛利额||','||
毛利率||','||
销售预算||','||
剔除B2B业绩||','||
B2B业绩||','||
客流量||','||
客单
from  vw_JV_CNYSALES;
spool off;
exit;

