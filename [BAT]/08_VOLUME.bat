@echo off
cls
echo [****| Creating Volume |****]

REM Create a new Docker volume named gencore-volume
docker volume create gencore-volume

REM Check if the volume was created successfully
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Volume creation failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Volume created successfully |****]
pause
exit /b
