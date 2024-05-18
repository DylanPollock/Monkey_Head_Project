@echo off
cls
echo [****| Setting up 'Mini' Environment |****]

REM Example command to start a minimal Docker container
docker run -d --name gencore-mini -p 8080:80 gencore-image

REM Check if the mini setup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: 'Mini' Environment setup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| 'Mini' Environment Setup completed successfully |****]
pause
exit /b