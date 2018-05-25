set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\oms_category_hourly_rpt.csv
set verify off
select col_name from (
select '商品部门,日期,上周时段业绩,时段业绩,时段业绩WOW,上周累计业绩,当天累计业绩,当天累计业绩WOW,时段来客数,当天来客数,时段客单,当天客单' as col_name,0 as row_num from dual
union
select distinct ',,'||TM||':00-'||(TM+1)||':00,'||TM||':00-'||(TM+1)||':00,'||',,,,'||TM||':00-'||(TM+1)||':00,'||','||TM||':00-'||(TM+1)||':00,'as col_name,1 as row_num from CATEGORY_PAY_STAGING
union
select ',JV华东,'||
sum(b.PAY_BY_TM)||','||
sum(a.pay)||','||
decode(sum(b.PAY_BY_TM),0,'',ROUND((sum(a.pay)-sum(b.PAY_BY_TM))/sum(b.PAY_BY_TM),2)*100)
||decode(SUM(b.PAY_BY_TM),null,'',0,'','%')||','||
sum(b.PAY_BY_DAY)||','||
sum(c.pay)||','||
decode(sum(b.PAY_BY_DAY),0,'',ROUND((sum(c.pay)-sum(b.PAY_BY_DAY))/sum(b.PAY_BY_DAY),2)*100)
||decode(SUM(b.PAY_BY_TM),null,'',0,'','%')||','||
sum(a.lk)||','||
sum(c.lk)||','||
sum(a.kd)||','||
SUM(c.kd) as col_name,2 as row_num
from vw_category_cur_tm a,vw_category_his_day_tm b,vw_category_cur_day c
where a.div=b.div
and a.div=c.div
union
SELECT '当日销售目标,'||(SELECT TO_CHAR(TO_DATE(MAX(dt),'yyyy-mm-dd'),'yyyymmdd') FROM CATEGORY_PAY_STAGING)||',,,,,'||(SELECT NVL(sales_target,0) FROM oms_cny_sales_value WHERE dt=(SELECT TO_CHAR(TO_DATE(MAX(dt),'yyyy-mm-dd'),'yyyymmdd') FROM CATEGORY_PAY_STAGING))||',,,,,,',3 AS row_num FROM dual
UNION
SELECT '销售目标差额,'||(SELECT TO_CHAR(TO_DATE(MAX(dt),'yyyy-mm-dd'),'yyyymmdd') FROM CATEGORY_PAY_STAGING)||',,,,,'||(SELECT decode(sales_target,null,null,Get_category_sales_diff()) FROM oms_cny_sales_value WHERE dt=(SELECT TO_CHAR(TO_DATE(MAX(dt),'yyyy-mm-dd'),'yyyymmdd') FROM CATEGORY_PAY_STAGING))||',,,,,,',4 AS row_num FROM dual
union
select col_name,row_num from (
SELECT a.DIV_NAME||','||
a.dt||','||
b.PAY_BY_TM||','||
a.pay||','||
decode(b.PAY_BY_TM,0,'',ROUND(((a.pay-b.PAY_BY_TM)/b.PAY_BY_TM),2)*100)
||decode(b.PAY_BY_TM,null,'',0,'','%')||','||
b.PAY_BY_DAY||','||
C.pay||','||
decode(b.PAY_BY_DAY,0,'',ROUND(((C.pay-b.PAY_BY_DAY)/b.PAY_BY_DAY),2)*100)
||decode(b.PAY_BY_TM,null,'',0,'','%')||','||
a.lk||','||
C.lk||','||
a.kd||','||
C.kd AS col_name,ROWNUM+5 AS row_num
FROM vw_category_cur_tm a,vw_category_his_day_tm b,vw_category_cur_day C
WHERE a.div=b.div
AND a.div=C.div
ORDER BY a.div
)
)
order by row_num;
spool off;
exit;
