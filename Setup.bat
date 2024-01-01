@echo off
setlocal

:: (NOTE: This content has been written or altered by an AI agent & is pending approval from a human counterpart.)
:: Enhanced admin check and path validation
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [****| Administrator privileges required. |****]
    pause
    exit /b
)
set BAT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
if not exist "%BAT_PATH%\*.bat" (
    echo [****| BAT_PATH is invalid or batch files are missing. |****]
    pause
    exit /b
)
set LOG_PATH=%BAT_PATH%\error_log.txt

:start
:menu
cls
echo [****|     GenCore AI/OS User Interface (Windows 10 Pro x64)   |****]
echo.
:: Menu options
echo [****|     1.  Initialize GenCore                  |****]
echo [****|     2. Full Setup with Kubernetes          |****]
echo [****|     3. Mini Setup                          |****]
echo [****|     4. Cleanup Environment                 |****]
echo [****|     5. Open Terminal                       |****]
echo [****|     6. Update Python Packages              |****]
echo [****|     7. Update Container                    |****]
echo [****|     8. Manage Volume                       |****]
echo [****|     9. Build Docker Image                  |****]
echo [****|     10. Exit Program                       |****]
echo.
set /p action="Please select an option (1-10): "
echo.
:: Action handling
if "%action%"=="1" goto start_gencore
if "%action%"=="2" goto full_setup_kubernetes
if "%action%"=="3" goto mini_setup
if "%action%"=="4" goto cleanup_environment
if "%action%"=="5" goto open_terminal
if "%action%"=="6" goto update_python_packages
if "%action%"=="7" goto update_container
if "%action%"=="8" goto manage_volume
if "%action%"=="9" goto build_docker_image
if "%action%"=="10" goto end
echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:end
echo [****| Thank you for using GenCore. Exiting now. |****]
set /p confirm_exit="Are you sure you want to exit? (Y/N): "
if /i "%confirm_exit%" neq "Y" goto menu
pause
exit /b

:: Enhanced batch calls with error reporting
:start_gencore
:: ... Rest of the script follows the same pattern ...
:: Continue with the rest of the batch calls ...

endlocal

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

:full_setup_kubernetes
echo [****| Performing Full Setup with Kubernetes |****]
call "%BAT_PATH%\full.bat"
if %errorlevel% neq 0 (
    echo [****| Full Setup with Kubernetes failed with error code %errorlevel%. |****]
) else (
    echo [****| Full Setup with Kubernetes completed successfully. |****]
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

:cleanup_environment
echo [****| Cleaning up Environment |****]
call "%BAT_PATH%\cleanup.bat"
if %errorlevel% neq 0 (
    echo [****| Cleanup failed with error code %errorlevel%. |****]
) else (
    echo [****| Cleanup completed successfully. |****]
)
pause
goto menu

:open_terminal
echo [****| Opening Terminal |****]
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

:update_container
echo [****| Updating Container |****]
call "%BAT_PATH%\container.bat"
if %errorlevel% neq 0 (
    echo [****| Updating Container failed with error code %errorlevel%. |****]
) else (
    echo [****| Container updated successfully. |****]
)
pause
goto menu

:manage_volume
echo [****| Managing Volume |****]
call "%BAT_PATH%\volume.bat"
if %errorlevel% neq 0 (
    echo [****| Managing Volume failed with error code %errorlevel%. |****]
) else (
    echo [****| Volume managed successfully. |****]
)
pause
goto menu

:build_docker_image
echo [****| Building Docker Image |****]
call "%BAT_PATH%\build.bat"
if %errorlevel% neq 0 (
    echo [****| Building Docker Image failed with error code %errorlevel%. |****]
) else (
    echo [****| Docker Image built successfully. |****]
)
pause
goto menu

:end
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b

