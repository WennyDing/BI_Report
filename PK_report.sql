set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool D:\BI_Report\work\PK_report.&1..csv
set verify off
select '�ŵ�PK,���,����,ʱ���,����B2B�ۼƴ����'from dual ;
select �ŵ�PK||','||
���||','||
����||','||
ʱ���||','||
����B2B�ۼƴ����*100||'%' from vw_store_pk;
select ',,,,' from dual ;
select 'Ӫ����PK,���,Ӫ����,ʱ���,����B2B�ۼƴ����' from dual ;
select 
Ӫ����PK||','||
���||','||
�ŵ�PK||','||
ʱ���||','||
����B2B�ۼƴ���� from vw_dis_pk;
select ',,,,' from dual ;
select '����PK,���,����,ʱ���,��B2B�ۼƴ����' from dual;
select 
����PK||','||
���||','||
����||','||
ʱ���||','||
mg from (
select  '����PK' ����PK,'PK��1��' ���,'�Ӱ���Ʒ��' ����,ʱ���,round(sum(retail)/sum(budget_day),4)*100||'%'  mg from vw_div_pk where remark <>1 group by ʱ���
union
select  ����PK,���,����,ʱ���,mg*100||'%' mg from vw_div_pk  );
spool off;
exit;

