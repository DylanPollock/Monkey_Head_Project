@echo off
cls
color 0A
echo [****| GenCore Deployment Process |****]
echo.

:start
:menu
cls
echo [****|  1. Full-Environment Setup        |****]
echo [****|  2. Mini-Environment Setup        |****]
echo [****|  3. Launch Terminal               |****]
echo [****|  4. Create Build                  |****]
echo [****|  5. Create Volume                 |****]
echo [****|  6. Create Container              |****]
echo [****|  7. Kubernetes                    |****]
echo [****|  8. Cleanup Files                 |****]
echo [****|  9. Update Python & Debian        |****]
echo [****|  10. Exit Program                 |****]
echo.

set /p action="Please select an option (1-10): "
echo.

if "%action%"=="1" goto full_env_setup
if "%action%"=="2" goto mini_env_setup
if "%action%"=="3" goto launch_terminal
if "%action%"=="4" goto create_build
if "%action%"=="5" goto create_volume
if "%action%"=="6" goto create_container
if "%action%"=="7" goto kubernetes
if "%action%"=="8" goto cleanup_files
if "%action%"=="9" goto update_python_debian
if "%action%"=="10" goto end

echo [****| Invalid Selection. Please choose a valid option. |****]
pause
goto menu

:full_env_setup
cls
echo [****| Performing Full-Environment Setup |****]

:: Step 1: Install required packages/software
echo [****| Step 1: Installing required packages/software |****]
:: choco install package1
:: choco install package2

:: Check the exit code of the installation commands
if %errorlevel% neq 0 (
    echo [****| Error during package/software installation |****]
    echo [****| Exiting Full-Environment Setup.              |****]
    pause
    goto menu
) else (
    echo [****| Step 1: Required packages/software installed successfully |****]
)

:: Step 2: Configure system settings
echo [****| Step 2: Configuring system settings |****]
setx PROJECT "MonkeyHeadProject"

:: Check the exit code of the configuration step
if %errorlevel% neq 0 (
    echo [****| Error during system configuration |****]
    echo [****| Exiting Full-Environment Setup.   |****]
    pause
    goto menu
) else (
    echo [****| Step 2: System settings configured successfully |****]
)

:: Step 3: Download necessary files
echo [****| Step 3: Downloading necessary files |****]
::curl -o filename.ext https://example.com/path/to/file.ext

:: Check the exit code of the download step
if %errorlevel% neq 0 (
    echo [****| Error during file download |****]
    echo [****| Exiting Full-Environment Setup. |****]
    pause
    goto menu
) else (
    echo [****| Step 3: Necessary files downloaded successfully |****]
)

:: Return to the main menu after setup is complete
goto full_env_setup_completed

:full_env_setup_completed
cls
echo [****| Full-Environment Setup completed successfully |****]
pause
goto menu

:mini_env_setup
cls
echo [****| Setting up Mini-Environment |****]

:: (Similar steps as full environment setup)

:: Return to the main menu after setup is complete
goto mini_env_setup_completed

:mini_env_setup_completed
cls
echo [****| Mini-Environment Setup completed successfully |****]
pause
goto menu

:launch_terminal
cls
echo [****| Launching Terminal |****]

:: Open a new command prompt window
start cmd

goto menu

:create_build
cls
echo [****| Creating Build |****]

:: Step 4: Build a Docker image named 'gencore-image'
docker build -t gencore-image .

:: Check the exit code of the build command
if %errorlevel% neq 0 (
    echo [****| Error during build creation     |****]
    echo [****| Exiting Build Creation.         |****]
) else (
    echo [****| Step 4: Build created successfully      |****]
)

pause
goto menu

:create_volume
cls
echo [****| Creating Volume |****]

:: (Similar steps as creating a build)

:: Return to the main menu after setup is complete
goto create_volume_completed

:create_volume_completed
cls
echo [****| Volume created successfully     |****]
pause
goto menu

:create_container
cls
echo [****| Creating Container |****]

:: (Similar steps as creating a build)

:: Return to the main menu after setup is complete
goto create_container_completed

:create_container_completed
cls
echo [****| Container created and running   |****]
pause
goto menu

:kubernetes
cls
echo [****| Kubernetes Setup |****]

:: (Similar steps as full environment setup)

:: Return to the main menu after Kubernetes setup is complete
goto kubernetes_setup_completed

:kubernetes_setup_completed
cls
echo [****| Kubernetes setup completed successfully     |****]
pause
goto menu

:cleanup_files
cls
echo [****| 1. Full-clean       |****]
echo [****| 2. Mini-clean       |****]
echo [****| 3. Cancel / Return  |****]

set /p cleanup_type="Select an option (1-3): "
echo.

if "%cleanup_type%"=="1" (
    echo [****| Initiating Full-clean |****]
    
    :: Step 1: Remove all Docker containers, images, and volumes
    echo [****| Step 1: Removing all Docker containers, images, and volumes |****]
    docker system prune -af --volumes
    
    :: Check the exit code of the full clean command
    if %errorlevel% neq 0 (
        echo [****| Error during Full-clean |****]
        echo [****| Exiting Full-clean.     |****]
    ) else (
        echo [****| Step 1: Full-clean completed. All builds, containers, and volumes removed. |****]
    )
    
    pause
    goto cleanup_completed
) else if "%cleanup_type%"=="2" (
    echo [****| Initiating Mini-clean |****]
    
    :: Step 1: Remove stopped Docker containers
    echo [****| Step 1: Removing stopped Docker containers |****]
    docker container prune -f
    
    :: Step 2: Remove unused volumes
    echo [****| Step 2: Removing unused Docker volumes |****]
    docker volume prune -f
    
    :: Check the exit code of the mini clean commands
    if %errorlevel% neq 0 (
        echo [****| Error during Mini-clean |****]
        echo [****| Exiting Mini-clean. |****]
    ) else (
        echo [****| Step 1: Mini-clean completed. Temporary items removed. |****]
    )
    
    pause
    goto cleanup_completed
) else if "%cleanup_type%"=="3" (
    echo [****| Cleanup canceled. |****]
    pause
    goto menu
) else (
    echo [****| Invalid Selection. Please choose a valid option. |****]
    pause
    goto menu
)

:cleanup_completed
cls
echo [****| Cleanup completed successfully |****]
pause
goto menu


:cleanup_completed
cls
echo [****| Cleanup completed successfully |****]
pause
goto menu

:update_python_debian
cls
echo [****| Updating Python & Debian |****]

:: Return to the main menu after update is complete
goto update_completed

:update_completed
cls
echo [****| Python & Debian updated successfully |****]
pause
goto menu

:end
cls
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b