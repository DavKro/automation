mode con cols=40 lines=3
@echo off
color a
@echo off
:: BatchGotAdmin
:-------------------------------------
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Requesting elevated shell...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

@echo off
cls
mode con cols=96 lines=50
color a
echo ================================================================================================
echo elevated shell request successful...
echo elevated shell active...
echo prompting path request...
@echo:
echo ================================================================================================
echo (F)  = Full access
echo (M)  = Modify access
echo (RX) = Read and Execute access
echo (R)  = Read Only access
echo (W)  = Write Only access
@echo:
echo ================================================================================================
@echo:
:start
set /p input="enter directory path: "
icacls %input% | find /v "%input%"
goto start