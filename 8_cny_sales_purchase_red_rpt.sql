set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_sales_purchase_red_rpt.csv
set verify off
SELECT col_name FROM (
SELECT '日期,商品部门,商品总监,商品品类,商品经理,商品采购,当日未税销售,当日未税销售预算,当日未税销售达成,去年同期未税销售,当日未税销售LFL,CNY累计未税销售,CNY累计未税销售预算,CNY累计未税销售达成,去年CNY累计未税销售,CNY累计未税销售LFL' AS col_name ,0 row_num FROM DUAL
UNION
select col_name,rownum as row_num from (
select to_char(tran_date,'yyyy-mm-dd')||','||
     rpt_div_name||','||
     director||','||
     group_name||','||
     manager||','||
     buyer||','||
     sev||','||
     sev_budget||','||                 
     decode(sev_budget, 0, '', round(sev/sev_budget,2)*100||'%')||','||
     sev_lfl||','||
     decode(sev_lfl, 0, '', round(sev/sev_lfl-1,2)*100||'%')||','||
     sev_cny_total||','||
     sev_budget_cny_total||','||            
     decode(sev_budget_cny_total, 0, '', round(sev_cny_total/sev_budget_cny_total,2)*100||'%')||','||
     sev_lfl_cny_total||','||
     decode(sev_lfl_cny_total, 0, '', round(sev_cny_total/sev_lfl_cny_total-1,2)*100||'%') as col_name
from ( 
select max(tran_date) as tran_date
     , phb.rpt_div_name
     , phb.director
     , phb.group_name
     , phb.manager
     , phb.buyer
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
group by phb.rpt_div_name
     , phb.director
     , phb.group_name
     , phb.manager
     , phb.buyer
)
where (sev <>0 or sev_budget <> 0)
  and nvl(sev,0) >= nvl(sev_budget,0)
order by decode(sev_budget, 0, 0, sev/sev_budget) desc, rpt_div_name, director, group_name, manager, buyer, sev, sev_budget desc
)
)
order by row_num;
spool off;
exit;
