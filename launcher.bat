@echo off
echo [**** Welcome to the GenCore Deployment Process ****]

:start
:: Interactive Menu for AI/OS Actions
:menu
echo.
echo [** Select an action: **]
echo [** 1. Full Automatic Setup **]
echo [** 2. Mini Setup **]
echo [** 3. Perform System Checks **]
echo [** 4. Launch Container **]
echo [** 5. Cleanup **]
echo [** 6. Exit Program **]
set /p action="Please select an option (1-6): "

:: Execute the selected option
if "%action%"=="1" goto full_setup
if "%action%"=="2" goto mini_setup
if "%action%"=="3" goto system_checks
if "%action%"=="4" goto launch_container
if "%action%"=="5" goto cleanup
if "%action%"=="6" goto end
echo [* Invalid Selection. Please choose a valid option. *]
goto menu

:full_setup
echo [**** Performing Full Setup ****]
call :setup_environment
call :check_prerequisites
call :create_volume
call :build_image
call :run_container
goto menu

:mini_setup
echo [**** Performing Mini Setup ****]
call :setup_environment
call :check_prerequisites
call :create_volume
call :build_image
goto menu

:system_checks
echo [**** Performing System Checks ****]
call :check_volume
call :check_image
call :check_container
goto menu

:launch_container
echo [**** Launching Container ****]
call :check_container
if "%errorlevel%"=="0" (
    echo [**** Container is already running. ****]
) else (
    docker start %CONTAINER_NAME%
    echo [**** Container started. ****]
)
goto menu

:cleanup
echo [**** Performing Cleanup ****]
if exist %TEMP_PATH% rmdir /s /q %TEMP_PATH%
docker system prune -f
echo [**** Cleanup Completed ****]
goto menu

:end
echo [**** Exiting GenCore Deployment Process. ****]
pause
exit /b

:: Function Definitions
:setup_environment
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container
SET KUBE_CONFIG_PATH=C:\Users\admin\.kube\config
goto :eof

:check_prerequisites
docker --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed. Exiting.
    exit /b
)
kubectl version --client > NUL 2>&1
if %errorlevel% neq 0 (
    echo Kubernetes is not installed. Exiting.
    exit /b
)
goto :eof

:create_volume
docker volume create %VOLUME_NAME%
goto :eof

:build_image
docker build -t %IMAGE_NAME% %PROJECT_PATH%
goto :eof

:run_container
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %IMAGE_NAME%
goto :eof

:check_volume
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if %errorlevel% neq 0 echo Volume %VOLUME_NAME% not found.
goto :eof

:check_image
docker images | findstr /i %IMAGE_NAME% > NUL
if %errorlevel% neq 0 echo Image %IMAGE_NAME% not found.
goto :eof

:check_container
docker ps -a | findstr /i %CONTAINER_NAME% > NUL
if %errorlevel% neq 0 echo Container %CONTAINER_NAME% not found or not running.
goto :eof