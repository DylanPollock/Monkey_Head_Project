@echo off
cls
echo [****| Performing Full Setup |****]

REM Call other scripts to perform the full setup
call "%~dp0build.bat"
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

call "%~dp0container.bat"
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

REM Add any additional setup commands here

echo [****| Full Setup completed successfully |****]
pause
exit /b