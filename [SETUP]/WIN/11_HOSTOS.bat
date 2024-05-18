@echo off
cls
echo [****| Setting up HostOS |****]

REM Example command to start a HostOS setup
echo [****| Configuring HostOS environment... |****]

REM Add HostOS setup commands here

REM Check if the HostOS setup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: HostOS setup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| HostOS Setup completed successfully |****]
pause
exit /b