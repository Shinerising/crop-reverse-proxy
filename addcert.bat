@echo off

REM 安装证书到Windows系统根证书
certutil -addstore -user root ca.pem

echo succeed!
pause