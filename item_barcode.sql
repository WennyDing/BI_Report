set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\item_barcode.csv
set verify off
SELECT 'item,barcode' FROM DUAL;
select aa.item_parent||','||aa.item from
(select * from item_master
where item_number_type!='TPNB') aa,
(select * from item_master
where item_number_type='TPNB') bb
where aa.item_parent=bb.item;
spool off;
exit;
