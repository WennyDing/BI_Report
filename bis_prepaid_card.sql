set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
begin
  -- Call the procedure
  Insert_Jvbi_Card_Prepaid;
end;
/
spool D:\BI_Report\work\预付卡礼品卡数据&1._&2..csv
set verify off
SELECT '售卡日期,BU,门店编码,门店名称,营运区域,营运大区,礼品卡售卡数量,礼品卡售卡金额,预付卡售卡数量,预付卡售卡金额,预付卡折扣金额' FROM dual;
select t2.day_date||','||
       t2.bu_name||','||
       t2.shop_code||','||
       t2.shop_name||','||
       t2.operation_area_name||','||
       t2.operation_big_area_name||','||
       t2.metric_191||','||
       t2.metric_187||','||
       t2.metric_190||','||
       t2.metric_183||','||
       t2.metric_185
  from JVBI_CARD_PREPAID t2
where day_date between to_char(sysdate-3,'yyyy-mm-dd') and  to_char(sysdate-1,'yyyy-mm-dd')
and t2.shop_code<>'204445'
order by t2.day_date,
         t2.shop_code;
spool off;
exit;