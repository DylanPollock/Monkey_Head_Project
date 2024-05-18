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

REM Initialize Kubernetes cluster (example using Minikube)
echo [****| Initializing Kubernetes cluster with Minikube |****]
minikube start
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Minikube initialization failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

REM Apply Kubernetes configuration
echo [****| Deploying to Kubernetes using gencore.yaml configuration |****]
kubectl apply -f C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\gencore.yaml
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Kubernetes deployment failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

REM Check the status of the deployment
echo [****| Checking deployment status |****]
kubectl rollout status deployment/gencore-deployment
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Deployment rollout failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Full Setup with Kubernetes completed successfully |****]
pause
exit /b