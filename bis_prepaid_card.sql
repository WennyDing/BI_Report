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
spool D:\BI_Report\work\Ԥ������Ʒ������&1._&2..csv
set verify off
SELECT '�ۿ�����,BU,�ŵ����,�ŵ�����,Ӫ������,Ӫ�˴���,��Ʒ���ۿ�����,��Ʒ���ۿ����,Ԥ�����ۿ�����,Ԥ�����ۿ����,Ԥ�����ۿ۽��' FROM dual;
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