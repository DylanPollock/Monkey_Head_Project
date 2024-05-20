@echo off
setlocal enabledelayedexpansion

:: Change to the script's own directory
cd /d "%~dp0"

cls
color 0A
echo [****|     WIN10.bat - GenCore AI/OS Deployment on Windows 10 Pro x64   |****]
echo.

:start
:menu
cls
echo [****|     1. Full Setup                |****]
echo [****|     2. 'Mini' Setup              |****]
echo [****|     3. Cleanup Files             |****]
echo [****|     4. Launch Terminal           |****]
echo [****|     5. Update Python Packages    |****]
echo [****|     6. Build System              |****]
echo [****|     7. Manage Containers         |****]
echo [****|     8. Manage Volumes            |****]
echo [****|     9. Deploy with Kubernetes    |****]
echo [****|    10. Start System              |****]
echo [****|    11. Setup HostOS              |****]
echo [****|    12. Setup SubOS               |****]
echo [****|    13. Setup NanoOS              |****]
echo [****|    14. Kubernetes Management     |****]
echo [****|    15. Status                    |****]
echo [****|     [E]xit Program               |****]
echo.

set /p action="Please select an option (1-15, E/e to exit): "
echo.

if "%action%"=="1" goto full_setup
if "%action%"=="2" goto mini_setup
if "%action%"=="3" goto cleanup_files
if "%action%"=="4" goto launch_terminal
if "%action%"=="5" goto update_python_packages
if "%action%"=="6" goto build_system
if "%action%"=="7" goto manage_containers
if "%action%"=="8" goto manage_volumes
if "%action%"=="9" goto deploy_kubernetes
if "%action%"=="10" goto start_system
if "%action%"=="11" goto setup_hostos
if "%action%"=="12" goto setup_subos
if "%action%"=="13" goto setup_nanoos
if "%action%"=="14" goto kubernetes_management
if "%action%"=="15" goto status
if /i "%action%"=="E" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:checkError
if %errorlevel% neq 0 (
    echo Error: %1 failed with error code %errorlevel%.
    pause
    exit /b %errorlevel%
)
goto :eof

:ensureAdmin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b %errorlevel%
)
goto :eof

:systemCheck
echo Performing system checks...
REM Check for Windows version
REM Check for required software
REM Check for available disk space
REM Add any other necessary checks
goto :eof

:full_setup
echo [****| Performing Full Setup |****]
call :ensureAdmin
call :systemCheck
call 02_FULL.bat
call :checkError "Full Setup"
goto menu

:mini_setup
echo [****| Setting up 'Mini' Environment |****]
call :ensureAdmin
call :systemCheck
call 02_MINI.bat
call :checkError "Mini Setup"
goto menu

:cleanup_files
echo [****| Cleaning up Files |****]
call :ensureAdmin
call 03_CLEANUP.bat
call :checkError "Cleanup Files"
goto menu

:launch_terminal
echo [****| Launching Terminal |****]
call :ensureAdmin
call 04_TERMINAL.bat
call :checkError "Launch Terminal"
goto menu

:update_python_packages
echo [****| Updating Python Packages |****]
call :ensureAdmin
call 05_UPDATE.bat
call :checkError "Update Python Packages"
goto menu

:build_system
echo [****| Building System |****]
call :ensureAdmin
call 06_BUILD.bat
call :checkError "Build System"
goto menu

:manage_containers
echo [****| Managing Containers |****]
call :ensureAdmin
call 07_CONTAINER.bat
call :checkError "Manage Containers"
goto menu

:manage_volumes
echo [****| Managing Volumes |****]
call :ensureAdmin
call 08_VOLUME.bat
call :checkError "Manage Volumes"
goto menu

:deploy_kubernetes
echo [****| Deploying with Kubernetes |****]
call :ensureAdmin
call 09_KUBERNETES.bat
call :checkError "Deploy Kubernetes"
goto menu

:start_system
echo [****| Starting System |****]
call :ensureAdmin
call 10_START.bat
call :checkError "Start System"
goto menu

:setup_hostos
echo [****| Setting up HostOS |****]
call :ensureAdmin
call 11_HOSTOS.bat
call :checkError "Setup HostOS"
goto menu

:setup_subos
echo [****| Setting up SubOS |****]
call :ensureAdmin
call 12_SUBOS.bat
call :checkError "Setup SubOS"
goto menu

:setup_nanoos
echo [****| Setting up NanoOS |****]
call :ensureAdmin
call 13_NANOOS.bat
call :checkError "Setup NanoOS"
goto menu

:kubernetes_management
echo [****| Kubernetes Management |****]
call :ensureAdmin
call 14_KUBERNETES_MANAGE.bat
call :checkError "Kubernetes Management"
goto menu

:status
echo [****| Checking System Status |****]
call :ensureAdmin
REM Call a status script or include status commands here
REM Example: 
REM echo Checking Docker status...
REM docker ps
REM echo Checking Kubernetes status...
REM kubectl get pods
goto menu

:end
echo [****| Exiting WIN10.bat. Thank you for using GenCore. |****]
pause
exit /b

endlocal