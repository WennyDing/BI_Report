set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
begin
  -- Call the procedure
  create_store_fresh_rpt;
end;
/
spool D:\BI_Report\work\门店生鲜整改订单.&1..csv
set verify off
SELECT '编号,说明,类型,审批状态,订单日期,供应商,物料,行说明,金额,订单总金额,采购员,审批时间,审批人' from dual;
SELECT pha.segment1||','||
pha.comments||','||
DECODE(pha.type_lookup_code,'STANDARD','标准采购订单','BLANKET','一揽子协议')||','||
DECODE(NVL(pha.authorization_status,'INCOMPLETE'),'APPROVED','批准','IN PROCESS','处理中','INCOMPLETE','未完成','REJECTED','已拒绝','PRE-APPROVED','预审批','REQUIRES REAPPROVAL','要求重新审批')||','||
to_char(pha.creation_date,'yyyy-mm-dd')||','||
pv.vendor_name||','||
msib.segment1||','||
pla.item_description||','||
ROUND(pla.unit_price * pla.quantity,2.1)||','||
SUM(ROUND(pla.unit_price * pla.quantity,2.1)) OVER (PARTITION BY pha.segment1)||','||
fu.description||','||
to_char(T1.action_date,'yyyy-mm-dd')||','||
fu2.description
FROM po_headers_all pha
INNER JOIN fnd_user fu ON pha.created_by = fu.user_id AND fu.end_date IS NULL
INNER JOIN AP_SUPPLIERS pv ON pha.vendor_id = pv.vendor_id
INNER JOIN po_lines_all pla ON pha.po_header_id = pla.po_header_id
INNER JOIN (SELECT  pah.*,ROW_NUMBER() OVER(PARTITION BY pah.object_id ORDER BY pah.sequence_num DESC) rn
FROM PO_ACTION_HISTORY pah) T1 ON pha.po_header_id = T1.object_id
INNER JOIN fnd_user fu2 ON T1.employee_id = fu2.employee_id AND fu2.end_date IS NULL
INNER JOIN MTL_SYSTEM_ITEMS_b msib ON msib.inventory_item_id = pla.item_id AND msib.organization_id = pla.org_id
WHERE pha.created_by = 12236
AND pha.creation_date >= TO_DATE('20170901','yyyy-mm-dd')
AND pha.vendor_id IN(1047,44011,1174,1043)
AND T1.rn = 1
ORDER BY pha.creation_date ASC;
spool off;
exit;

