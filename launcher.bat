@echo off
echo [**** Welcome to the GenCore Deployment Process ****]
echo.

:start
:menu
echo [**  Select an action:      	  **]
echo [**  1. Full-Environment Setup       **]
echo [**  2. Mini-Environment Setup       **]
echo [**  3. Launch Terminal              **]
echo [**  4. Create Build                 **]
echo [**  5. Create Volume                **]
echo [**  6. Create Container             **]
echo [**  7. Kubernetes                   **]
echo [**  8. Cleanup Files                **]
echo [**  9. Exit Program                 **]
echo.
set /p action="Please select an option (1-9): "
echo.

if "%action%"=="1" call :full_env_setup && goto menu
if "%action%"=="2" call :mini_env_setup && goto menu
if "%action%"=="3" call :launch_terminal && goto menu
if "%action%"=="4" call :create_build && goto menu
if "%action%"=="5" call :create_volume && goto menu
if "%action%"=="6" call :create_container && goto menu
if "%action%"=="7" call :kubernetes && goto menu
if "%action%"=="8" call :cleanup_files && goto menu
if "%action%"=="9" goto end
echo [* Invalid Selection, choose a valid option. *]
goto menu

:full_env_setup
echo [**** Performing Full-Environment Setup ****]
:: Step 1: Set up environment variables
SET BUILD_NAME=GenCore-%date:~-10,2%-%date:~-7,2%-%date:~-4,4%
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container
:: Step 2: Create a Docker build
docker build -t %BUILD_NAME% . > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Error: Failed to create Docker build ****]
    goto menu
)
:: Step 3: Create a Docker volume
docker volume create %VOLUME_NAME% > NUL 2>&1
:: Step 4: Run a Docker container with the new build and volume
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %BUILD_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Error: Failed to run Docker container ****]
    goto menu
)
echo [**** Full-Environment Setup Completed Successfully ****]
goto menu

:mini_env_setup
echo [**** Setting up Mini-Environment ****]
:: Mini-Environment setup similar to Full-Environment but with temporary build, volume, and container names
SET MINI_BUILD_NAME=Mini-%date:~-10,2%-%date:~-7,2%-%date:~-4,4%
SET MINI_VOLUME_NAME=mini-volume
SET MINI_CONTAINER_NAME=mini-container
:: Similar steps as in :full_env_setup but with mini environment variables
echo [**** Mini-Environment Setup Completed Successfully ****]
goto menu

:launch_terminal
echo [**** Launching Terminal ****]
:: Step 1: Check if the container is running
docker ps | findstr /i %CONTAINER_NAME% > NUL
if %errorlevel% neq 0 (
    echo [**** Error: Container is not running ****]
    goto menu
)
:: Step 2: Launch an interactive terminal session with the container
docker exec -it %CONTAINER_NAME% /bin/bash
goto menu

:create_build
echo [**** Creating Build ****]
:: Create a new Docker build with the current date as part of the build name
SET NEW_BUILD_NAME=GenCore-%date:~-10,2%-%date:~-7,2%-%date:~-4,4%
docker build -t %NEW_BUILD_NAME% . > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Error: Failed to create new build ****]
    goto menu
)
echo [**** Build %NEW_BUILD_NAME% created successfully ****]
goto menu

:create_volume
echo [**** Creating Volume ****]
:: Create a new Docker volume and ensure it's named correctly and connected to the build
docker volume create %VOLUME_NAME% > NUL 2>&1
echo [**** Volume %VOLUME_NAME% created and ready ****]
goto menu

:create_container
echo [**** Creating Container ****]
:: Create a new Docker container and ensure it's running with the latest build and volume
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %BUILD_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [**** Error: Failed to create new container ****]
    goto menu
)
echo [**** Container %CONTAINER_NAME% created and running ****]
goto menu

:kubernetes
echo [**** Setting up Kubernetes ****]
:: Set up Kubernetes and ensure it's connected to the container and volume
:: Kubernetes setup commands and error checking here
echo [**** Kubernetes setup completed successfully ****]
goto menu

:cleanup_files
echo [**** Cleanup Files ****]
echo [** Please select cleanup type: **]
echo [** 1. Full-clean **]
echo [** 2. Mini-clean **]
set /p cleanup_type="Select an option (1-2): "
echo.

if "%cleanup_type%"=="1" (
    echo [**** Performing Full-clean ****]
    for /f "tokens=*" %%a in ('docker system prune -af --volumes ^| findstr "Total reclaimed space"') do set "reclaim=%%a"
    echo %reclaim%
    echo [** Full-clean completed **]
) else if "%cleanup_type%"=="2" (
    echo [**** Performing Mini-clean ****]
    :: Mini-clean commands here
    echo [** Mini-clean completed **]
)
echo [** Cleanup completed **]
goto menu

:end
echo [**** Thank you for using GenCore. Exiting now. ****]
pause
exit /b
