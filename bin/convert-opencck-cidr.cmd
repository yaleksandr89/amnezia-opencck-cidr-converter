@echo off
setlocal
chcp 65001 >nul

set "SCRIPT_PATH=%~dp0..\src\convert-opencck-cidr.ps1"
set "PAUSE_AT_END=0"
if "%~1"=="" set "PAUSE_AT_END=1"

where pwsh.exe >nul 2>nul
if %errorlevel%==0 (
    pwsh.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
    set "EXIT_CODE=%errorlevel%"
    goto :finish
)

where powershell.exe >nul 2>nul
if %errorlevel%==0 (
    powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
    set "EXIT_CODE=%errorlevel%"
    goto :finish
)

echo PowerShell was not found.
set "EXIT_CODE=127"

:finish
echo.
if "%PAUSE_AT_END%"=="1" pause
exit /b %EXIT_CODE%
