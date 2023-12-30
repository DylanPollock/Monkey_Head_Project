@echo off
setlocal enabledelayedexpansion
cls
color 0A
echo [****|     GenCore Kubernetes Deployment Tool    |****]
echo.

:: Check if gencore.yaml file exists
if not exist "\MonkeyHeadProject\gencore.yaml" (
    echo [****| Error: gencore.yaml file not found in \MonkeyHeadProject. |****]
    pause
    exit /b 1
)

:: Check if Kubernetes is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo [****| Error: Kubernetes client is not installed or not configured correctly. |****]
    pause
    exit /b 1
)

:: Attempt to deploy GenCore using Kubernetes
echo [****| Applying gencore.yaml configuration... |****]
kubectl apply -f \MonkeyHeadProject\gencore.yaml
if %errorlevel% neq 0 (
    echo [****| Deployment failed. Check Kubernetes configuration and gencore.yaml. |****]
    pause
    exit /b 1
) else (
    echo [****| Deployment in progress... |****]
    :: Optionally, check the status of the deployment
    echo [****| Checking deployment status... |****]
    kubectl rollout status deployment/gencore
    if %errorlevel% neq 0 (
        echo [****| Deployment status check failed. Please verify manually. |****]
    ) else (
        echo [****| Deployment successful. GenCore system is now running. |****]
    )
    pause
)

exit /b 0
