SET TERMOUT OFF
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET LINESIZE 2000
SPOOL E:\BI_REPORT\WORK\CNY中类层级销售报表.&1..csv
SET VERIFY OFF

SELECT '日期_今年,日期_去年,运营区域,门店编码,门店名称,部门名称,部门编码,品类名称,品类编码,大类名称,大类编码,中类名称,中类编码,销售金额,去年同店销售金额,销售净额,去年同店销售净额,销售净额同比,销售数量,去年同店销售数量,销售数量同比,毛利,去年同店毛利,毛利同比,来客数,去年同店来客数,来客数同比,客单价,去年客单价,客单价同比'
FROM DUAL
UNION
SELECT DISTINCT  '"'||
       TO_CHAR(CCV.DT,'YYYY-MM-DD')||'","'||
       TO_CHAR(JC1.DT,'YYYY-MM-DD')||'","'||
       S.DISTRICT_NAME||'","'||
       CCV.SHOPID||'","'||
       S.STORE_NAME||'","'||
       TG.CURRENT_CATEGORY_LV1_NAME||'","'||
       CCV.DIV||'","'||
       TG.CURRENT_CATEGORY_LV2_NAME||'","'||
       CCV.GROUPNO||'","'||
       TG.CURRENT_CATEGORY_LV3_NAME||'","'||
       CCV.DEPT||'","'|| 
       TG.CURRENT_CATEGORY_LV4_NAME||'","'||
       CCV.CLASS||'","'||
       CCV.SALE_IN_VALUE||'","'||
       CCV.LFL_SALE_IN_VALUE||'","'|| 
       CCV.SALE_EX_VALUE||'","'||
       CCV.LFL_SALE_EX_VALUE||'","'||
       ROUND(DECODE(CCV.LFL_SALE_EX_VALUE,0,0,CCV.SALE_EX_VALUE/CCV.LFL_SALE_EX_VALUE -1),2)*100||'%'||'","'||
       CCV.SALE_QTY||'","'||
       CCV.LFL_SALE_QTY||'","'||
       ROUND(DECODE(CCV.LFL_SALE_QTY,0,0,CCV.SALE_QTY/CCV.LFL_SALE_QTY -1),2)*100||'%'||'","'||
       CCV.PROFIT||'","'||
       CCV.LFL_PROFIT||'","'||
       ROUND(DECODE(CCV.LFL_PROFIT,0,0,CCV.PROFIT/CCV.LFL_PROFIT -1),2)*100||'%'||'","'||
       JC.CLASS_COUNT||'","'||
       JC1.CLASS_COUNT||'","'||
       ROUND(DECODE(JC1.CLASS_COUNT,0,0,JC.CLASS_COUNT/JC1.CLASS_COUNT -1),2)*100||'%'||'","'||
       ROUND(JC.CLASS_VALUE/JC.CLASS_COUNT,2)||'","'||
       ROUND(JC1.CLASS_VALUE/JC1.CLASS_COUNT,2)||'","'||
       ROUND(DECODE(JC1.CLASS_VALUE/JC1.CLASS_COUNT,0,0,(JC.CLASS_VALUE/JC.CLASS_COUNT)/(JC1.CLASS_VALUE/JC1.CLASS_COUNT)-1),2)*100||'%'||'"'
  FROM CNY_CLASS_VALUE_2017           CCV,
       JVSALE_CLASS_2017              JC,
       JVSALE_CLASS_2016              JC1,
       TD_GOODS_LV5                   TG,
       STORE_DIRECTOR_2016CNY          S
 WHERE CCV.DT = JC.DT
   AND CCV.SHOPID = JC.SHOPID
   AND CCV.CLASS = JC.CLASS
   AND CCV.DT = JC1.LFL_DT
   AND CCV.SHOPID = JC1.SHOPID
   AND CCV.CLASS = JC1.CLASS
   AND CCV.CLASS = TG.CURRENT_CATEGORY_LV4_CODE
   AND CCV.SHOPID = S.STORE
   AND CCV.DT = TRUNC(SYSDATE) - 1
   ORDER BY 1 DESC;
SPOOL OFF;
EXIT;
