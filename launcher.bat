@echo off
cls
color 0A
echo [**** Welcome to the GenCore Deployment Process ****]
echo.

:start
:menu
cls
echo [**  Select an action:        **]
echo [**  1. Full-Environment Setup **]
echo [**  2. Mini-Environment Setup **]
echo [**  3. Launch Terminal        **]
echo [**  4. Create Build           **]
echo [**  5. Create Volume          **]
echo [**  6. Create Container       **]
echo [**  7. Kubernetes             **]
echo [**  8. Cleanup Files          **]
echo [**  9. Update Python & Debian **]
echo [**  10. Exit Program          **]
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

echo [* Invalid Selection. Please choose a valid option. *]
pause
goto menu

:full_env_setup
cls
echo [**** Performing Full-Environment Setup ****]
call setup_full_env.bat
if %errorlevel% neq 0 (
    echo [** Error during Full-Environment Setup **]
    echo [** Please review the error log for details. **]
    echo [** Exiting Full-Environment Setup. **]
) else (
    echo [**** Full-Environment Setup Completed Successfully ****]
)
pause
goto menu

:mini_env_setup
cls
echo [**** Setting up Mini-Environment ****]
call setup_mini_env.bat
if %errorlevel% neq 0 (
    echo [** Error during Mini-Environment Setup **]
    echo [** Please review the error log for details. **]
    echo [** Exiting Mini-Environment Setup. **]
) else (
    echo [**** Mini-Environment Setup Completed Successfully ****]
)
pause
goto menu

:launch_terminal
cls
echo [**** Launching Terminal ****]
start cmd
goto menu

:create_build
cls
echo [**** Creating Build ****]
docker build -t gencore-app .
if %errorlevel% neq 0 (
    echo [** Error during build creation **]
    echo [** Exiting Build Creation. **]
) else (
    echo [**** Build created successfully ****]
)
pause
goto menu

:create_volume
cls
echo [**** Creating Volume ****]
docker volume create gencore-volume
if %errorlevel% neq 0 (
    echo [** Error during volume creation **]
    echo [** Exiting Volume Creation. **]
) else (
    echo [**** Volume created successfully ****]
)
pause
goto menu

:create_container
cls
echo [**** Creating Container ****]
docker run -d --name gencore-container -v gencore-volume:/data gencore-app
if %errorlevel% neq 0 (
    echo [** Error during container creation **]
    echo [** Exiting Container Creation. **]
) else (
    echo [**** Container created and running ****]
)
pause
goto menu

:kubernetes
cls
echo [**** Setting up Kubernetes ****]
call setup_kubernetes.bat
if %errorlevel% neq 0 (
    echo [** Error during Kubernetes setup **]
    echo [** Please review the error log for details. **]
    echo [** Exiting Kubernetes Setup. **]
) else (
    echo [**** Kubernetes setup completed successfully ****]
)
pause
goto menu

:cleanup_files
cls
echo [**** Cleanup Files ****]
echo [** Please select cleanup type: **]
echo [** 1. Full-clean **]
echo [** 2. Mini-clean **]
set /p cleanup_type="Select an option (1-2): "
echo.

if "%cleanup_type%"=="1" (
    set /p confirm="Are you sure you want to perform a Full-clean? (Y/N): "
    if /i "%confirm%"=="Y" (
        cls
        echo [**** Performing Full-clean ****]
        docker system prune -af --volumes
        if %errorlevel% neq 0 (
            echo [** Error during Full-clean **]
            echo [** Exiting Full-clean. **]
        ) else (
            echo [** Full-clean completed. All builds, containers, and volumes removed. **]
        )
    ) else (
        echo [** Full-clean canceled. **]
    )
) else if "%cleanup_type%"=="2" (
    set /p confirm="Are you sure you want to perform a Mini-clean? (Y/N): "
    if /i "%confirm%"=="Y" (
        cls
        echo [**** Performing Mini-clean ****]
        docker container prune -f
        docker volume prune -f
        if %errorlevel% neq 0 (
            echo [** Error during Mini-clean **]
            echo [** Exiting Mini-clean. **]
        ) else (
            echo [** Mini-clean completed. Temporary items removed. **]
        )
    ) else (
        echo [** Mini-clean canceled. **]
    )
)
pause
goto menu

:update_python_debian
cls
echo [**** Updating Python & Debian ****]
:: Add commands here to update Python and Debian
:: Example: apt update && apt upgrade -y
:: Example: python -m pip install --upgrade pip
:: Ensure you add error handling for these commands

:: Example: Updating Debian
:: echo [** Updating Debian **]
:: apt update
:: if %errorlevel% neq 0 (
::     echo [** Error updating Debian **]
::     echo [** Exiting update process. **]
:: ) else (
::     echo [** Debian updated successfully **]
:: )

:: Example: Updating Python
:: echo [** Updating Python **]
:: python -m pip install --upgrade pip
:: if %errorlevel% neq 0 (
::     echo [** Error updating Python **]
::     echo [** Exiting update process. **]
:: ) else (
::     echo [** Python updated successfully **]
:: )
echo [**** Python & Debian updated successfully ****]
pause
goto menu

:end
cls
echo [**** Thank you for using GenCore. Exiting now. ****]
pause
exit /b
"""