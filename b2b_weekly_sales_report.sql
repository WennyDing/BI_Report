set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
begin
  -- Call the procedure
  create_b2b_sales_weekly_rpt;
end;
/
spool D:\BI_Report\work\b2b_weekly_sales_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT '�ŵ�,�ŵ�����,��Ⱥ,Ʒ��,����,��������,��Ʒ���,��Ʒ����,��Ʒ����,��Ʒ���۽��,��������,�·�,����,��Ʒ���۾���,��Ʒ˰��,��Ʒ�ɱ���,��Ʒ����,����ë��,��Ʒ����,����Ӧ�̱���,����Ӧ������' AS col_name,0 FROM dual
UNION 
SELECT col_name,ROWNUM FROM (
SELECT �ŵ�||','||
       �ŵ�����||','||
       ��Ⱥ||','||
       Ʒ��||','||
       ����||','||
       ��������||','||
       ��Ʒ���||','||
       ��Ʒ����||','||
       ��Ʒ����||','||
       ��Ʒ���۽��||','||
       ��������||','||
       �·�||','||
       ����||','||
       ��Ʒ���۾���||','||
       ��Ʒ˰��||','||
       ��Ʒ�ɱ���||','||
       ��Ʒ����||','||
       ����ë��||','||
       ��Ʒ����||','||
       ����Ӧ�̱���||','||
       ����Ӧ������ AS col_name
FROM infbat.b2b_sales_weekly_rpt_vw
)ORDER BY 2);
spool off;
exit;