@echo off
cls
echo [****| Performing Full Setup with Kubernetes |****]

REM Call setup script to prepare the environment
call "%~dp0setup.bat"
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Setup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

REM Deploy to Kubernetes using the gencore.yaml configuration
kubectl apply -f C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\gencore.yaml

REM Check if the Kubernetes deployment was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Kubernetes deployment failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Full Setup with Kubernetes completed successfully |****]
pause
exit /b