set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\oms_district_hourly_rpt.csv
set verify off
select col_name from (
select '店群,日期,时段业绩,当天累计业绩,3天累计业绩,时段来客数,当天来客数,时段客单,当天客单' as col_name,0 as row_num from dual
union
select distinct ',,'||TM||':00-'||(TM+1)||':00,'||',,'||TM||':00-'||(TM+1)||':00,'||','||TM||':00-'||(TM+1)||':00,'as col_name,1 as row_num from CATEGORY_PAY_STAGING
union
select ',JV华东,'||
sum(a.pay)||','||
sum(c.pay)||','||
sum(b.PAY_BY_DAY)||','||
sum(a.lk)||','||
sum(c.lk)||','||
round(sum(a.pay)/sum(a.lk))||','||
round(sum(c.pay)/sum(c.lk)) as col_name,2 as row_num
from vw_DISTRICT_cur_tm a,VW_DISTRICT_HIS_THREE_DAY_TM b,vw_DISTRICT_cur_day c
where a.DISTRICT_NAME=b.DISTRICT_NAME
and a.DISTRICT_NAME=c.DISTRICT_NAME
union
select col_name,row_num from (
SELECT a.DISTRICT_NAME||','||
a.dt||','||
a.pay||','||
c.pay||','||
b.PAY_BY_DAY||','||
a.lk||','||
C.lk||','||
round((a.pay/a.lk))||','||
round((c.pay/c.lk)) AS col_name,ROWNUM+3 AS row_num
FROM vw_DISTRICT_cur_tm a,VW_DISTRICT_HIS_THREE_DAY_TM b,vw_DISTRICT_cur_day C
WHERE a.DISTRICT_NAME=b.DISTRICT_NAME
AND a.DISTRICT_NAME=C.DISTRICT_NAME
ORDER BY a.DISTRICT_NAME
)
)
order by row_num;
spool off;
exit;
