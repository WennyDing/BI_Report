set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\store_coupons_transaction_tracking_report_summary.&1..csv
set verify off
SELECT 'SQL_dscp,coupon_type_no,coupon_type_name,tran_data,first_tran_date,end_tran_date,tran_cnt,tran_value,coupon_cnt,coupon_amt'
FROM dual
UNION
SELECT '"'||'tracking FOR THE coupon USING SUMMARY'||'","'
||cps.coupon_type_no||'","'
||cpt.NAME||'","'
||to_char(ssd.business_date,'yyyy-mm-dd')||'","'
||COUNT(DISTINCT sth.tran_seq_no)||'","'
||SUM(sth.VALUE)||'","'
||COUNT(DISTINCT cps.coupon_no)||'","'
||SUM(cps.coupon_amt)||'"'
FROM sa_tran_head sth
, sa_store_day ssd
, (
SELECT sth.tran_seq_no
, SUBSTR(stt.voucher_no,1,13) AS coupon_type_no
, stt.voucher_no AS coupon_no
, stt.tender_amt AS coupon_amt   
FROM sa_tran_head sth
, sa_store_day ssd
, sa_tran_tender stt  
WHERE 1=1
AND sth.store_day_seq_no = ssd.store_day_seq_no
AND sth.tran_seq_no = stt.tran_seq_no
AND ssd.business_date >  TRUNC(SYSDATE)-15
AND ssd.business_date <= TRUNC(SYSDATE)-1
/*(SELECT MAX(active_date) FROM COUPON_LIST WHERE active_yn = 'Y' AND module_index = '001')*/
AND stt.tender_type_group = 'VOUCH'
AND SUBSTR(stt.voucher_no,1,13) IN (SELECT coupon_type FROM COUPON_LIST@JVBI WHERE active_yn = 'Y' AND module_index = '001')
) cps
, jv_CouponsType cpt
WHERE 1=1
AND sth.store_day_seq_no = ssd.store_day_seq_no
AND sth.tran_seq_no = cps.tran_seq_no
AND cps.coupon_type_no = cpt.couponstype
and ssd.store not in (select store from jv_closed_store@JVBI)
AND ssd.business_date > TRUNC(SYSDATE)-15
GROUP BY  cps.coupon_type_no
,cpt.NAME 
,ssd.business_date
ORDER BY 1 DESC;
spool off;
exit;

