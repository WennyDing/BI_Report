set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_sales_category_rpt.csv
set verify off
SELECT col_name FROM (
SELECT '部门/BU名称,日期,当日未税销售,当日未税销售预算,当日未税销售达成,去年同期未税销售,当日未税销售LFL,,CNY累计未税销售,CNY累计未税销售预算,CNY累计未税销售达成,去年CNY累计未税销售,CNY累计未税销售LFL' AS col_name ,0 row_num FROM DUAL
UNION
SELECT col_name,rownum as row_num from (
select rpt_div_name||','||
     TO_CHAR(tran_date,'yyyy-mm-dd')||','||
     sev||','||
     sev_budget||','||
     decode(sev_budget, 0, '', round(sev/sev_budget,2)*100||'%')||','||
     sev_lfl||','||
     decode(sev_lfl, 0, '', round(sev/sev_lfl-1,2)*100||'%')||','||
     '  '||','||
     sev_cny_total||','||			             
     sev_budget_cny_total||','||
     decode(sev_budget_cny_total, 0, '', round(sev_cny_total/sev_budget_cny_total,2)*100||'%')||','||
     sev_lfl_cny_total||','||
     decode(sev_lfl_cny_total, 0, '', round(sev_cny_total/sev_lfl_cny_total-1,2)*100||'%') as col_name
from ( 
select max(tran_date) as tran_date
     , '0' as line_type
     , 'JV华东' as rpt_div_name
     , round(sum(decode(tran_date,trunc(sysdate-1),sev,0))) as sev
     , round(sum(decode(tran_date,trunc(sysdate-1),sev_lfl,0))) as sev_lfl
     , round(sum(decode(tran_date,trunc(sysdate-1),sev_budget,0))) as sev_budget
     , round(sum(sev)) as sev_cny_total
     , round(sum(sev_lfl)) as sev_lfl_cny_total
     , round(sum(sev_budget)) as sev_budget_cny_total     
  from cny_hhb_daily_2016
 where dept is not null
   and tran_date <= trunc(sysdate-1)  
union all
select max(tran_date) as tran_date
     , '1' || phb.division as line_type
     , '    '||phb.rpt_div_name
     , round(sum(decode(tran_date,trunc(sysdate-1),sev,0))) as sev
     , round(sum(decode(tran_date,trunc(sysdate-1),sev_lfl,0))) as sev_lfl
     , round(sum(decode(tran_date,trunc(sysdate-1),sev_budget,0))) as sev_budget
     , round(sum(sev)) as sev_cny_total
     , round(sum(sev_lfl)) as sev_lfl_cny_total
     , round(sum(sev_budget)) as sev_budget_cny_total
  from cny_hhb_daily_2016 chd
     , ph_buyer_2016cny phb
 where chd.dept is not null
   and chd.dept = phb.dept
   and chd.tran_date <= trunc(sysdate-1)  
group by phb.division, phb.rpt_div_name 
)
order by line_type, rpt_div_name
))
order by row_num;
spool off;
exit;
