set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\huaruntong_sales_rpt.&1..csv
set verify off
SELECT col_name FROM (
SELECT 'dt,district,district_name,shopid,store_name,item,item_desc,groupno,deptno,item_pos_cnt,item_cnt,item_SIV,item_SEV,retail_vat_rate' AS col_name,0 AS row_num FROM dual
UNION
SELECT col_name,ROWNUM AS row_num FROM (
SELECT TO_CHAR(CAST(TO_CHAR(jvj.dt,'yyyy-mm-dd')||','||
       dst.DISTRICT||','||
       dst.district_name||','||
       jvj.shopid||','||
       str.store_name||','||
       jvj.vgno||','||
       itm.item_desc||','||
       jvj.groupno||','||
       jvj.deptno||','||
       COUNT(1)||','||
       SUM(jvj.amount)||','||
       SUM(jvj.item_value - jvj.disc_value - jvj.vipdisc_value)||','||
       ROUND(SUM(jvj.item_value - jvj.disc_value - jvj.vipdisc_value)/(1+vit.retail_vat_rate/100),2)||','||
       vit.retail_vat_rate AS NVARCHAR2(1000))) AS col_name
  FROM JVSALE_J_2017 jvj
     , STORE str
     , DISTRICT dst
     , ITEM_MASTER itm
     , VAT_ITEM vit
     , O2O_STORE_POS pos
 WHERE 1=1
   AND jvj.dt >= TRUNC(SYSDATE-3)
   AND jvj.shopid = pos.STORE
   AND jvj.pos_id = pos.pos_id
   AND jvj.shopid = str.STORE
   AND str.DISTRICT = dst.DISTRICT
   AND jvj.vgno = itm.item
   AND jvj.vgno = vit.item
   and str.store not in (select store from jv_closed_store)
GROUP BY jvj.dt
     , dst.DISTRICT
     , dst.district_name
     , jvj.shopid
     , str.store_name
     , jvj.vgno
     , itm.item_desc
     , jvj.groupno
     , jvj.deptno
     , vit.retail_vat_rate
ORDER BY jvj.dt
     , dst.DISTRICT
     , jvj.shopid
     , jvj.vgno)
	 ORDER BY 2);
spool off;
exit;