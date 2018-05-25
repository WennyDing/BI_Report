set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\b2b_monthly_sale_dept_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT '门店,门店名称,店群,品类,大类,大类名称,商品编号,商品条码,商品名称,商品销售金额,销售日期,月份,周数,商品销售净额,商品税率,商品成本价,商品销量,销售毛利,商品部门,主供应商编码,主供应商名称'  AS col_name,0 FROM dual
UNION 
SELECT col_name,ROWNUM FROM (
SELECT 
门店||','||
门店名称||','||
店群||','||
品类||','||
大类||','||
大类名称||','||
商品编号||','||
商品条码||','||
商品名称||','||
商品销售金额||','||
TO_CHAR(销售日期,'yyyy-mm-dd')||','||
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
FROM b2b_monthly_sale_dept_vw
)ORDER BY 2);
spool off;
exit;