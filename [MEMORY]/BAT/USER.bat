@echo off
setlocal enabledelayedexpansion
cls
color 0A
echo [****|     GenCore AI/OS Deployment on Windows 10 Pro x64   |****]
echo.

:start
:menu
cls
echo [****|     1. Full Setup                |****]
echo [****|     2. 'Mini' Setup              |****]
echo [****|     3. Cleanup Files             |****]
echo [****|     4. Launch Terminal           |****]
echo [****|     5. Update Python Packages    |****]
echo [****|     6. Deploy GenCore            |****]
echo [****|     7. Manage Kubernetes         |****]
echo [****|     8. Exit Program              |****]
echo.

set /p action="Please select an option (1-8): "
echo.

if "%action%"=="1" goto full_setup
if "%action%"=="2" goto mini_setup
if "%action%"=="3" goto cleanup_files
if "%action%"=="4" goto launch_terminal
if "%action%"=="5" goto update_python_packages
if "%action%"=="6" goto deploy_gencore
if "%action%"=="7" goto manage_kubernetes
if "%action%"=="8" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:full_setup
echo [****| Performing Full Setup |****]
call full_setup.bat
goto menu

:mini_setup
echo [****| Setting up 'Mini' Environment |****]
call mini_setup.bat
goto menu

:cleanup_files
echo [****| Cleaning up Files |****]
call cleanup_files.bat
goto menu

:launch_terminal
echo [****| Launching Terminal |****]
call launch_terminal.bat
goto menu

:update_python_packages
echo [****| Updating Python Packages |****]
call update_python_packages.bat
goto menu

:deploy_gencore
echo [****| Deploying GenCore System |****]
:: Deploy GenCore using Kubernetes
kubectl apply -f gencore.yaml
if %errorlevel% neq 0 (
    echo [****| Deployment failed. |****]
    pause
    goto menu
) else (
    echo [****| Deployment successful. |****]
    pause
    goto menu
)

:manage_kubernetes
echo [****| Managing Kubernetes |****]
:: Add Kubernetes management commands here
:: Example: kubectl get pods
pause
goto menu

:end
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b

endlocal
