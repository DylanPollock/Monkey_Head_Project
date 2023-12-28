@echo off
echo [**** Welcome to the GenCore Deployment Process ****]
echo.

:start
:menu
echo [**  Select an action:        **]
echo [**  1. Full-Environment Setup **]
echo [**  2. Mini-Environment Setup **]
echo [**  3. Launch Terminal        **]
echo [**  4. Create Build           **]
echo [**  5. Create Volume          **]
echo [**  6. Create Container       **]
echo [**  7. Kubernetes             **]
echo [**  8. Cleanup Files          **]
echo [**  9. Exit Program           **]
echo.
set /p action="Please select an option (1-9): "
echo.

if "%action%"=="1" goto full_env_setup
if "%action%"=="2" goto mini_env_setup
if "%action%"=="3" goto launch_terminal
if "%action%"=="4" goto create_build
if "%action%"=="5" goto create_volume
if "%action%"=="6" goto create_container
if "%action%"=="7" goto kubernetes
if "%action%"=="8" goto cleanup_files
if "%action%"=="9" goto end
echo [* Invalid Selection. Please choose a valid option. *]
goto menu

:full_env_setup
echo [**** Performing Full-Environment Setup ****]
:: Full-Environment setup logic here
echo [**** Full-Environment Setup Completed Successfully ****]
goto menu

:mini_env_setup
echo [**** Setting up Mini-Environment ****]
:: Mini-Environment setup logic here
echo [**** Mini-Environment Setup Completed Successfully ****]
goto menu

:launch_terminal
echo [**** Launching Terminal ****]
:: Terminal launching logic here
goto menu

:create_build
echo [**** Creating Build ****]
:: Build creation logic here
echo [**** Build created successfully ****]
goto menu

:create_volume
echo [**** Creating Volume ****]
:: Volume creation logic here
echo [**** Volume created successfully ****]
goto menu

:create_container
echo [**** Creating Container ****]
:: Container creation logic here
echo [**** Container created and running ****]
goto menu

:kubernetes
echo [**** Setting up Kubernetes ****]
:: Kubernetes setup logic here
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
