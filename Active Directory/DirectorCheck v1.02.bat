@echo off
cls
color b
echo DIRECTORCHECK v1.02 by patrick
:start
@echo:
echo Reminder: Usernames are either firstname.lastname or lastnamefirstinitial
@echo:
set /p input="Enter AD Username to lookup: "
dsquery user -samid %input% |dsget user -memberof |dsget group -samid |findstr /v /a:e "samid"|find /v "dsget%"
goto start