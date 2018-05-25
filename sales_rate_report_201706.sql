set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\售出率报告_&1.年&2.月.csv
set verify off
SELECT col_name FROM (
SELECT '月份(2015年1月-至今),业态,店号,店名,大类编码,大类名称,进货金额,自营销售成本,售出率' AS col_name,0 AS order_seq
FROM dual
UNION
SELECT col_name,ROWNUM AS order_seq FROM (
SELECT--/*+parallel(m,8)*/ 
TO_CHAR(m.eom_date,'yyyy-mm')
||','||c.chain_name
||','||m.LOCATION        
||','||st.store_name
||','||dep.dept
||','||dep.dept_name
||','||(NVL(SUM(tsf_in_cost),0)+NVL(SUM(purch_cost),0))              
||','||/*abs*/(NVL(SUM(net_sales_cost),0))
||','||DECODE(NVL(SUM(tsf_in_cost),0)+NVL(SUM(purch_cost),0),0,NULL,ROUND(/*abs*/NVL(SUM(net_sales_cost),0)/(NVL(SUM(tsf_in_cost),0)+NVL(SUM(purch_cost),0)),3)*100||'%') AS col_name
--||','||ROUND(/*abs*/NVL(SUM(net_sales_cost),0)/(NVL(SUM(tsf_in_cost),0)+NVL(SUM(purch_cost),0)),3)*100||'%' AS col_name
FROM month_data m
,deps dep
,CLASS    CL
,subclass scl
,(SELECT STORE STORE
,s.store_name
,s.district
,'S' loc_type
FROM STORE s
UNION ALL
SELECT wh STORE
,wh_name store_name
,NULL district
,'W' loc_type
FROM wh
) st
,district di
,REGION   r
,area     A
,chain    c
,ESB.TSC_CRV_JV_MAP t
WHERE m.currency_ind = 'L'
AND dep.dept(+) = m.dept
AND CL.dept(+) = m.dept
AND CL.CLASS(+) = m.CLASS
AND scl.dept(+) = m.dept
AND scl.CLASS(+) = m.CLASS
AND scl.subclass(+) = m.subclass
AND st.STORE = m.LOCATION
AND di.district(+) = st.district
AND r.region(+) = di.region
AND A.area(+) = r.area
AND c.chain(+) = A.chain
AND t.loc = st.STORE
and st.STORE not in (select store from jv_closed_store@jvbi)
AND ((st.loc_type = 'S' AND t.bu_id = c.chain) OR (st.loc_type = 'W')) 
--AND m.eom_date = LAST_DAY(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'yyyy-MM'),'yyyy-MM'))
AND m.eom_date = to_date('2017-6-30','yyyy-mm-dd')
AND (A.chain = '31')
AND SUBSTR(m.dept,3,1)<>'9'
GROUP BY m.eom_date         
,c.chain_name
,m.LOCATION        
,st.store_name
,dep.dept
,dep.dept_name  
HAVING (NVL(SUM(opn_stk_cost),0)       <> 0
OR NVL(SUM(purch_cost),0)              <> 0
OR NVL(SUM(rtv_cost),0)                <> 0
OR NVL(SUM(tsf_in_cost),0)             <> 0
OR NVL(SUM(tsf_out_cost),0)            <> 0
OR NVL(SUM(reclass_in_cost),0)         <> 0
OR NVL(SUM(reclass_out_cost),0)        <> 0
OR NVL(SUM(net_sales_cost),0)          <> 0
OR NVL(SUM(shrinkage_cost),0)          <> 0
OR NVL(SUM(stock_adj_cost),0)          <> 0
OR (NVL(SUM(cost_variance_amt),0) + (NVL(SUM(margin_cost_variance),0)*-1)) <> 0
OR NVL(SUM(cls_stk_cost),0)            <> 0
OR NVL(SUM(net_sales_retail),0)        <> 0
OR NVL(SUM(net_sales_retail_ex_vat),0) <> 0)
AND (NVL(SUM(tsf_in_cost),0)+NVL(SUM(purch_cost),0)<>0 OR NVL(SUM(net_sales_cost),0)<>0)
ORDER BY m.LOCATION,dep.dept DESC))
ORDER BY order_seq;
spool off;
exit;