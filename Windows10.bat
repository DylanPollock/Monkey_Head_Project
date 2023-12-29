@echo off
setlocal enabledelayedexpansion
cls
color 0A
echo [****|     GenCore (Windows 10 Pro x64)   |****]
echo.

:start
:menu
cls
echo [****|     1. Full Setup                |****]
echo [****|     2. 'Mini' Setup              |****]
echo [****|     3. Cleanup Files             |****]
echo [****|     4. Launch Terminal           |****]
echo [****|     5. Update Python Packages    |****]
echo [****|     6. Create Build              |****]
echo [****|     7. Create Volume             |****]
echo [****|     8. Create Container          |****]
echo [****|     9. Kubernetes                |****]
echo [****|    10. Execute GenCore.py        |****]
echo [****|    11. Exit Program              |****]
echo.

set /p action="Please select an option (1-11): "
echo.

if "%action%"=="1" goto full_setup
if "%action%"=="2" goto mini_setup
if "%action%"=="3" goto cleanup_files
if "%action%"=="4" goto launch_terminal
if "%action%"=="5" goto update_python_packages
if "%action%"=="6" goto create_build
if "%action%"=="7" goto create_volume
if "%action%"=="8" goto create_container
if "%action%"=="9" goto kubernetes
if "%action%"=="10" goto execute_gencore
if "%action%"=="11" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:execute_gencore
cls
echo [****|     Executing GenCore.py script |****]
"C:\Program Files\Python313\python.exe" "C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\GenCore.py"
if !errorlevel! neq 0 (
    echo [****| Error during execution of GenCore.py |****]
    pause
    goto menu
) else (
    echo [****| GenCore.py executed successfully |****]
    pause
    goto menu
)

:: The rest of the script remains unchanged...