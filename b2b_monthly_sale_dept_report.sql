set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\b2b_monthly_sale_dept_report.&1..csv
set verify off
SELECT col_name FROM (
SELECT '�ŵ�,�ŵ�����,��Ⱥ,Ʒ��,����,��������,��Ʒ���,��Ʒ����,��Ʒ����,��Ʒ���۽��,��������,�·�,����,��Ʒ���۾���,��Ʒ˰��,��Ʒ�ɱ���,��Ʒ����,����ë��,��Ʒ����,����Ӧ�̱���,����Ӧ������'  AS col_name,0 FROM dual
UNION 
SELECT col_name,ROWNUM FROM (
SELECT 
�ŵ�||','||
�ŵ�����||','||
��Ⱥ||','||
Ʒ��||','||
����||','||
��������||','||
��Ʒ���||','||
��Ʒ����||','||
��Ʒ����||','||
��Ʒ���۽��||','||
TO_CHAR(��������,'yyyy-mm-dd')||','||
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
FROM b2b_monthly_sale_dept_vw
)ORDER BY 2);
spool off;
exit;