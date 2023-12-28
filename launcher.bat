@echo off
echo [**** Welcome to the GenCore Deployment Process ****]

:start
:: Interactive Menu for AI/OS Actions
:menu
echo.
echo [** Select an action: **]
echo [** 1. Full Automatic Setup    **]
echo [** 2. Mini Setup             **]
echo [** 3. Perform System Checks  **]
echo [** 4. Launch Container       **]
echo [** 5. Cleanup                **]
echo [** 6. Exit Program           **]
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
:: Full setup logic including environment setup, volume creation, image build, and container run with error handling
echo [**** Performing Full Setup ****]
call :setup_environment
call :create_volume
call :build_image
call :run_container
goto menu

:mini_setup
:: Mini setup logic focuses on creating volume and building image
echo [**** Performing Mini Setup ****]
call :setup_environment
call :create_volume
call :build_image
goto menu

:system_checks
:: System checks logic including volume, image, and container checks
echo [**** Performing System Checks ****]
call :check_volume
call :check_image
call :check_container
goto menu

:launch_container
:: Launching the container if it's not running and opening it in the terminal
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
:: Cleanup logic to remove temporary files and clean up Docker resources
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
:: Sets up environment variables for the project
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container
goto :eof

:create_volume
:: Creates a Docker volume for persistent data
docker volume create %VOLUME_NAME%
goto :eof

:build_image
:: Builds a Docker image from the Dockerfile located at the project path
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Image Build Failed ****]
    pause
    exit /b
)
goto :eof

:run_container
:: Runs a Docker container using the built image and attaches the volume
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %IMAGE_NAME%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Container Run Failed ****]
    pause
    exit /b
)
goto :eof

:check_volume
:: Checks if the Docker volume exists
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if %errorlevel% neq 0 echo Volume %VOLUME_NAME% not found.
goto :eof

:check_image
:: Checks if the Docker image exists
docker images | findstr /i %IMAGE_NAME% > NUL
if %errorlevel% neq 0 echo Image %IMAGE_NAME% not found.
goto :eof

:check_container
:: Checks if the Docker container exists and is running
docker ps -a | findstr /i %CONTAINER_NAME% > NUL
if %errorlevel% neq 0 echo Container %CONTAINER_NAME% not found or not running.
goto :eof
