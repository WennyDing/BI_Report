@echo off
rem 计算指定天数之前的日期
set DaysAgo=18
rem 假设系统日期的格式为yyyy-mm-dd
call :DateToDays %date:~0,4% %date:~5,2% %date:~8,2% PassDays
set /a PassDays-=%DaysAgo%
call :DaysToDate %PassDays% DstYear DstMonth DstDay
set DstDate=%DstYear%%DstMonth%%DstDay%
echo Paramater Date is %DstDate%
echo dc_jvrdc.bat is running...

set mins=%TIME:~3,2%
Set h=%TIME:~0,2%
If %h% leq 9 (Set h=0%h:~1,1%) 
set dstHourMin=%h%%mins%
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dc_jvrdc.sql %DstYear%%DstMonth%
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dc_ndc.sql %DstYear%%DstMonth%
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 1 1
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 2 2
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 3 3
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 4 4
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 5 5
sqlplus -s infbat/infbat@JVRMSDBPRD @D:\BI_Report\sql\dsd.sql %DstYear%%DstMonth% 6 6
copy D:\BI_Report\work\DC*.csv D:\
copy D:\BI_Report\work\DSD*.csv D:\
C:
cd C:\Program Files\WinRAR
RAR a D:\BI_Report\work\DC_JVRDC_DSD_%DstYear%%DstMonth%.rar D:\DC*.csv D:\DSD*.csv
del /s/q D:\BI_Report\work\DC*.csv
del /s/q D:\BI_Report\work\DSD*.csv
del /s/q D:\DSD*.csv
del /s/q D:\DC*.csv

CScript "D:\BI_Report\scripts\WrapperScript.VBS" 10.254.40.204 0 "MAIL_DSD_JVRDC_RPT"
move D:\BI_Report\work\DC_JVRDC_DSD_*.rar D:\BI_Report\bak
exit

:DateToDays %yy% %mm% %dd% days
setlocal ENABLEEXTENSIONS
set yy=%1&set mm=%2&set dd=%3
if 1%yy% LSS 200 if 1%yy% LSS 170 (set yy=20%yy%) else (set yy=19%yy%)
set /a dd=100%dd%%%100,mm=100%mm%%%100
set /a z=14-mm,z/=12,y=yy+4800-z,m=mm+12*z-3,j=153*m+2
set /a j=j/5+dd+y*365+y/4-y/100+y/400-2472633
endlocal&set %4=%j%&goto :EOF

:DaysToDate %days% yy mm dd
setlocal ENABLEEXTENSIONS
set /a a=%1+2472632,b=4*a+3,b/=146097,c=-b*146097,c/=4,c+=a
set /a d=4*c+3,d/=1461,e=-1461*d,e/=4,e+=c,m=5*e+2,m/=153,dd=153*m+2,dd/=5
set /a dd=-dd+e+1,mm=-m/10,mm*=12,mm+=m+3,yy=b*100+d-4800+m/10
(if %mm% LSS 10 set mm=0%mm%)&(if %dd% LSS 10 set dd=0%dd%)
endlocal&set %2=%yy%&set %3=%mm%&set %4=%dd%&
goto :EOF