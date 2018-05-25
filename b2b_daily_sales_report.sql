set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\b2b_daily_sales_report.&1..csv
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
FROM B2B_SALES_DAILY_RPT_VW
)ORDER BY 2);
spool off;
exit;