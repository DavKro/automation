@echo off
cls
mode con cols=80 lines=30
color 20
echo Map a network drive
:start
@echo:
@echo:
set /p path="Enter network path: "
net use /p:yes
net use %driveletter%: %path% | find /v "successfull"
goto start