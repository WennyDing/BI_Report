set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_sales_red_black_log.csv
set verify off
SELECT col_name FROM (
SELECT 'date,row_count' AS col_name  FROM DUAL
UNION
select to_char(tran_date,'yyyy-mm-dd')||','||count(*) col_name from CNY_TRAN_DATA_2016
where tran_date=to_date(to_char(sysdate-1,'yyyy-mm-dd'),'yyyy-mm-dd')
group by tran_date
)
order by 1 desc;
spool off;
exit;
