@echo off
cls
echo [****| Setting up SubOS |****]

REM Example command to start a SubOS setup
echo [****| Configuring SubOS environment... |****]

REM Add SubOS setup commands here

REM Check if the SubOS setup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: SubOS setup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| SubOS Setup completed successfully |****]
pause
exit /b