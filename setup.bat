@echo off
echo [**** Starting Full Automatic Setup of GenCore Project ****]

:: Define environment variables
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config

:: Step 1: Check and Install Prerequisites (Docker, Kubernetes, etc.)
echo [**** Step 1: Checking and Installing Prerequisites ****]
call :check_prerequisites

:: Step 2: Create Docker Volume
echo [**** Step 2: Creating Docker Volume ****]
docker volume create %VOLUME_NAME%

:: Step 3: Build Docker Image
echo [**** Step 3: Building Docker Image ****]
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Image Build Failed ****]
    pause
    exit /b
)

:: Step 4: Run Docker Container
echo [**** Step 4: Running Docker Container ****]
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %IMAGE_NAME%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Container Run Failed ****]
    pause
    exit /b
)

echo [**** Full Automatic Setup Completed Successfully ****]
pause
exit /b

:check_prerequisites
:: Check Docker Installation
docker --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Docker is not installed. Please install Docker. ****]
    pause
    exit /b
)

:: Check Docker Running Status
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Docker is not running. Please start Docker. ****]
    pause
    exit /b
)

:: Check Kubernetes Installation
kubectl version --client > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Kubernetes is not installed. Please install Kubernetes. ****]
    pause
    exit /b
)
goto :eof
