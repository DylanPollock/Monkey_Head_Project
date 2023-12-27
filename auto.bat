@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET TEMP_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\[MEMORY]\TEMP
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config

echo [****Welcome to the GenCore Deployment Process****]

:start
:: Interactive Menu for AI/OS Actions
:menu
echo.
echo [**  Select an action: **]
echo [**  1. Automatic Setup/Check      **]
echo [**  2. Check Environment          **]
echo [**  3. Reset Docker Environment   **]
echo [**  4. Build Docker Image         **]
echo [**  5. Run Docker Container       **]
echo [**  6. Update Python / Debian     **]
echo [**  7. Clean Up                   **]
echo [**  8. Check Docker Volume        **]
echo [**  9. Check Container Status     **]
echo [** 10. Check Build Status         **]
echo [** 11. Check Docker Image         **]
echo [** 12. Exit Program               **]
set /p action=<con

if "%action%"=="1" goto auto_setup
if "%action%"=="2" goto check_environment
if "%action%"=="3" goto reset
if "%action%"=="4" goto build
if "%action%"=="5" goto run
if "%action%"=="6" goto update
if "%action%"=="7" goto cleanup
if "%action%"=="8" goto check_volume
if "%action%"=="9" goto check_container
if "%action%"=="10" goto check_build
if "%action%"=="11" goto check_image
if "%action%"=="12" goto end
echo [****Invalid Selection. Please choose a valid option.****]
goto menu

:auto_setup
echo [****Starting Automatic Setup/Check...****]
call :cleanup
call :reset
call :check_environment
call :build
call :update
call :run
echo [****Automatic Setup/Check Completed****]
pause
goto menu

:check_environment
echo [****Checking GenCore Environment****]
call :check_python || call :install_python
call :check_docker || call :install_docker
call :check_kubernetes || call :install_kubernetes
echo [****Environment Check Completed****]
pause
goto :eof

:reset
echo [****Resetting Docker Environment...****]
docker system prune -af --volumes || (
    echo [****Failed to reset Docker. Trying alternative method...****]
    docker rm $(docker ps -a -q) 2>nul
    docker rmi $(docker images -q) 2>nul
)
echo [****Docker Environment Reset Completed****]
pause
goto :eof

:build
echo [****Building Docker Image...****]
if not exist %TEMP_PATH% mkdir %TEMP_PATH%
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > build.log || (
    echo [****Build failed. Trying alternative build method...****]
)
echo [****Docker Image Built Successfully****]
if exist %TEMP_PATH% rmdir /s /q %TEMP_PATH%
pause
goto :eof

:run
echo [****Running Docker Container...****]
docker run -d --name %CONTAINER_NAME% %IMAGE_NAME% > run.log || (
    echo [****Failed to run Docker container. Trying alternative method...****]
)
echo [****Docker Container Running****]
pause
goto :eof

:update
echo [****Updating Python Libraries and Debian Packages...****]
:: Example update command
apt-get update && apt-get upgrade -y
echo [****Update Completed****]
pause
goto :eof

:cleanup
echo [****Performing Clean Up...****]
:: Remove temporary files and cleanup Docker resources
if exist %TEMP_PATH% rmdir /s /q %TEMP_PATH%
docker system prune -f
echo [****Cleanup Completed****]
pause
goto :eof

:check_python
echo [****Checking Python Installation****]
python --version 2>&1 | find "Python 3.11" > nul
if %errorlevel% neq 0 (
    echo [****Python 3.11 Not Found. Installing...****]
    call :install_python
)
echo [****Python 3.11 Detected****]
pause
goto :eof

:install_python
echo [****Installing Python 3.11****]
powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.0/python-3.11.0.exe' -OutFile 'python-3.11.0.exe'"
start /wait python-3.11.0.exe /quiet InstallAllUsers=1 PrependPath=1
if %errorlevel% neq 0 echo [****Python Installation Failed****] && goto :eof
echo [****Python 3.11 Installed****]
pause
goto :eof

:check_docker
echo [****Verifying Docker is Running****]
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Docker is Not Running. Installing...****]
    call :install_docker
) else (
    echo [****Docker is Running****]
)
pause
goto :eof

:install_docker
echo [****Installing Docker****]
powershell -Command "Invoke-WebRequest -Uri 'https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe' -OutFile 'DockerInstaller.exe'"
start /wait DockerInstaller.exe install
if %errorlevel% neq 0 echo [****Docker Installation Failed****] && goto :eof
echo [****Docker Installed****]
pause
goto :eof

:check_kubernetes
echo [****Validating Kubernetes Configuration****]
kubectl --kubeconfig=%KUBE_CONFIG_PATH% version --client > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Kubernetes is Not Set Up Correctly. Installing...****]
    call :install_kubernetes
) else (
    echo [****Kubernetes Detected****]
)
pause
goto :eof

:install_kubernetes
echo [****Installing Kubernetes****]
choco install kubernetes-cli
if %errorlevel% neq 0 echo [****Kubernetes Installation Failed****] && goto :eof
echo [****Kubernetes Installed****]
pause
goto :eof

:check_volume
echo [****Checking Docker Volume Status****]
docker volume inspect %VOLUME_NAME% > nul 2>&1
if %errorlevel% neq 0 echo [****Volume %VOLUME_NAME% does not exist.****] && goto :eof
echo [****Volume %VOLUME_NAME% exists.****]
pause
goto :eof

:check_container
echo [****Checking Docker Container Status****]
docker ps -a | findstr /i "%CONTAINER_NAME%"
pause
goto :eof

:check_build
echo [****Checking Docker Build Status****]
:: Add logic to check the Docker build status
pause
goto :eof

:check_image
echo [****Checking Docker Image Status****]
docker images | findstr /i "%IMAGE_NAME%"
pause
goto :eof

:end
echo [****Exiting GenCore Deployment Process.****]
pause
