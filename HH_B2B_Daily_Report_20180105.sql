set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
set closep ','
begin
  create_b2b_daily_rpt_fix('2018-1-5');
end;
/
spool D:\BI_Report\work\B2B_Daily_Report.&1..csv
set verify off
select 'TRAN_DATE,DISTRICT,DISTRICT_NAME,STORE,STORE_NAME,POS_ID,LISTNO,POS_TOTAL,DEPT,DEPT_NAME,CLASS,SUBCLASS,ITEM,ITEM_DESC,SUPPLIER,SUP_NAME,SUPPLER_TEX_CODE,ITEM_UNIT_COST,ITEM_UNIT_RETAIL,ITEM_COUNT,ITEM_COST,ITEM_POS_SIV,ITEM_POS_SEV,ITEM_POS_MARGIN,UNIT_DIS_SEV,ITEM_POS_BG,COUP_ITEM_SIV,COUP_ITEM_SEV '  from dual;
select to_char(TRAN_DATE,'yyyy-mm-dd')||','||DISTRICT||','||DISTRICT_NAME||','||STORE||','||STORE_NAME||','||POS_ID||','||LISTNO||','||POS_TOTAL||','||DEPT||','||DEPT_NAME||','||CLASS||','||SUBCLASS||','||
ITEM||','||ITEM_DESC||','||SUPPLIER||','||SUP_NAME||','||SUPPLER_TEX_CODE||','||ITEM_UNIT_COST||','||ITEM_UNIT_RETAIL||','||ITEM_COUNT||','||ITEM_COST||','||
ITEM_POS_SIV||','||ITEM_POS_SEV||','||ITEM_POS_MARGIN||','||UNIT_DIS_SEV||','||ITEM_POS_BG||','||COUP_ITEM_SIV||','||COUP_ITEM_SEV from VW_B2B_DAILY_REPORT_0105
where tran_date=to_date('2018-1-5','yyyy-mm-dd');
spool off;
exit;