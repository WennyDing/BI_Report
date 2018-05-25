set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\important_sale_tracking_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT 'location,store_name,item,item_desc,standard_uom,start_soh,start_sit,'||
'd0_soh,d0_sit,d0_sale_unit,d0_sale_value,'||
'd1_soh,d1_sit,d1_sale_unit,d1_sale_value,'||
'd2_soh,d2_sit,d2_sale_unit,d2_sale_value,'||
'd3_soh,d3_sit,d3_sale_unit,d3_sale_value,'||
'd4_soh,d4_sit,d4_sale_unit,d4_sale_value,'||
'd5_soh,d5_sit,d5_sale_unit,d5_sale_value,'||
'd6_soh,d6_sit,d6_sale_unit,d6_sale_value,'||
'd7_soh,d7_sit,d7_sale_unit,d7_sale_value' AS col_name,0
FROM dual
UNION
SELECT col_name,ROWNUM FROM (
select aaa.location||','||
       str.store_name||','||
     aaa.item||','||
     itm.item_desc||','||
     itm.standard_uom||','||
     sum(decode(aaa.date_number,-1,soh_unit))||','||
     sum(decode(aaa.date_number,-1,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,0,soh_unit))||','||
     sum(decode(aaa.date_number,0,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,0,sale_unit))||','||
     sum(decode(aaa.date_number,0,sale_value))||','||
     sum(decode(aaa.date_number,1,soh_unit))||','||
     sum(decode(aaa.date_number,1,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,1,sale_unit))||','||
     sum(decode(aaa.date_number,1,sale_value))||','||
     sum(decode(aaa.date_number,2,soh_unit))||','||
     sum(decode(aaa.date_number,2,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,2,sale_unit))||','||
     sum(decode(aaa.date_number,2,sale_value))||','||
     sum(decode(aaa.date_number,3,soh_unit))||','||
     sum(decode(aaa.date_number,3,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,3,sale_unit))||','||
     sum(decode(aaa.date_number,3,sale_value))||','||
     sum(decode(aaa.date_number,4,soh_unit))||','||
     sum(decode(aaa.date_number,4,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,4,sale_unit))||','||
     sum(decode(aaa.date_number,4,sale_value))||','||
     sum(decode(aaa.date_number,5,soh_unit))||','||
     sum(decode(aaa.date_number,5,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,5,sale_unit))||','||
     sum(decode(aaa.date_number,5,sale_value))||','||
     sum(decode(aaa.date_number,6,soh_unit))||','||
     sum(decode(aaa.date_number,6,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,6,sale_unit))||','||
     sum(decode(aaa.date_number,6,sale_value))||','||
     sum(decode(aaa.date_number,7,soh_unit))||','||
     sum(decode(aaa.date_number,7,round(sit_unit,3)))||','||
     sum(decode(aaa.date_number,7,sale_unit))||','||
     sum(decode(aaa.date_number,7,sale_value)) AS col_name
  from event_trace_item_data aaa
     , store str 
     , item_master itm 
 where 1=1
   and aaa.location = str.store
   and aaa.item = itm.item
   and str.store not in (select store from jv_closed_store)
   and aaa.tran_date >= to_date(sysdate-1)
group by aaa.location
     , str.store_name
     , aaa.item
     , itm.item_desc 
     , itm.standard_uom  
order by aaa.location
     , aaa.item
) ORDER BY 2);
spool off;
exit;