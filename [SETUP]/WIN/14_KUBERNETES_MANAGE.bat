@echo off
cls
echo [****| Kubernetes Management |****]

:start
:menu
cls
echo [****|     1. Initialize Kubernetes Cluster |****]
echo [****|     2. Deploy Application            |****]
echo [****|     3. Check Deployment Status       |****]
echo [****|     4. Scale Deployment              |****]
echo [****|     5. Delete Deployment             |****]
echo [****|     [E]xit to Main Menu              |****]
echo.

set /p action="Please select an option (1-5, E/e to exit): "
echo.

if "%action%"=="1" goto init_cluster
if "%action%"=="2" goto deploy_app
if "%action%"=="3" goto check_status
if "%action%"=="4" goto scale_deployment
if "%action%"=="5" goto delete_deployment
if /i "%action%"=="E" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:init_cluster
echo [****| Initializing Kubernetes Cluster |****]
minikube start
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Minikube initialization failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)
echo [****| Kubernetes Cluster initialized successfully |****]
pause
goto menu

:deploy_app
echo [****| Deploying Application |****]
kubectl apply -f C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\gencore.yaml
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Kubernetes deployment failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)
echo [****| Application deployed successfully |****]
pause
goto menu

:check_status
echo [****| Checking Deployment Status |****]
kubectl rollout status deployment/gencore-deployment
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Deployment rollout failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)
echo [****| Deployment status checked successfully |****]
pause
goto menu

:scale_deployment
echo [****| Scaling Deployment |****]
set /p replicas="Enter the number of replicas: "
kubectl scale deployment gencore-deployment --replicas=%replicas%
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Scaling deployment failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)
echo [****| Deployment scaled successfully |****]
pause
goto menu

:delete_deployment
echo [****| Deleting Deployment |****]
kubectl delete deployment gencore-deployment
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Deleting deployment failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)
echo [****| Deployment deleted successfully |****]
pause
goto menu

:end
echo [****| Exiting Kubernetes Management. |****]
pause
exit /b