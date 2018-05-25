set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\jvbi_sale_regression_analyse.csv
set verify off
SELECT col_name FROM (
SELECT 'sale_year,wk,shopid,subclass,item,sale_qty,price,normal_price,discount,正常销售标记,促销销售标记,正常销售,促销销售,基准正常周销售1,75分位值1,标准差1,上限1,修正后正常销售1,基准正常周销售2,75分位值2,标准差2,上限2,修正后正常销售2,基准正常周销售3,平均5周销售,平均9周销售,平滑销售,修正后平滑销售,修正后基准正常周销售,季节性周波动因子,促销因子,预计季节性波动因子,预估正常销售' AS col_name,0 AS row_num FROM dual
UNION
select col_name,rownum as row_num from (
select  SALE_YEAR||','||
WK||','||
SHOPID||','||
SUBCLASS||','||
ITEM||','||
SALE_QTY||','||
PRICE||','||
NORMAL_PRICE||','||
DISCOUNT||','||
"正常销售标记"||','||
"促销销售标记"||','||
"正常销售"||','||
"促销销售"||','||
"基准正常周销售1"||','||
"75分位值1"||','||
"标准差1"||','||
"上限1"||','||
"修正后正常销售1"||','||
"基准正常周销售2"||','||
"75分位值2"||','||
"标准差2"||','||
"上限2"||','||
"修正后正常销售2"||','||
"基准正常周销售3"||','||
"平均5周销售"||','||
"平均9周销售"||','||
"平滑销售"||','||
"修正后平滑销售"||','||
"修正后基准正常周销售"||','||
"季节性周波动因子"||','||
"促销因子"||','||
"预计季节性波动因子"||','||"预估正常销售"
as col_name
from JVBI_SALE_REGRESSION
order by SALE_YEAR,WK,SHOPID,ITEM
))
order by row_num;
spool off;
exit;