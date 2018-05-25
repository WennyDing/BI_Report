set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\DC-NDC_&1..csv
set verify off
SELECT 'STOCK_CATEGORY,DISCOUNT_TYPE,LOCATION,DEPT,SUPPLIER,SUP_NAME,TPNB_ITEM,TPNB_ITEM_DESC,TPND_ITEM,TPND_ITEM_DESC,ORDER_NO,STATUS,WRITTEN_DATE,NOT_BEFORE_DATE,CLOSE_DATE,CASE_ORDER,CASE_REVD,QTY_ORDER,QTY_REVD,UNIT_COST,ORDER_VALUE,REVD_VALUE,SUPP_PACK_SIZE,VAT_RATE,ORDER_TAX_AMOUNT,REVD_TAX_AMOUNT' FROM DUAL
UNION
select 'PBL'||','||
       discount_type||','||
       LOCATION||','||
       dept||','||
       supplier||','||
       sup_name||','||
       TPNB_Item||','||
       TPNB_Item_Desc||','||
       TPND_Item||','||
       TPND_Item_Desc||','||
       order_no||','||
       status||','||
       to_char(written_date,'yyyy-mm-dd')||','||
       to_char(not_before_date,'yyyy-mm-dd')||','||
       to_char(close_date,'yyyy-mm-dd')||','||
       (case when Item = TPNB_Item then original_order_qty / SUPP_PACK_SIZE else Original_order_Qty / TPND_CASE_SIZE end)||','||
       (case when Item = TPNB_Item then qty_received / SUPP_PACK_SIZE else QTY_RECEIVED / TPND_CASE_SIZE end)||','||
       (case when Item = TPNB_Item then original_order_qty else Original_order_Qty * TPND_PACK_QTY end)||','||
       (case when Item = TPNB_Item then qty_received else QTY_RECEIVED * TPND_PACK_QTY end)||','||
       unit_cost||','||
       original_order_qty*unit_cost||','||
       qty_received*unit_cost||','||
       supp_pack_size||','||
       vat_rate/100 ||','||
       NVL(original_order_qty*((1+vat_rate/100)*unit_cost),0) ||','||
       NVL(qty_received*((1+vat_rate/100)*unit_cost),0) 
from (SELECT 'PBL' stock_category,
      decode(od.discount_type,'F','促销','正常') as discount_type,
      oh.LOCATION,
      im.dept,
      oh.supplier,
      s.sup_name,
      ol.item,
      oh.order_no,
      oh.status,
      oh.written_date,
      oh.not_before_date,
      oh.close_date,
      NVL (ol.qty_ordered, 0) + NVL (ol.qty_cancelled, 0) original_order_qty,
      ol.qty_received,
      isc.supp_pack_size,
      im.item_desc,
      vat.vat_rate
      ,(CASE IM.PACK_IND WHEN 'N' THEN IM.ITEM ELSE ( SELECT PI.ITEM FROM PACKITEM pi WHERE PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Item
      ,(CASE IM.PACK_IND WHEN 'N' THEN IM.ITEM_DESC ELSE ( SELECT A.ITEM_DESC FROM ITEM_MASTER A, PACKITEM pi WHERE A.ITEM = PI.ITEM AND PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Item_Desc
      ,(CASE IM.PACK_IND WHEN 'N' THEN ( SELECT RIL.PRIMARY_PACK_NO FROM REPL_ITEM_LOC ril WHERE RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) ELSE IM.ITEM END ) AS TPND_Item
      ,(CASE IM.PACK_IND WHEN 'N' THEN ( SELECT A.ITEM_DESC FROM REPL_ITEM_LOC ril, ITEM_MASTER A WHERE A.ITEM = RIL.PRIMARY_PACK_NO AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) ELSE IM.ITEM_DESC END ) AS TPND_Item_Desc
      ,(CASE IM.PACK_IND WHEN 'N' THEN NVL( ( SELECT RIL.PRIMARY_PACK_QTY FROM REPL_ITEM_LOC ril WHERE RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ),( SELECT PI.PACK_QTY FROM PACKITEM pi,REPL_ITEM_LOC ril WHERE PI.PACK_NO = RIL.PRIMARY_PACK_NO AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) )
        ELSE ( SELECT PI.PACK_QTY FROM PACKITEM pi WHERE PI.PACK_NO = IM.ITEM ) END ) AS TPND_Pack_Qty
      ,(CASE IM.PACK_IND WHEN 'N' THEN ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc,REPL_ITEM_LOC ril WHERE ISC.ITEM = RIL.PRIMARY_PACK_NO AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION )
        ELSE ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc WHERE ISC.ITEM = IM.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' ) END ) AS TPND_Case_Size
      ,(CASE IM.PACK_IND WHEN 'N' THEN ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc WHERE ISC.ITEM = IM.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' )
        ELSE ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc, PACKITEM pi WHERE ISC.ITEM = PI.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' AND PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Case_Size
      ,(CASE IM.PACK_IND WHEN 'N' THEN ( SELECT IL.STORE_ORD_MULT FROM ITEM_LOC il WHERE IL.ITEM = IM.ITEM AND IL.LOC = OH.LOCATION )
        ELSE ( SELECT IL.STORE_ORD_MULT FROM ITEM_LOC il, PACKITEM pi WHERE IL.ITEM = PI.ITEM AND IL.LOC = OH.LOCATION AND PI.PACK_NO = IM.ITEM) END ) AS TPNB_SOM,
      oh.orig_approval_id,
      ol.unit_cost,
      oha.user_id
FROM ordhead oh,
     ordloc ol,
     sups s,
     item_master im,
     item_supp_country isc,
     (SELECT order_no, user_id FROM ordhead_au WHERE change_type = 'I') oha,
     (select distinct order_no,discount_type from ordloc_discount od where discount_type='F') od,
     vat_item vat
WHERE oh.loc_type = 'W'
      AND oh.location in (select wh from wh where physical_wh in (995045)) -- add by jason 2016/10/26
      AND oh.close_date >= TO_DATE('&2.','yyyymmdd')
      AND oh.close_date <= TO_DATE('&3.','yyyymmdd')
      AND oh.order_no = oha.order_no(+)
      AND oh.order_no = ol.order_no
      AND oh.supplier = s.supplier
       AND ol.item = im.item
      AND ol.item = isc.item
      AND oh.supplier = isc.supplier
      AND im.item=vat.item
      AND vat.vat_type='C'
      AND vat.ACTIVE_DATE = 
      (SELECT MAX(D_ED.ACTIVE_DATE) FROM vat_item D_ED WHERE vat.item = D_ED.item AND vat.vat_region = D_ED.vat_region AND D_ED.ACTIVE_DATE <= SYSDATE)
      AND ol.order_no NOT IN (SELECT DISTINCT order_no FROM ordloc ol WHERE ol.qty_cancelled > 0  AND ol.cancel_id <> 'ordautcl' AND NOT EXISTS (SELECT 1 FROM shipment sp WHERE sp.order_no = ol.order_no  AND sp.order_no IS NOT NULL ))
      AND not exists (select 1 from packitem_breakout t where t.pack_no=ol.item and t.comp_pack_no is not null )
      AND EXISTS (SELECT 'x' FROM roqrequest roq WHERE roq.stock_cat = 2 AND roq.wh in (select wh from wh where physical_wh in (995045)) and oh.order_no = roq.order_transfer_no)
      AND ol.order_no=od.order_no(+)
    )
UNION
select 'DC REPL'||','||
       discount_type||','||
       LOCATION||','||
       dept||','||
       supplier||','||
       sup_name||','|| 
       TPNB_Item||','||
       TPNB_Item_Desc||','||
       TPND_Item||','||
       TPND_Item_Desc||','||
       order_no||','||
       status||','||
       to_char(written_date,'yyyy-mm-dd')||','||
       to_char(not_before_date,'yyyy-mm-dd')||','||
       to_char(close_date,'yyyy-mm-dd')||','||
       (case when Item = TPNB_Item then original_order_qty / SUPP_PACK_SIZE else Original_order_Qty / TPND_CASE_SIZE end)||','||
       (case when Item = TPNB_Item then qty_received / SUPP_PACK_SIZE else QTY_RECEIVED / TPND_CASE_SIZE end)||','||
       (case when Item = TPNB_Item then original_order_qty else Original_order_Qty * TPND_PACK_QTY end)||','||
       (case when Item = TPNB_Item then qty_received else QTY_RECEIVED * TPND_PACK_QTY end)||','||
       unit_cost||','||
       original_order_qty*unit_cost||','||
       qty_received*unit_cost||','||
       supp_pack_size||','||
       vat_rate/100||','||
       NVL(original_order_qty*((1+vat_rate/100)*unit_cost),0)||','||
       NVL(qty_received*((1+vat_rate/100)*unit_cost),0)
from (SELECT 'DC REPL' stock_category,
      decode(od.discount_type,'F','促销','正常') as discount_type,
      oh.LOCATION,
      im.dept,
      oh.supplier,
      s.sup_name,
      ol.item,
      oh.order_no,
      oh.status,
      oh.written_date,
      oh.not_before_date,
      oh.close_date,
      NVL (ol.qty_ordered, 0) + NVL (ol.qty_cancelled, 0) original_order_qty,
      ol.qty_received,
      isc.supp_pack_size,
      im.item_desc,
      vat.vat_rate
      ,( CASE IM.PACK_IND WHEN 'N' THEN IM.ITEM ELSE ( SELECT PI.ITEM FROM PACKITEM pi WHERE PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Item
      ,( CASE IM.PACK_IND WHEN 'N' THEN IM.ITEM_DESC ELSE ( SELECT A.ITEM_DESC FROM ITEM_MASTER A, PACKITEM pi WHERE A.ITEM = PI.ITEM AND PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Item_Desc
      ,( CASE IM.PACK_IND WHEN 'N' THEN ( SELECT RIL.PRIMARY_PACK_NO FROM REPL_ITEM_LOC ril WHERE RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) ELSE IM.ITEM END ) AS TPND_Item
      ,( CASE IM.PACK_IND WHEN 'N' THEN ( SELECT A.ITEM_DESC FROM REPL_ITEM_LOC ril, ITEM_MASTER A WHERE A.ITEM = RIL.PRIMARY_PACK_NO AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) ELSE IM.ITEM_DESC END ) AS TPND_Item_Desc
      ,( CASE IM.PACK_IND WHEN 'N' THEN NVL( ( SELECT RIL.PRIMARY_PACK_QTY FROM REPL_ITEM_LOC ril WHERE RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) , ( SELECT PI.PACK_QTY FROM PACKITEM pi,REPL_ITEM_LOC ril WHERE PI.PACK_NO = RIL.PRIMARY_PACK_NO AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION ) )
         ELSE ( SELECT PI.PACK_QTY FROM PACKITEM pi WHERE PI.PACK_NO = IM.ITEM ) END ) AS TPND_Pack_Qty
      ,( CASE IM.PACK_IND WHEN 'N' THEN ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc,REPL_ITEM_LOC ril WHERE ISC.ITEM = RIL.PRIMARY_PACK_NO AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' AND RIL.ITEM = IM.ITEM AND RIL.LOCATION = OH.LOCATION )
         ELSE ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc WHERE ISC.ITEM = IM.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' ) END ) AS TPND_Case_Size
      ,( CASE IM.PACK_IND WHEN 'N' THEN ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc WHERE ISC.ITEM = IM.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' )
         ELSE ( SELECT ISC.SUPP_PACK_SIZE FROM ITEM_SUPP_COUNTRY isc, PACKITEM pi WHERE ISC.ITEM = PI.ITEM AND ISC.SUPPLIER = OH.SUPPLIER AND ISC.ORIGIN_COUNTRY_ID = 'CN' AND PI.PACK_NO = IM.ITEM ) END ) AS TPNB_Case_Size
      ,( CASE IM.PACK_IND WHEN 'N' THEN ( SELECT IL.STORE_ORD_MULT FROM ITEM_LOC il WHERE IL.ITEM = IM.ITEM AND IL.LOC = OH.LOCATION )
          ELSE ( SELECT IL.STORE_ORD_MULT FROM ITEM_LOC il, PACKITEM pi WHERE IL.ITEM = PI.ITEM AND IL.LOC = OH.LOCATION AND PI.PACK_NO = IM.ITEM) END ) AS TPNB_SOM,
      oh.orig_approval_id,
      ol.unit_cost,
      oha.user_id
FROM ordhead oh,
     ordloc ol,
     sups s,
     item_master im,
     item_supp_country isc,
     (SELECT order_no, user_id FROM ordhead_au WHERE change_type = 'I') oha,
     (select distinct order_no,discount_type from ordloc_discount od where discount_type='F') od,
     vat_item vat
WHERE oh.loc_type = 'W'
      AND oh.location in (select wh from wh where physical_wh in (995045)) -- add by jason 2016/10/26
      AND oh.close_date >= TO_DATE('&2.','yyyymmdd')
      AND oh.close_date <= TO_DATE('&3.','yyyymmdd')
      AND oh.order_no = oha.order_no(+)
      AND oh.order_no = ol.order_no
      AND oh.supplier = s.supplier
      AND ol.item = im.item
      AND ol.item = isc.item
      AND oh.supplier = isc.supplier
      AND im.item=vat.item
      AND vat.vat_type='C'
      AND vat.ACTIVE_DATE = 
      (SELECT MAX(D_ED.ACTIVE_DATE) FROM vat_item D_ED WHERE vat.item = D_ED.item AND vat.vat_region = D_ED.vat_region AND D_ED.ACTIVE_DATE <= SYSDATE)
      AND ol.order_no NOT IN (SELECT DISTINCT order_no FROM ordloc ol WHERE ol.qty_cancelled > 0  AND ol.cancel_id <> 'ordautcl' AND NOT EXISTS (SELECT 1 FROM shipment sp WHERE sp.order_no = ol.order_no  AND sp.order_no IS NOT NULL ))
      AND not exists (select 1 from packitem_breakout t where t.pack_no=ol.item and t.comp_pack_no is not null )
      --AND NOT EXISTS (SELECT 'x' FROM alloc_header c WHERE oh.order_no = c.order_no)
      AND not EXISTS (SELECT 'x' FROM roqrequest roq WHERE roq.stock_cat = 2 AND roq.wh in (select wh from wh where physical_wh in (995045)) and oh.order_no = roq.order_transfer_no) --add by wenny
      AND ol.order_no=od.order_no(+)
    )
    order by 1 desc;
spool off;
exit;
