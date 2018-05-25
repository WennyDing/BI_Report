set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_sales_store_black_rpt.csv
set verify off
SELECT col_name FROM (
SELECT '店群,门店编号,门店名称,日期,当日未税销售,当日未税销售预算,当日未税销售达成,去年同期未税销售,当日未税销售LFL,CNY累计未税销售,CNY累计未税销售预算,CNY累计未税销售达成,去年CNY累计未税销售,CNY累计未税销售LFL' AS col_name,1 AS order_seq,0 FROM DUAL
UNION
SELECT col_name,order_seq,rownum FROM (
SELECT rpt_district_name
     ||','||STORE
     ||','||store_name	
     ||','||TO_CHAR(tran_date,'yyyy-mm-dd')       
     ||','||sev            
     ||','||sev_budget
     ||','||DECODE(sev_budget,0,0,ROUND(sev/sev_budget,2))*100||'%'
     ||','||sev_lfl
     ||','||DECODE(sev_lfl,0,0,ROUND(sev/sev_lfl-1,2))*100||'%'
     ||','||sev_cny_total
     ||','||sev_budget_cny_total
     ||','||DECODE(sev_budget_cny_total,0,0,ROUND(sev_cny_total/sev_budget_cny_total,2))*100||'%'
     ||','||sev_lfl_cny_total
     ||','||DECODE(sev_lfl_cny_total,0,0,ROUND(sev_cny_total/sev_lfl_cny_total-1,2))*100||'%' AS col_name,2 AS order_seq
FROM ( 
SELECT MAX(tran_date) AS tran_date
     , str.rpt_district_name
     , str.STORE
     , str.store_name
     , ROUND(SUM(DECODE(tran_date,TRUNC(SYSDATE-1),sev,0))) AS sev
     , ROUND(SUM(DECODE(tran_date,TRUNC(SYSDATE-1),sev_lfl,0))) AS sev_lfl
     , ROUND(SUM(DECODE(tran_date,TRUNC(SYSDATE-1),sev_budget,0))) AS sev_budget
     , ROUND(SUM(sev)) AS sev_cny_total
     , ROUND(SUM(sev_lfl)) AS sev_lfl_cny_total
     , ROUND(SUM(sev_budget)) AS sev_budget_cny_total
  FROM CNY_HHB_DAILY_2016 chd
     , STORE_HIERARCHY_2016CNY str
 WHERE chd.STORE IS NOT NULL
   AND chd.STORE = str.STORE
   AND chd.tran_date between to_date('2016-12-30','yyyy-mm-dd') and trunc(sysdate-1) ---modify zhuyuanling 2016/12/31 
GROUP BY str.rpt_district_name, str.STORE, str.store_name
)
WHERE sev < sev_budget
ORDER BY DECODE(sev_budget,0,0,sev/sev_budget) ASC, rpt_district_name, STORE )
ORDER BY 2,3) TT;
spool off;
exit;