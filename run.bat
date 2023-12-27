@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-app
SET VOLUME_NAME=gencore-volume
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config

echo [****Starting GenCore Deployment Process****]

:: Checking system prerequisites
echo [****Checking System Prerequisites...****]
python --version 2>&1 | find "Python 3.11" > nul
if %errorlevel% neq 0 (
    echo [****Error: Python 3.11 is not installed on the host OS. Please install Python 3.11.****]
    exit /b 1
) else (
    echo [****Python 3.11 Detected****]
)

:: Checking if Docker is running
echo [****Verifying Docker Status...****]
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Docker is not running. Please start Docker and try again.****]
    exit /b 1
) else (
    echo [****Docker is Running****]
)

:: Checking if Kubernetes is set up
echo [****Checking if Kubernetes is set up...****]
kubectl --kubeconfig=%KUBE_CONFIG_PATH% version --client > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Kubernetes is not set up correctly.****]
    exit /b 1
) else (
    echo [****Kubernetes Detected****]
)

:: Offering option to clean up Docker environment
echo Would you like to clean up Docker environment before proceeding? (Y/N):
set /p cleanup=<con
if /I "%cleanup%"=="Y" (
    echo [****Cleaning up Docker Environment...****]
    docker system prune -af
)

:: Interactive Menu for User Actions
:menu
echo.
echo Select an action:
echo 1. Build and Run
echo 2. Update
echo 3. Clean up
echo 4. Exit
set /p action=<con

if "%action%"=="1" goto build_run
if "%action%"=="2" goto update
if "%action%"=="3" goto cleanup
if "%action%"=="4" exit /b 0
echo [****Invalid Selection. Please choose a valid option.****]
goto menu

:build_run
echo [****Building Docker Image: %IMAGE_NAME%...****]
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > build.log
if %errorlevel% neq 0 (
    echo [****Build Error: See build.log for details.****]
    type build.log
    exit /b 1
) else (
    echo [****Docker Image Built Successfully****]
)

echo [****Applying Kubernetes Configurations...****]
kubectl --kubeconfig=%KUBE_CONFIG_PATH% apply -f %PROJECT_PATH%\gencore-deployment.yaml > kube.log
if %errorlevel% neq 0 (
    echo [****Error: Failed to apply Kubernetes configurations. Check kube.log for details.****]
    type kube.log
    exit /b 1
) else (
    echo [****Kubernetes Configurations Applied Successfully****]
)

echo [****Verifying Kubernetes Deployment...****]
kubectl --kubeconfig=%KUBE_CONFIG_PATH% get deployments
if %errorlevel% neq 0 (
    echo [****Error: Kubernetes deployment verification failed.****]
    exit /b 1
) else (
    echo [****Deployment Verified Successfully****]
)
goto end

:update
echo [****Updating...****]
:: Update logic here (commented out for now)
:: echo [****No Update Logic Defined****]
goto end

:cleanup
echo [****Cleaning up...****]
:: Cleanup logic here (commented out for now)
:: echo [****No Cleanup Logic Defined****]
goto end

:end
echo [****All operations completed successfully.****]
pause