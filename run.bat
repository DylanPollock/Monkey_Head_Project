@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET TEMP_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\temp
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-app
SET VOLUME_NAME=gencore-volume
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config

echo [****Welcome to GenCore Deployment Process****]

:start
:: Interactive Menu for User Actions
:menu
echo.
echo Select an action:
echo 1. Check Environment
echo 2. Build Docker Image
echo 3. Run Docker Container
echo 4. Update
echo 5. Clean up
echo 6. Reset Docker Environment
echo 7. Exit
set /p action=<con

if "%action%"=="1" goto check_environment
if "%action%"=="2" goto build
if "%action%"=="3" goto run
if "%action%"=="4" goto update
if "%action%"=="5" goto cleanup
if "%action%"=="6" goto reset
if "%action%"=="7" goto end
echo [****Invalid Selection. Please choose a valid option.****]
goto menu

:check_environment
call :check_python
call :check_docker
call :check_kubernetes
echo [****Environment Check Completed****]
pause
goto menu

:build
call :check_python
call :check_docker
echo [****Building Docker Image...****]
mkdir %TEMP_PATH%
:: Add download commands here for necessary files
:: Example: curl -o %TEMP_PATH%\file.zip http://example.com/file.zip
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > build.log
if %errorlevel% neq 0 (
    echo [****Build Error: See build.log for details.****]
    type build.log
    pause
    exit /b 1
) else (
    echo [****Docker Image Built Successfully****]
)
:: Clean up TEMP_PATH
del /Q %TEMP_PATH%\*
rmdir %TEMP_PATH%
pause
goto menu

:run
echo [****Running Docker Container...****]
docker run -d --name %CONTAINER_NAME% %IMAGE_NAME% > run.log
if %errorlevel% neq 0 (
    echo [****Error: Failed to run Docker container. Check run.log for details.****]
    type run.log
    pause
    exit /b 1
) else (
    echo [****Docker Container Running****]
)
pause
goto menu

:update
echo [****Updating...****]
:: Add logic for updating the application
:: Example: git pull or docker pull
echo [****Update Completed****]
pause
goto menu

:cleanup
echo [****Cleaning up...****]
:: Add logic for cleaning up resources
:: Example: docker stop %CONTAINER_NAME% & docker rm %CONTAINER_NAME%
echo [****Cleanup Completed****]
pause
goto menu

:reset
echo [****Resetting Docker Environment...****]
docker system prune -af --volumes
echo [****Docker Environment Reset Completed****]
pause
goto menu

:check_python
python --version 2>&1 | find "Python 3.11" > nul
if %errorlevel% neq 0 (
    echo [****Error: Python 3.11 is not installed on the host OS. Please install Python 3.11.****]
    pause
    exit /b 1
) else (
    echo [****Python 3.11 Detected****]
)
goto :eof

:check_docker
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Docker is not running. Please start Docker and try again.****]
    pause
    exit /b 1
) else (
    echo [****Docker is Running****]
)
goto :eof

:check_kubernetes
kubectl --kubeconfig=%KUBE_CONFIG_PATH% version --client > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Kubernetes is not set up correctly.****]
    pause
    exit /b 1
) else (
    echo [****Kubernetes Detected****]
)
goto :eof

:end
echo [****Exiting GenCore Deployment Process.****]
pause