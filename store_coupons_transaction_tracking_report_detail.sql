SET TERMOUT OFF
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET LINESIZE 2000
SPOOL D:\BI_REPORT\WORK\store_coupons_transaction_tracking_report_detail.&1..csv
SET VERIFY OFF

SELECT 'SQL_DSCP,BUSINESS_DATE,CUST_ID,REGISTER,TRAN_NO,CASHIER,STORE,STORE_NAME,TRAN_VALUE,COUPON_TYPE_NO,COUPON_TYPE_NAME,COUPON_NO,COUPON_AMT,TRAN_DATETIME'
FROM DUAL
UNION
SELECT '"'||'TRACKING FOR THE COUPON USING DETAIL'||'","'||
        to_char(SSD.BUSINESS_DATE,'yyyy-mm-dd')|| '","' ||
        --STH.TRAN_SEQ_NO||'","'||
        SC.CUST_ID || '","' || --会员卡号 UPDATE 20160908
        STH.REGISTER || '","' || --POS机号  UPDATE 20160908
        STH.TRAN_NO || '","' || --流水号   UPDATE20160908
        STH.CASHIER || '","' || --收银员ID UPDATE20160908
        STH.STORE || '","' ||
        STR.STORE_NAME || '","' || 
        STH.VALUE || '","' ||
        CPS.COUPON_TYPE_NO || '","' ||
        CPT.NAME || '","' || 
        CPS.COUPON_NO ||'","' || 
        CPS.COUPON_AMT || '","' ||
        to_char(STH.TRAN_DATETIME,'yyyy-mm-dd HH:MM:SS') || '"'
  FROM SA_TRAN_HEAD STH,
       SA_STORE_DAY SSD,
       (SELECT STH.TRAN_SEQ_NO,
               SUBSTR(STT.VOUCHER_NO, 1, 13) AS COUPON_TYPE_NO,
               STT.VOUCHER_NO AS COUPON_NO,
               STT.TENDER_AMT AS COUPON_AMT
          FROM SA_TRAN_HEAD   STH,
               SA_STORE_DAY   SSD,
               SA_TRAN_TENDER STT
         WHERE 1 = 1
           AND STH.STORE_DAY_SEQ_NO = SSD.STORE_DAY_SEQ_NO
           AND STH.TRAN_SEQ_NO = STT.TRAN_SEQ_NO
           AND SSD.BUSINESS_DATE > TRUNC(SYSDATE) - 11 ---UPDATE20160908
           AND SSD.BUSINESS_DATE <= TRUNC(SYSDATE)-1     ---UPDATE20160908
             /*  (SELECT MAX(ACTIVE_DATE)
                  FROM COUPON_LIST
                 WHERE ACTIVE_YN = 'Y'
                   AND MODULE_INDEX = '001')*/
           AND STT.TENDER_TYPE_GROUP = 'VOUCH'
           AND SUBSTR(STT.VOUCHER_NO, 1, 13) IN
               (SELECT COUPON_TYPE
                  FROM COUPON_LIST@JVBI
                 WHERE ACTIVE_YN = 'Y'
                   AND MODULE_INDEX = '001')) CPS,
       JV_COUPONSTYPE CPT,
       STORE STR,
       SA_CUSTOMER SC --UPDATE20160908
 WHERE 1 = 1
   AND STH.STORE_DAY_SEQ_NO = SSD.STORE_DAY_SEQ_NO
   AND STH.TRAN_SEQ_NO = CPS.TRAN_SEQ_NO
   AND CPS.COUPON_TYPE_NO = CPT.COUPONSTYPE
   AND STH.STORE = STR.STORE
   and STR.STORE not in (select store from jv_closed_store@jvbi)
   AND SSD.BUSINESS_DATE > TRUNC(SYSDATE) - 11 --UPDATE20160908
   AND STH.TRAN_SEQ_NO = SC.TRAN_SEQ_NO(+)--UPDATE20160908
 ORDER BY 1 DESC;
spool off;
exit;