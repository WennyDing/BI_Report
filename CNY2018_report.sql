set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\CNY2018_report.&1..csv
set verify off
select 'YYYY,DISTRICT_NAME,����ҵ��,ë����,ë����,����Ԥ��,�޳�B2Bҵ��,B2Bҵ��,������,�͵�'from dual ;
select YYYY||','||
DISTRICT_NAME||','||
����ҵ��||','||
ë����||','||
ë����||','||
����Ԥ��||','||
�޳�B2Bҵ��||','||
B2Bҵ��||','||
������||','||
�͵�
from  vw_JV_CNYSALES;
spool off;
exit;

