@echo off
echo [**** Welcome to the GenCore Deployment Process ****]

:start
:: Display an interactive menu for selecting actions
:menu
echo.
echo [**  Select an action:      **]
echo [**  1. Full Automatic Setup    **]
echo [**  2. Mini Setup              **]
echo [**  3. Perform System Checks   **]
echo [**  4. Launch Container        **]
echo [**  5. Open Terminal           **]
echo [**  6. Cleanup                 **]
echo [**  7. Exit Program            **]
set /p action="Please select an option (1-7): "

:: Direct the script to different sections based on user input
if "%action%"=="1" call :full_setup
if "%action%"=="2" call :mini_setup
if "%action%"=="3" call :system_checks
if "%action%"=="4" call :launch_container
if "%action%"=="5" call :connect_terminal
if "%action%"=="6" call :cleanup
if "%action%"=="7" goto end
echo [* Invalid Selection. Please choose a valid option. *]
goto menu

:: Setup environment variables for the project
:setup_environment
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container
goto :eof

:: Creates a Docker volume for persistent data
:create_volume
docker volume create %VOLUME_NAME%
goto :eof

:: Builds a Docker image from the Dockerfile located at the project path
:build_image
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Image Build Failed ****]
    pause
    exit /b
)
goto :eof

:: Runs a Docker container using the built image and attaches the volume
:run_container
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %IMAGE_NAME%
if %errorlevel% neq 0 (
    echo [**** Error: Docker Container Run Failed ****]
    pause
    exit /b
)
goto :eof

:: Checks if the Docker volume exists
:check_volume
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if %errorlevel% neq 0 echo Volume %VOLUME_NAME% not found.
goto :eof

:: Checks if the Docker image exists
:check_image
docker images | findstr /i %IMAGE_NAME% > NUL
if %errorlevel% neq 0 echo Image %IMAGE_NAME% not found.
goto :eof

:: Checks if the Docker container exists and is running
:check_container
docker ps -a | findstr /i %CONTAINER_NAME% > NUL
if %errorlevel% neq 0 echo Container %CONTAINER_NAME% not found or not running.
goto :eof

:: Connects to the running container and opens a terminal for interaction
:connect_terminal
call :setup_environment
call :check_container
if %errorlevel% neq 0 (
    docker start %CONTAINER_NAME%
    echo [**** Container %CONTAINER_NAME% started. ****]
)
docker exec -it %CONTAINER_NAME% /bin/bash
goto menu

:: Full setup logic including environment setup, volume creation, image build, and container run with error handling
:full_setup
call :setup_environment
call :create_volume
call :build_image
call :run_container
goto menu

:: Mini setup logic focuses on creating volume and building image
:mini_setup
call :setup_environment
call :create_volume
call :build_image
goto menu

:: System checks logic including volume, image, and container checks
:system_checks
call :setup_environment
call :check_volume
call :check_image
call :check_container
goto menu

:: Launching the container if it's not running
:launch_container
call :setup_environment
call :check_container
if %errorlevel% neq 0 (
    docker start %CONTAINER_NAME%
    echo [**** Container %CONTAINER_NAME% started. ****]
)
goto menu

:: Cleanup logic to remove temporary files and clean up Docker resources
:cleanup
if exist %TEMP_PATH% rmdir /s /q %TEMP_PATH%
docker system prune -f
echo [**** Cleanup Completed ****]
goto menu

:end
echo [**** Exiting GenCore Deployment Process. ****]
pause
exit /b
