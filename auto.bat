@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET TEMP_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\memory\TEMP
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-app
SET VOLUME_NAME=gencore-volume
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config

echo [****Welcome to GenCore Deployment Process****]

:start
:: Interactive Menu for AI/OS Actions
:menu
echo.
echo Select an action:
echo 1. Automatic Setup/Check (Run through setup options automatically)
echo 2. Check Environment (checks for GenCore build, gencore-container, gencore-volume, and gencore-image)
echo 3. Reset Docker Environment (Removes old builds, containers, volumes, and images)
echo 4. Build Docker Image (creates new GenCore build, gencore-container, gencore-volume, and gencore-image)
echo 5. Run Docker Container (starts docker environment)
echo 6. Update Python libraries, and Debian packages
echo 7. Clean up (removes all Docker config files, as well as any folder it stores information)
echo 8. Exit program
set /p action=<con

if "%action%"=="1" goto auto_setup
if "%action%"=="2" goto check_environment
if "%action%"=="3" goto reset
if "%action%"=="4" goto build
if "%action%"=="5" goto run
if "%action%"=="6" goto update
if "%action%"=="7" goto cleanup
if "%action%"=="8" goto end
echo [****Invalid Selection. Please choose a valid option.****]
goto menu

:auto_setup
:: Automatic setup option for AI use
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
:: Check various components required for GenCore
echo [****Checking GenCore Environment****]
call :check_python
call :check_docker
call :check_kubernetes
:: Add logic to check GenCore specific components like build, container, volume, and image
echo [****Environment Check Completed****]
goto :eof

:reset
:: Reset Docker environment by removing all associated data
echo [****Resetting Docker Environment...****]
docker system prune -af --volumes
echo [****Docker Environment Reset Completed****]
goto :eof

:build
:: Build the Docker image
echo [****Building Docker Image...****]
call :check_python
call :check_docker
if not exist %TEMP_PATH% mkdir %TEMP_PATH%
:: Commands for setting up build environment
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > build.log
if %errorlevel% neq 0 (
    echo [****Build Error: See build.log for details.****]
    type build.log
    goto :eof
)
echo [****Docker Image Built Successfully****]
:: Clean up TEMP_PATH
if exist %TEMP_PATH% rmdir /s /q %TEMP_PATH%
goto :eof

:run
:: Run the Docker container from the built image
echo [****Running Docker Container...****]
docker run -d --name %CONTAINER_NAME% %IMAGE_NAME% > run.log
if %errorlevel% neq 0 (
    echo [****Error: Failed to run Docker container. Check run.log for details.****]
    type run.log
    goto :eof
)
echo [****Docker Container Running****]
goto :eof

:update
:: Update Python libraries and Debian packages
echo [****Updating Python Libraries and Debian Packages...****]
:: Placeholder for update logic (e.g., pip install -r requirements.txt, apt-get update)
echo [****Update Completed****]
goto :eof

:cleanup
:: Perform thorough cleanup of Docker configurations and project files
echo [****Performing Clean Up...****]
:: Placeholder for cleanup logic (e.g., docker system prune, removing local files)
echo [****Cleanup Completed****]
goto :eof

:check_python
:: Check for Python installation
python --version 2>&1 | find "Python 3.11" > nul
if %errorlevel% neq 0 (
    echo [****Error: Python 3.11 is not installed.****]
    goto :eof
)
echo [****Python 3.11 Detected****]
goto :eof

:check_docker
:: Verify Docker is running and operational
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Docker is not running.****]
    goto :eof
)
echo [****Docker is Running****]
goto :eof

:check_kubernetes
:: Validate Kubernetes configuration
kubectl --kubeconfig=%KUBE_CONFIG_PATH% version --client > nul 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Kubernetes is not set up correctly.****]
    goto :eof
)
echo [****Kubernetes Detected****]
goto :eof

:end
echo [****Exiting GenCore Deployment Process.****]
pause