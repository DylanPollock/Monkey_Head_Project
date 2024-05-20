@echo off
setlocal enabledelayedexpansion

:: Change to the script's own directory
cd /d "%~dp0"

:: Clear screen and set color
cls
color 0A
echo [****|     WIN10.bat - GenCore AI/OS Deployment on Windows 11 Pro x64   |****]
echo.

:: Function to ensure the script is running with administrative privileges
:ensureAdmin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b %errorlevel%
)
goto :eof

:: Function to check the last command and exit if it failed
:checkError
if %errorlevel% neq 0 (
    echo Error: %1 failed with error code %errorlevel%.
    call :logError "%1"
    pause
    exit /b %errorlevel%
)
goto :eof

:: Function to log errors
:logError
echo %date% %time% - Error: %1 failed with error code %errorlevel% >> error_log.txt
goto :eof

:: Function to perform initial system checks
:systemCheck
echo Performing system checks...
REM Check for Windows version
ver | find "10" >nul
call :checkError "Windows 10 Check"
REM Check for available disk space
for /f "tokens=3" %%a in ('dir /-C %SystemDrive% ^| findstr /R "bytes free$"') do set FreeSpace=%%a
echo Free space on %SystemDrive%: %FreeSpace%
REM Check for internet connectivity
ping -n 1 google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: No internet connection detected.
    call :logError "Internet Connectivity Check"
    pause
    exit /b %errorlevel%
)
REM Check for required software
REM Add any other necessary checks here
goto :eof

:: Function to install Chocolatey if not already installed
:installChocolatey
if exist "%ProgramData%\chocolatey\bin\choco.exe" (
    echo Chocolatey is already installed.
) else (
    echo Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    call :checkError "Chocolatey Installation"
)
goto :eof

:: Function to install common tools
:installCommonTools
echo Installing common tools...
choco install -y git
call :checkError "Git Installation"
choco install -y nodejs
call :checkError "NodeJS Installation"
choco install -y vscode
call :checkError "VSCode Installation"
goto :eof

:: Function to install optional tools
:installOptionalTools
echo Installing optional tools...
REM Uncomment the tools you need
REM choco install -y <tool-name>
call :checkError "Optional Tools Installation"
goto :eof

:: Function to perform full setup
:full_setup
echo [****| Full Setup |****]
call :ensureAdmin
call :systemCheck
call :installChocolatey
call :installCommonTools
call 02_FULL.bat
call :checkError "Full Setup"
goto menu

:: Function to perform mini setup
:mini_setup
echo [****| Mini Setup |****]
call :ensureAdmin
call :systemCheck
call :installChocolatey
call :installCommonTools
call 02_MINI.bat
call :checkError "Mini Setup"
goto menu

:: Function to perform cleanup
:cleanup
echo [****| Cleanup |****]
call :ensureAdmin
call 03_CLEANUP.bat
call :checkError "Cleanup Files"
goto menu

:: Function to launch terminal
:launch_terminal
echo [****| Launching Terminal |****]
call :ensureAdmin
call 04_TERMINAL.bat
call :checkError "Launch Terminal"
goto menu

:: Function to update Python packages
:update_python_packages
echo [****| Updating Python Packages |****]
call :ensureAdmin
call 05_UPDATE.bat
call :checkError "Update Python Packages"
goto menu

:: Function to build the system
:build_system
echo [****| Building System |****]
call :ensureAdmin
call 06_BUILD.bat
call :checkError "Build System"
goto menu

:: Function to manage Docker containers
:manage_containers
echo [****| Managing Containers |****]
call :ensureAdmin
call 07_CONTAINER.bat
call :checkError "Manage Containers"
goto menu

:: Function to manage Docker volumes
:manage_volumes
echo [****| Managing Volumes |****]
call :ensureAdmin
call 08_VOLUME.bat
call :checkError "Manage Volumes"
goto menu

:: Function to deploy with Kubernetes
:deploy_kubernetes
echo [****| Deploying with Kubernetes |****]
call :ensureAdmin
call 09_KUBERNETES.bat
call :checkError "Deploy Kubernetes"
goto menu

:: Function to start the system
:start_system
echo [****| Starting System |****]
call :ensureAdmin
call 10_START.bat
call :checkError "Start System"
goto menu

:: Function to set up HostOS
:setup_hostos
echo [****| Setting up HostOS |****]
call :ensureAdmin
call 11_HOSTOS.bat
call :checkError "Setup HostOS"
goto menu

:: Function to set up SubOS
:setup_subos
echo [****| Setting up SubOS |****]
call :ensureAdmin
call 12_SUBOS.bat
call :checkError "Setup SubOS"
goto menu

:: Function to set up NanoOS
:setup_nanoos
echo [****| Setting up NanoOS |****]
call :ensureAdmin
call 13_NANOOS.bat
call :checkError "Setup NanoOS"
goto menu

:: Function to manage Kubernetes
:kubernetes_management
echo [****| Kubernetes Management |****]
call :ensureAdmin
call 14_KUBERNETES_MANAGE.bat
call :checkError "Kubernetes Management"
goto menu

:: Function to check system status
:status
echo [****| Checking System Status |****]
call :ensureAdmin
REM Call a status script or include status commands here
REM Example: 
echo Checking Docker status...
docker ps
echo Checking Kubernetes status...
kubectl get pods
call :checkError "Check System Status"
goto menu

:: Function to backup configurations
:backup_config
echo [****| Backing up Configurations |****]
REM Add backup commands here
call :checkError "Backup Configurations"
goto menu

:: Function to restore configurations
:restore_config
echo [****| Restoring Configurations |****]
REM Add restore commands here
call :checkError "Restore Configurations"
goto menu

:: Function to check and install dependencies
:check_dependencies
echo [****| Checking and Installing Dependencies |****]
REM Add dependency checks and installations here
call :checkError "Check Dependencies"
goto :eof

:end
echo [****| Exiting WIN10.bat. Thank you for using GenCore. |****]
pause
exit /b

:menu
cls
echo.
echo Main Menu:
echo.
echo 1. Full Setup
echo 2. Mini Setup
echo 3. Cleanup
echo 4. Launch Terminal
echo 5. Update Python Packages
echo 6. Build System
echo 7. Manage Containers
echo 8. Manage Volumes
echo 9. Deploy with Kubernetes
echo 10. Start System
echo 11. Setup HostOS
echo 12. Setup SubOS
echo 13. Setup NanoOS
echo 14. Kubernetes Management
echo 15. Check System Status
echo 16. Backup Configurations
echo 17. Restore Configurations
echo 18. Check Dependencies
echo E. Exit
echo.
set /p choice=Enter your choice: 
if /i "%choice%"=="1" goto full_setup
if /i "%choice%"=="2" goto mini_setup
if /i "%choice%"=="3" goto cleanup
if /i "%choice%"=="4" goto launch_terminal
if /i "%choice%"=="5" goto update_python_packages
if /i "%choice%"=="6" goto build_system
if /i "%choice%"=="7" goto manage_containers
if /i "%choice%"=="8" goto manage_volumes
if /i "%choice%"=="9" goto deploy_kubernetes
if /i "%choice%"=="10" goto start_system
if /i "%choice%"=="11" goto setup_hostos
if /i "%choice%"=="12" goto setup_subos
if /i "%choice%"=="13" goto setup_nanoos
if /i "%choice%"=="14" goto kubernetes_management
if /i "%choice%"=="15" goto status
if /i "%choice%"=="16" goto backup_config
if /i "%choice%"=="17" goto restore_config
if /i "%choice%"=="18" goto check_dependencies
if /i "%choice%"=="E" goto end
goto menu

endlocal