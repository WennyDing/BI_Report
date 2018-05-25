set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
begin
  -- Call the procedure
  create_b2b_sales_weekly_rpt;
end;
/
spool D:\BI_Report\work\b2b_weekly_sales_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT '门店,门店名称,店群,品类,大类,大类名称,商品编号,商品条码,商品名称,商品销售金额,销售日期,月份,周数,商品销售净额,商品税率,商品成本价,商品销量,销售毛利,商品部门,主供应商编码,主供应商名称' AS col_name,0 FROM dual
UNION 
SELECT col_name,ROWNUM FROM (
SELECT 门店||','||
       门店名称||','||
       店群||','||
       品类||','||
       大类||','||
       大类名称||','||
       商品编号||','||
       商品条码||','||
       商品名称||','||
       商品销售金额||','||
       销售日期||','||
       月份||','||
       周数||','||
       商品销售净额||','||
       商品税率||','||
       商品成本价||','||
       商品销量||','||
       销售毛利||','||
       商品部门||','||
       主供应商编码||','||
       主供应商名称 AS col_name
FROM infbat.b2b_sales_weekly_rpt_vw
)ORDER BY 2);
spool off;
exit;