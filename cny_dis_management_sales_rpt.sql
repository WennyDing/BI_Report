set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_dis_management_sales_rpt.csv
set verify off
	SELECT col_name FROM (
	SELECT '店号,店名,区域,CNY店群管理,DM1未税销售,销售达成,DM2未税销售,销售达成,DM3未税销售,销售达成,DM4未税销售,销售达成,DM5未税销售,销售达成,DM6未税销售,销售达成,全档未税销售,销售达成' AS col_name ,0 as row_num FROM DUAL
	UNION
	select col_name,rownum as row_num from (
	SELECT DM_S.SHOPID||','||
       SHOP.STORE_NAME||','||
       SHOP.DISTRICT_NAME||','||
       SHOP.STORE_DIRECTOR||','||
       ROUND(DM_S.DM1_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM1_SEV,0,0,DM_S.DM1_VALUE/DM_B.DM1_SEV*100),2)||'%'||','||
       ROUND(DM_S.DM2_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM2_SEV,0,0,DM_S.DM2_VALUE/DM_B.DM2_SEV*100),2)||'%'||','||
       ROUND(DM_S.DM3_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM3_SEV,0,0,DM_S.DM3_VALUE/DM_B.DM3_SEV*100),2)||'%'||','||
       ROUND(DM_S.DM4_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM4_SEV,0,0,DM_S.DM4_VALUE/DM_B.DM4_SEV*100),2)||'%'||','||
       ROUND(DM_S.DM5_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM5_SEV,0,0,DM_S.DM5_VALUE/DM_B.DM5_SEV*100),2)||'%'||','||
       ROUND(DM_S.DM6_VALUE,2)||','||
       ROUND(DECODE(DM_B.DM6_SEV,0,0,DM_S.DM6_VALUE/DM_B.DM6_SEV*100),2)||'%'||','||
       ROUND(SUM(DM_S.DM1_VALUE+DM_S.DM2_VALUE+DM_S.DM3_VALUE+DM_S.DM4_VALUE+DM_S.DM5_VALUE+DM_S.DM6_VALUE),2)||','||
       ROUND(SUM(DM_S.DM1_VALUE+DM_S.DM2_VALUE+DM_S.DM3_VALUE+DM_S.DM4_VALUE+DM_S.DM5_VALUE+DM_S.DM6_VALUE)/SUM(DM_B.DM1_SEV+DM_B.DM2_SEV+DM_B.DM3_SEV+DM_B.DM4_SEV+DM_B.DM5_SEV+DM_B.DM6_SEV)
       ,2)*100||'%' as col_name
 FROM (SELECT B.SHOP_CODE AS SHOPID,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20161231 AND 20170105 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM1_VALUE,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20170106 AND 20170117 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM2_VALUE,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20170118 AND 20170131 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM3_VALUE,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20170201 AND 20170214 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM4_VALUE,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20170215 AND 20170228 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM5_VALUE,
       ROUND(SUM(CASE WHEN A.DAY_WID BETWEEN 20170301 AND 20170308 THEN A.SALE_EX_VALUE ELSE 0 END),4) DM6_VALUE
   FROM CRV_JVBI_DM.TA_KPI_SALE_BY_DISC@CRVBI A,
               CRV_JVBI_DM.TD_SHOP@CRVBI             B,
               CRV_JVBI_DM.TD_GOODS@CRVBI            C,
               CRV_JVBI_DM.TD_GOODS_LV5@CRVBI        D
         WHERE A.SHOP_WID = B.ROW_WID
           AND B.BU_CODE = 31
           AND A.DAY_WID BETWEEN 20161231 AND 20170308
           AND A.GOODS_WID = C.ROW_WID
           AND C.CURRENT_CATEGORY_LV5_WID = D.ROW_WID
           AND D.CURRENT_CATEGORY_LV1_CODE IN (1, 2, 3, 4, 5, 6)
           AND A.SALE_QTY <> 0
         GROUP BY B.SHOP_CODE) DM_S,
         (SELECT STORE AS SHOPID,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2016-12-31', 'YYYY-MM-DD') AND
                    TO_DATE('2017-01-05', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM1_SEV,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2017-01-06', 'YYYY-MM-DD') AND
                    TO_DATE('2017-01-17', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM2_SEV,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2017-01-18', 'YYYY-MM-DD') AND
                    TO_DATE('2017-01-31', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM3_SEV,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2017-02-01', 'YYYY-MM-DD') AND
                    TO_DATE('2017-02-14', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM4_SEV,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2017-02-15', 'YYYY-MM-DD') AND
                    TO_DATE('2017-02-28', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM5_SEV,
         SUM(CASE
               WHEN TRAN_DATE BETWEEN TO_DATE('2017-03-01', 'YYYY-MM-DD') AND
                    TO_DATE('2016-03-08', 'YYYY-MM-DD') AND BUDGET_TYPE = 'SEV' THEN
                BUDGET_DAY
               ELSE
                0
             END) DM6_SEV
    FROM BUDGET_STORE_DAY
   WHERE TRAN_DATE BETWEEN TO_DATE('2016-12-31','YYYY-MM-DD') AND TO_DATE(TO_CHAR(SYSDATE - 1, 'YYYY-MM-DD'),'YYYY-MM-DD')
   GROUP BY STORE) DM_B,
   STORE_DIRECTOR_2016CNY SHOP
 WHERE DM_S.SHOPID = DM_B.SHOPID
   AND DM_S.SHOPID = SHOP.STORE
GROUP BY DM_S.SHOPID,
        SHOP.STORE_NAME,
       SHOP.DISTRICT_NAME,
       SHOP.STORE_DIRECTOR,
       DM_S.DM1_VALUE,
       DM_B.DM1_SEV,
       DM_S.DM2_VALUE,
       DM_B.DM2_SEV,
       DM_S.DM3_VALUE,
       DM_B.DM3_SEV,
       DM_S.DM4_VALUE,
       DM_B.DM4_SEV,
       DM_S.DM5_VALUE,
       DM_B.DM5_SEV,
       DM_S.DM6_VALUE,
       DM_B.DM6_SEV
    ORDER BY nlssort(shop.STORE_DIRECTOR,'NLS_SORT=SCHINESE_PINYIN_M') desc,ROUND(DECODE(DM_B.DM1_SEV,0,0,DM_S.DM1_VALUE/DM_B.DM1_SEV*100),2) desc
	))
	order by row_num;
spool off;
exit;
