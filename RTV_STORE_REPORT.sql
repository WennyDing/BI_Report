set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\rtv_store_report.csv
set verify off
select 'store RTV' as RTV_type
     , rh.store
     , str.store_name
     , rh.ext_ref_no
     , rh.comment_desc
     , rh.completed_date
     , rh.supplier
     , sups.sup_name
     , rd.item
     , im.item_desc
     , rd.qty_returned
  from rtv_head@JVRMS rh, rtv_detail@JVRMS rd, item_master@JVRMS im, sups, store@JVRMS str
 where rh.rtv_order_no = rd.rtv_order_no
   and im.item = rd.item
   and sups.supplier = rh.supplier
   AND rh.STATUS_IND = 15
   and rh.completed_date >= trunc(add_months(sysdate,-3),'MM') --to_date('20170101', 'YYYYMMDD')
   and rh.completed_date <  trunc(sysdate,'MM')                --to_date('20170401', 'YYYYMMDD')
   and rh.store <> '-1'
   and rh.store = str.store
   and substr(str.district,1,2) = '31'
union all
select 'DC RTV' as RTV_type
     , rh.wh
     , wh.wh_name
     , rh.ext_ref_no
     , rh.comment_desc
     , rh.completed_date
     , rh.supplier
     , sups.sup_name
     , rd.item
     , im.item_desc
     , rd.qty_returned
  from rtv_head@JVRMS rh, rtv_detail@JVRMS rd, item_master@JVRMS im, sups@JVRMS, wh@JVRMS
 where rh.rtv_order_no = rd.rtv_order_no
   and im.item = rd.item
   and sups.supplier = rh.supplier
   AND rh.STATUS_IND = 15
   and rh.completed_date >= trunc(add_months(sysdate,-3),'MM') --to_date('20170101', 'YYYYMMDD')
   and rh.completed_date <  trunc(sysdate,'MM')                --to_date('20170401', 'YYYYMMDD')
   and rh.WH <> '-1'
   and rh.WH = wh.wh
   and wh.physical_wh in (995063, 995061);
spool off;
exit;