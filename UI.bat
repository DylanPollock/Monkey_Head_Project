@echo off
setlocal enabledelayedexpansion
cls
color 0A
echo [****|     GenCore AI/OS User Interface (Windows 10 Pro x64)   |****]
echo.

:start
:menu
cls
echo [****|     1. 'Full' Setup (with Kubernetes) |****]
echo [****|     2. 'Mini' Setup                   |****]
echo [****|     3. Cleanup Files                  |****]
echo [****|     4. Launch Terminal                |****]
echo [****|     5. Update Python Packages         |****]
echo [****|     6. Create Build                   |****]
echo [****|     7. Deploy GenCore (Kubernetes)    |****]
echo [****|     8. Exit Program                   |****]
echo.

set /p action="Please select an option (1-8): "
echo.

if "%action%"=="1" goto kubernetes_setup
if "%action%"=="2" goto mini_setup
if "%action%"=="3" goto cleanup_files
if "%action%"=="4" goto launch_terminal
if "%action%"=="5" goto update_python_packages
if "%action%"=="6" goto create_build
if "%action%"=="7" goto deploy_gencore
if "%action%"=="8" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:kubernetes_setup
echo [****| Kubernetes Setup |****]
call \MonkeyHeadProject\[BAT]\kubernetes.bat
goto menu

:mini_setup
echo [****| Setting up 'Mini' Environment |****]
call \MonkeyHeadProject\[BAT]\mini.bat
goto menu

:cleanup_files
echo [****| Cleaning up Files |****]
call \MonkeyHeadProject\[BAT]\cleanup.bat
goto menu

:launch_terminal
echo [****| Launching Terminal |****]
call \MonkeyHeadProject\[BAT]\launch_terminal.bat
goto menu

:update_python_packages
echo [****| Updating Python Packages |****]
call \MonkeyHeadProject\[BAT]\update_python.bat
goto menu

:create_build
echo [****| Creating Build |****]
call \MonkeyHeadProject\[BAT]\build.bat
goto menu

:deploy_gencore
echo [****|     GenCore Kubernetes Deployment Tool    |****]
echo.

:end
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b

endlocal