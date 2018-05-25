set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\rms_daily_ticket_report.&1..csv
set verify off
select col_name from (
select '日期,店群名称,门店号,门店名称,分类号,分类名称,供应商编号,供应商名称,货号,单品名,销售售价,当日销售数量,当日销售净额,当日销售金额,当日BG,当日客流,当日渗透率,月销售数量,月销售净额,同月销售净额,月销售金额,月BG,月客流,月渗透率' as col_name,0  from dual
union
select col_name,rownum from (
SELECT 日期||','||
店群名称||','||
门店号||','||
门店名称||','||
分类号||','||
分类名称||','||
供应商编号||','||
供应商名称||','||
货号||','||
单品名||','||
销售售价||','||
当日销售数量||','||
当日销售净额||','||
当日销售金额||','||
当日BG||','||
当日客流||','||
当日渗透率||','||
月销售数量||','||
月销售净额||','||
同月销售净额||','||
月销售金额||','||
月BG||','||
月客流||','||
月渗透率 AS col_name FROM (
SELECT 日期,
店群名称,
门店号,
门店名称,
分类号,
分类名称,
供应商编号,
供应商名称,
货号,
单品名,
销售售价,
当日销售数量,
当日销售净额,
当日销售金额,
当日BG,
当日客流,
当日渗透率,
月销售数量,
月销售净额,
同月销售净额,
月销售金额,
月BG,
月客流,
月渗透率 FROM daily_ticket_vw
WHERE 店群名称 <> '安徽' AND 货号 <>'000946925'
and 门店号 not in (select store from jv_closed_store@jvbi)
UNION
SELECT 日期,
店群名称,
门店号,
门店名称,
分类号,
分类名称,
供应商编号,
供应商名称,
货号,
单品名,
销售售价,
当日销售数量,
当日销售净额,
当日销售金额,
当日BG,
当日客流,
当日渗透率,
月销售数量,
月销售净额,
同月销售净额,
月销售金额,
月BG,
月客流,
月渗透率 FROM daily_ticket_vw
WHERE 店群名称 = '安徽' AND 货号 <>'000561870'
and 门店号 not in (select store from jv_closed_store@jvbi))
ORDER BY 日期,门店号,分类号
)
order by 2);
spool off;
exit;