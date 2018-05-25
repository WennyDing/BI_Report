set termout off
set pagesize 0
set feedback off
set heading off
SET TRIMSPOOL ON
set linesize 2000
spool E:\BI_Report\work\cny_dis_management_sales_daily_rpt.csv
set verify off
SELECT col_name FROM (
SELECT '日期,店号,店名,区域,CNY店群管理,未税销售,销售达成,销售LFL,累计未税销售,累计销售达成,累计销售lfl,前毛,前毛达成,前毛lfl,累计前毛达成,累计前毛lfl' AS col_name ,0 as row_num FROM DUAL
UNION
select col_name,rownum as row_num from (
SELECT VALUE1.DT||','||
       VALUE1.SHOPID||','||
       SHOP.STORE_NAME||','||
       SHOP.DISTRICT_NAME||','||
       SHOP.STORE_DIRECTOR||','||
       VALUE1.SALE_EX_VALUE||','||
       ROUND((VALUE1.SALE_EX_VALUE/BSD.SEV), 2) * 100 || '%'||','||
       ROUND(VALUE1.SALE_EX_VALUE/JSV.SALE_EX_VALUE -1, 2) * 100 || '%'||','||
       ROUND(VALUE1.TOTAL_SALE, 2)||','||
       ROUND((VALUE1.TOTAL_SALE/BSD.TOTAL_SEV), 2) * 100 || '%'||','||
       ROUND(VALUE1.TOTAL_SALE/JSV.TOTAL_VALUE -1, 2)* 100 || '%'||','||
       ROUND(VALUE1.PROFIT, 2)||','||
       ROUND((VALUE1.PROFIT/BSD.BG), 2) * 100 || '%'||','||
       CASE WHEN JSV.PROFIT < 0 THEN ROUND((VALUE1.PROFIT - JSV.PROFIT )/ABS(JSV.PROFIT)-1,2)* 100 || '%'
            ELSE ROUND((VALUE1.PROFIT/JSV.PROFIT -1), 2) * 100 || '%' END ||','||
       ROUND((VALUE1.TOTAL_PROFIT/BSD.TOTAL_BG), 2) * 100 || '%'||','||
       CASE WHEN JSV.TOTAL_PROFIT < 0 THEN ROUND((VALUE1.TOTAL_PROFIT-JSV.TOTAL_PROFIT)/ABS(JSV.TOTAL_PROFIT) -1,2)* 100 || '%'
            ELSE ROUND((VALUE1.TOTAL_PROFIT/JSV.TOTAL_PROFIT -1), 2) * 100 || '%' END as col_name
  FROM (SELECT A.DAY_WID AS DT,
               B.SHOP_CODE AS SHOPID,
               ROUND(SUM(A.SALE_EX_VALUE), 4) AS SALE_EX_VALUE,
               SUM(SUM(A.SALE_EX_VALUE)) OVER(PARTITION BY B.SHOP_CODE ORDER BY A.DAY_WID) TOTAL_SALE,
               ROUND(SUM(A.SALE_PROMO_VALUE + A.SALE_EX_VALUE -
                         A.SALE_COST_VALUE),
                     4) AS PROFIT,
               SUM(SUM(A.SALE_PROMO_VALUE + A.SALE_EX_VALUE -
                       A.SALE_COST_VALUE)) OVER(PARTITION BY B.SHOP_CODE ORDER BY A.DAY_WID) TOTAL_PROFIT
          FROM CRV_JVBI_DM.TA_KPI_SALE_BY_DISC@CRVBI A,
               CRV_JVBI_DM.TD_SHOP@CRVBI             B,
               CRV_JVBI_DM.TD_GOODS@CRVBI            C,
               CRV_JVBI_DM.TD_GOODS_LV5@CRVBI        D
         WHERE A.SHOP_WID = B.ROW_WID
           AND B.BU_CODE = 31
           AND A.DAY_WID BETWEEN 20161230 AND TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
           AND A.GOODS_WID = C.ROW_WID
           AND C.CURRENT_CATEGORY_LV5_WID = D.ROW_WID
           AND D.CURRENT_CATEGORY_LV1_CODE IN (1, 2, 3, 4, 5, 6)
           AND A.YTD_SALE_QTY <> 0
         GROUP BY A.DAY_WID, B.SHOP_CODE) VALUE1,
       (SELECT TRAN_DATE AS DT,
               STORE AS SHOPID,
               SUM(DECODE(BUDGET_TYPE, 'SEV', BUDGET_DAY, 0)) SEV,
               SUM(SUM(DECODE(BUDGET_TYPE, 'SEV', BUDGET_DAY, 0))) OVER(PARTITION BY STORE ORDER BY TRAN_DATE) TOTAL_SEV,
               SUM(DECODE(BUDGET_TYPE, 'BG', BUDGET_DAY, 0)) BG,
               SUM(SUM(DECODE(BUDGET_TYPE, 'BG', BUDGET_DAY, 0))) OVER(PARTITION BY STORE ORDER BY TRAN_DATE) TOTAL_BG
          FROM BUDGET_STORE_DAY
         GROUP BY TRAN_DATE, STORE) BSD,
       (SELECT DT,
               LFL_DT,
               SHOPID,
               SALE_EX_VALUE,
               SUM(SALE_EX_VALUE) OVER(PARTITION BY SHOPID ORDER BY DT) TOTAL_VALUE,
               PROFIT,
               SUM(PROFIT) OVER(PARTITION BY SHOPID ORDER BY DT) TOTAL_PROFIT
          FROM JVHD_SHOP_VALUE
         WHERE LFL_DT >= TO_DATE('2016-12-30', 'YYYY-MM-DD')
         GROUP BY DT,LFL_DT, SHOPID, SALE_EX_VALUE,PROFIT) JSV,
       STORE_DIRECTOR_2016CNY SHOP
 WHERE VALUE1.DT = TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
   AND VALUE1.DT = TO_CHAR(BSD.DT, 'YYYYMMDD') --取预算
   AND VALUE1.SHOPID = BSD.SHOPID
   AND VALUE1.DT = TO_CHAR(JSV.LFL_DT, 'YYYYMMDD') --取LFL数据
   AND VALUE1.SHOPID = JSV.SHOPID
   AND VALUE1.SHOPID = SHOP.STORE ---取门店名称/区域名称/店群管理人
   ORDER BY nlssort(STORE_DIRECTOR,'NLS_SORT=SCHINESE_PINYIN_M') desc,ROUND((VALUE1.SALE_EX_VALUE/BSD.SEV), 2) DESC
)
)
order by row_num;
spool off;
exit;
