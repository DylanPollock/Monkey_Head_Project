@echo off
cls
echo [****| Setting up NanoOS |****]

REM Example command to start a NanoOS setup
echo [****| Configuring NanoOS environment... |****]

REM Add NanoOS setup commands here

REM Check if the NanoOS setup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: NanoOS setup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| NanoOS Setup completed successfully |****]
pause
exit /b