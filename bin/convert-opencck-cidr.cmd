@echo off
setlocal DisableDelayedExpansion
chcp 65001 >nul

set "SCRIPT_PATH=%~dp0..\src\convert-opencck-cidr.ps1"
set "PAUSE_AT_END=0"
set "ERRORLEVEL="
if "%~1"=="" set "PAUSE_AT_END=1"

where pwsh.exe >nul 2>nul
if not errorlevel 1 goto :run_pwsh

where powershell.exe >nul 2>nul
if not errorlevel 1 goto :run_powershell

echo PowerShell was not found.
set "EXIT_CODE=127"
goto :finish

:run_pwsh
pwsh.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
set "EXIT_CODE=%errorlevel%"
goto :finish

:run_powershell
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
set "EXIT_CODE=%errorlevel%"

:finish
echo.
if "%PAUSE_AT_END%"=="1" pause
exit /b %EXIT_CODE%
