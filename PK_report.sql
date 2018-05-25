set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\PK_report.&1..csv
set verify off
select '门店PK,店号,店名,时间段,不含B2B累计达成率'from dual ;
select 门店PK||','||
店号||','||
店名||','||
时间段||','||
不含B2B累计达成率*100||'%' from vw_store_pk;
select ',,,,' from dual ;
select '营运区PK,组别,营运区,时间段,不含B2B累计达成率' from dual ;
select 
营运区PK||','||
组别||','||
门店PK||','||
时间段||','||
不含B2B累计达成率 from vw_dis_pk;
select ',,,,' from dual ;
select '部门PK,组别,部门,时间段,含B2B累计达成率' from dual;
select 
部门PK||','||
编号||','||
部门||','||
时间段||','||
mg from (
select  '部门PK' 部门PK,'PK第1组' 编号,'杂百商品部' 部门,时间段,round(sum(retail)/sum(budget_day),4)*100||'%'  mg from vw_div_pk where remark <>1 group by 时间段
union
select  部门PK,组别,部门,时间段,mg*100||'%' mg from vw_div_pk  );
spool off;
exit;

