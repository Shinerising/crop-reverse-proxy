@echo off

REM 清空hosts文件
echo. > %windir%\System32\drivers\etc\hosts

REM 修改hosts文件
echo 127.0.0.1 localhost >> %windir%\System32\drivers\etc\hosts
echo 192.168.2.111 crop.crscd.net >> %windir%\System32\drivers\etc\hosts
echo 192.168.2.111 tw-dars.crop.crscd.net >> %windir%\System32\drivers\etc\hosts

echo succeed!
pause