@echo off
setlocal

set BAT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\[BAT]

:start
:menu
cls
echo [****|     GenCore AI/OS User Interface (Windows 10 Pro x64)   |****]
echo.

echo [****|     1. Start GenCore                        |****]
echo [****|     2. 'Full' Setup (with Kubernetes)      |****]
echo [****|     3. 'Mini' Setup                        |****]
echo [****|     4. Cleanup Files                       |****]
echo [****|     5. Launch Terminal                     |****]
echo [****|     6. Update Python Packages              |****]
echo [****|     7. Create Container                    |****]
echo [****|     8. Create Volume                       |****]
echo [****|     9. Build Image                         |****]
echo [****|     10. Exit Program                      |****]
echo.

set /p action="Please select an option (1-10): "
echo.

if "%action%"=="1" goto start_gencore
if "%action%"=="2" goto full_setup
if "%action%"=="3" goto mini_setup
if "%action%"=="4" goto cleanup_files
if "%action%"=="5" goto launch_terminal
if "%action%"=="6" goto update_python_packages
if "%action%"=="7" goto create_container
if "%action%"=="8" goto create_volume
if "%action%"=="9" goto build_image
if "%action%"=="10" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:start_gencore
echo [****| Starting GenCore |****]
call "%BAT_PATH%\start.bat"
if %errorlevel% neq 0 (
    echo [****| Starting GenCore failed with error code %errorlevel%. |****]
) else (
    echo [****| GenCore started successfully. |****]
)
pause
goto menu

:full_setup
echo [****| Performing Full Setup |****]
call "%BAT_PATH%\full.bat"
if %errorlevel% neq 0 (
    echo [****| Full Setup failed with error code %errorlevel%. |****]
) else (
    echo [****| Full Setup completed successfully. |****]
)
pause
goto menu

:mini_setup
echo [****| Setting up 'Mini' Environment |****]
call "%BAT_PATH%\mini.bat"
if %errorlevel% neq 0 (
    echo [****| Mini Setup failed with error code %errorlevel%. |****]
) else (
    echo [****| Mini Setup completed successfully. |****]
)
pause
goto menu

:cleanup_files
echo [****| Cleaning up Files |****]
call "%BAT_PATH%\cleanup.bat"
if %errorlevel% neq 0 (
    echo [****| Cleanup failed with error code %errorlevel%. |****]
) else (
    echo [****| Cleanup completed successfully. |****]
)
pause
goto menu

:launch_terminal
echo [****| Launching Terminal |****]
start "cmd.exe" /k
pause
goto menu

:update_python_packages
echo [****| Updating Python Packages |****]
call "%BAT_PATH%\python.bat"
if %errorlevel% neq 0 (
    echo [****| Updating Python Packages failed with error code %errorlevel%. |****]
) else (
    echo [****| Python Packages updated successfully. |****]
)
pause
goto menu

:create_container
echo [****| Creating Container |****]
call "%BAT_PATH%\container.bat"
if %errorlevel% neq 0 (
    echo [****| Creating Container failed with error code %errorlevel%. |****]
) else (
    echo [****| Container created successfully. |****]
)
pause
goto menu

:create_volume
echo [****| Creating Volume |****]
call "%BAT_PATH%\volume.bat"
if %errorlevel% neq 0 (
    echo [****| Creating Volume failed with error code %errorlevel%. |****]
) else (
    echo [****| Volume created successfully. |****]
)
pause
goto menu

:build_image
echo [****| Building Image |****]
call "%BAT_PATH%\build.bat"
if %errorlevel% neq 0 (
    echo [****| Building Image failed with error code %errorlevel%. |****]
) else (
    echo [****| Image built successfully. |****]
)
pause
goto menu

:end
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b
