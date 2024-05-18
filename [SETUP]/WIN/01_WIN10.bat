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

:full_setup
echo [****| Performing Full Setup |****]
call 02_FULL.bat
goto menu

:mini_setup
echo [****| Setting up 'Mini' Environment |****]
call 02_MINI.bat
goto menu

:cleanup_files
echo [****| Cleaning up Files |****]
call 03_CLEANUP.bat
goto menu

:launch_terminal
echo [****| Launching Terminal |****]
call 04_TERMINAL.bat
goto menu

:update_python_packages
echo [****| Updating Python Packages |****]
call 05_UPDATE.bat
goto menu

:build_system
echo [****| Building System |****]
call 06_BUILD.bat
goto menu

:manage_containers
echo [****| Managing Containers |****]
call 07_CONTAINER.bat
goto menu

:manage_volumes
echo [****| Managing Volumes |****]
call 08_VOLUME.bat
goto menu

:deploy_kubernetes
echo [****| Deploying with Kubernetes |****]
call 09_KUBERNETES.bat
goto menu

:start_system
echo [****| Starting System |****]
call 10_START.bat
goto menu

:setup_hostos
echo [****| Setting up HostOS |****]
call 11_HOSTOS.bat
goto menu

:setup_subos
echo [****| Setting up SubOS |****]
call 12_SUBOS.bat
goto menu

:setup_nanoos
echo [****| Setting up NanoOS |****]
call 13_NANOOS.bat
goto menu

:kubernetes_management
echo [****| Kubernetes Management |****]
call 14_KUBERNETES_MANAGE.bat
goto menu

:status
echo [****| Checking System Status |****]
call 15_STATUS.bat
goto menu

:end
echo [****| Exiting WIN10.bat. Thank you for using GenCore. |****]
pause
exit /b

endlocal