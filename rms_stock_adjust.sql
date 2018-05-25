set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\库存调整_&1..csv
set verify off
SELECT col_name FROM (
SELECT '月份,店号,店名,部门编码,部门名称,品类编码,品类名称,大类编码,大类名称,中类编码,中类名称,小类编码,小类名称,商品编码,商品全称,调整原因,调整原因描述,期初数量,上调数量,下调数量,期末数量,期初库存金额,上调金额,下调金额,期末库存金额' AS col_name,0 FROM dual
UNION
SELECT col_name,ROWNUM FROM (
SELECT TO_CHAR(ta.adj_date,'yyyy-mm')||','||
ta.LOCATION||','||
STORE.store_name||','||
div.division||','||
div.div_name||','||
gro.group_no||','||
gro.group_name||','||
deps.dept||','||
deps.dept_name||','||
CLASS.CLASS||','||
CLASS.class_name||','||
sub.subclass||','||
sub.sub_name||','||
ta.item||','||
im.item_desc||','||
ta.reason||','||
tar.reason_desc||','||
DECODE(slw.stock_on_hand,NULL,0,slw.stock_on_hand)||','||
CASE WHEN ta.adj_qty>0 THEN  ta.adj_qty ELSE  0 END||','||
CASE WHEN ta.adj_qty<0 THEN  ta.adj_qty ELSE  0 END||','||
DECODE(sl.stock_on_hand,NULL,0,sl.stock_on_hand)||','||
DECODE(slw.total_cost,NULL,0,slw.total_cost)||','||
CASE WHEN DECODE(sl.total_cost,NULL,0,sl.total_cost)-DECODE(slw.total_cost,NULL,0,slw.total_cost)>0 THEN DECODE(sl.total_cost,NULL,0,sl.total_cost)-DECODE(slw.total_cost,NULL,0,slw.total_cost) ELSE 0 END||','||
CASE WHEN DECODE(sl.total_cost,NULL,0,sl.total_cost)-DECODE(slw.total_cost,NULL,0,slw.total_cost)<0 THEN DECODE(sl.total_cost,NULL,0,sl.total_cost)-DECODE(slw.total_cost,NULL,0,slw.total_cost) ELSE 0 END||','||
DECODE(sl.total_cost,NULL,0,sl.total_cost) AS col_name
 FROM INV_ADJ ta
LEFT JOIN INV_ADJ_REASON tar
ON  ta.reason=tar.reason
LEFT JOIN item_master im
ON im.item=ta.item
INNER JOIN jv_store_vw STORE
ON STORE.STORE=ta.LOCATION
LEFT JOIN division div
ON div.division=SUBSTR(im.dept,1,1)
LEFT JOIN GROUPS gro
ON gro.group_no=SUBSTR(im.dept,1,2)
LEFT JOIN deps
ON im.dept=deps.dept
LEFT JOIN CLASS 
ON CLASS.dept||CLASS.CLASS=im.dept||im.CLASS
LEFT JOIN subclass sub
ON sub.dept||sub.CLASS||sub.subclass=im.dept||im.CLASS||im.subclass
LEFT JOIN (
SELECT item,LOCATION,eom_date,stock_on_hand,stock_on_hand*av_cost total_cost 
FROM tsc_slow_stock
WHERE eom_date=TRUNC(ADD_MONTHS(SYSDATE,-1),'mm')
) slw
ON slw.LOCATION=ta.LOCATION AND ta.item=slw.item AND TO_CHAR(slw.eom_date,'YYYYMM')=TO_CHAR(ta.adj_date,'YYYYMM')
LEFT JOIN (
SELECT item,LOCATION,eom_date,stock_on_hand,stocK_on_hand*av_cost total_cost 
FROM tsc_slow_stock 
WHERE eom_date=LAST_DAY(TRUNC(ADD_MONTHS(SYSDATE,-1),'mm'))
) sl
ON sl.LOCATION=ta.LOCATION AND ta.item=sl.item AND TO_CHAR(sl.eom_date,'YYYYMM')=TO_CHAR(ta.adj_date,'YYYYMM')
WHERE ta.reason IN (101,103,104,105,106,107,109,113,116,117,888)
AND ta.loc_type='S'
AND ta.adj_date>=TRUNC(ADD_MONTHS(SYSDATE,-1),'mm')
AND ta.adj_date<=LAST_DAY(TRUNC(ADD_MONTHS(SYSDATE,-1),'mm'))
ORDER BY ta.LOCATION,div.division,gro.group_no,deps.dept,CLASS.CLASS,sub.subclass)
ORDER BY 2
);
spool off;
exit;
