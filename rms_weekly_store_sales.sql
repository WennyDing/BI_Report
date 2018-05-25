set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\重点门店销售.&1..csv
set verify off
select col_name from (
select '日期,店群编号,店群名称,门店号,门店名称,大部门,大部门名称,分类号,分类名称,周销量,周销售净额,周销售金额,周BG,月销量,月销售净额,月销售金额,月BG,周客流,月客流,周客单,月客单,周销售数量LFL,月销售数量LFL,周销售净额LFL,月销售净额LFL,周预算达成,月预算达成,周预算差异,月预算达成' as col_name,0 as row_num from dual
union
select col_name,rownum as row_num from (
select 
日期||','||
店群编号||','||
店群名称||','||
门店号||','||
门店名称||','||
大部门||','||
大部门名称||','||
分类号||','||
分类名称||','||
周销量||','||
周销售净额||','||
周销售金额||','||
周BG||','||
月销量||','||
月销售净额||','||
月销售金额||','||
月BG||','||
周客流||','||
月客流||','||
decode(周销售金额,0,0,round(周销售金额/周客流,4))||','||
decode(月销售金额,0,0,round(月销售金额/月客流,4))||','||
decode(同周销售数量,0,0,ROUND((周销量-同周销售数量)/同周销售数量,4))||','||
decode(同月销售数量,0,0,ROUND((月销量-同月销售数量)/同月销售数量,4))||','||
decode(同周销售净额,0,0,round((周销售净额-同周销售净额)/同周销售净额,4))||','||
decode(同月销售净额,0,0,round((月销售净额-同月销售净额)/同月销售净额,4))||','||
decode(周销售净额,0,0,round(周预算/周销售净额,4))||','||
decode(月销售净额,0,0,round(月预算/月销售净额,4))||','||
(周销售净额-周预算)||','||
(月销售净额-月预算) as col_name
from infbat.weekly_store_vw@JVRMS
where 门店号 in (select store from peter_store)))
order by row_num;
spool off;
exit;