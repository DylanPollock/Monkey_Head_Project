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
echo [****|    10. Exit Program              |****]
echo.

set /p action="Please select an option (1-10): "
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
if "%action%"=="10" goto end

echo [****|     Invalid Selection. Choose a valid option:   |****]
pause
goto menu

:full_setup
cls
echo [****|     Performing Full Setup   |****]

:: Step 1: Verify Python Installation
echo [****| Step 1: Verifying Python installation |****]
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [****| Python is not installed or not added to PATH. |****]
    echo [****| Please install Python manually and ensure it's in the PATH. |****]
    echo [****| You can download Python from https://www.python.org/downloads/. |****]
    echo [****| After installation, re-run the script. |****]
    pause
    goto end
) else (
    echo [****| Python is installed. |****]
)

:: Step 2: Set environment variables
echo [****| Step 2: Setting environment variables |****]
:: Setting environment variables.
set PROJECT=GenCore
set ENVIRONMENT=Testing
echo [****| Environment variables set successfully |****]

:: Step 3: Set up a Python virtual environment
echo [****| Step 3: Setting up Python virtual environment |****]
python -m venv GenCoreEnv
if !errorlevel! neq 0 (
    echo [****| Error setting up Python virtual environment |****]
    echo [****| Exiting Full Setup.                        |****]
    pause
    goto end
) else (
    echo [****| Python virtual environment setup completed |****]
)

:: Additional steps for full setup can be added here...

goto full_setup_completed

:full_setup_completed
cls
echo [****| Full Setup completed successfully |****]
pause
goto menu

:end
cls
echo [****| Thank you for using GenCore. Exiting now. |****]
pause
exit /b

:mini_setup
cls
echo [****| Setting up 'Mini' Environment |****]

:: Step 1: Install minimal necessary software
echo [****| Step 1: Installing minimal required software |****]
:: Using 'pip' to install minimal necessary software packages.
python -m pip install requests beautifulsoup4 lxml
if !errorlevel! neq 0 (
    echo [****| Error during minimal software installation  |****]
    echo [****| Exiting 'Mini' Environment Setup.           |****]
    pause
    goto menu
) else (
    echo [****| Step 1: Minimal required software installed successfully |****]
)

:: Step 2: Configure specific settings for the 'Mini' Environment
echo [****| Step 2: Configuring specific settings |****]
:: Configuration commands for the 'Mini' environment.
:: Example: set MINI_ENV_SETTING=value
set MINI_ENV_SETTING=Minimal

:: Check the exit code of the configuration step
if !errorlevel! neq 0 (
    echo [****| Error during configuration for 'Mini' Environment |****]
    echo [****| Exiting 'Mini' Environment Setup.                 |****]
    pause
    goto menu
) else (
    echo [****| Step 2: Configuration for 'Mini' Environment completed successfully |****]
)

:: Additional steps for 'Mini' setup can be added here...

goto mini_setup_completed

:mini_setup_completed
cls
echo [****| 'Mini' Environment Setup completed successfully |****]
pause
goto menu

:cleanup_files
cls
echo [****| Cleaning up Files |****]

:: Step 1: Execute cleanup commands
echo [****| Step 1: Executing cleanup commands |****]
:: Cleanup temporary files
del /f /q %temp%\*

:: Cleanup log files
::del /f /q C:\path\to\logs\*.log

:: Additional cleanup commands:
:: Clearing browser cache (Example for Chrome)
del /f /q C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Cache\*

:: Clearing system temp files
del /f /q %temp%\*

:: Removing any specific application cache or temp files
:: Example: del /f /q C:\path\to\application\cache\*

:: Removing old Windows Update files (administrative privileges required)
:: Example: del /f /q C:\Windows\SoftwareDistribution\Download\*

:: Check the exit code of the cleanup commands
if !errorlevel! neq 0 (
    echo [****| Error during cleanup process |****]
    echo [****| Exiting Cleanup Files.      |****]
    pause
    goto menu
) else (
    echo [****| Step 1: Cleanup commands executed successfully |****]
)

:: Return to the main menu after cleanup is complete
goto cleanup_completed

:cleanup_completed
cls
echo [****| Cleanup completed successfully |****]
pause
goto menu

:launch_terminal
cls
echo [****| Launching Terminal |****]

:: Step 1: Launch the terminal
echo [****| Step 1: Launching terminal |****]
:: Use the 'start' command to open a new command prompt window with the `/k` option to keep the window open after execution.
start cmd /k

:: Check the exit code of the launch command
if !errorlevel! neq 0 (
    echo [****| Error launching terminal |****]
    echo [****| Exiting Launch Terminal. |****]
    pause
    goto menu
) else (
    echo [****| Step 1: Terminal launched successfully |****]
)

:: Return to the main menu after launching the terminal
goto launch_terminal_completed

:launch_terminal_completed
cls
echo [****| Terminal

 launched successfully |****]
pause
goto menu

:update_python_packages
cls
echo [****| Updating Python Packages |****]

:: Step 1: Update Python packages
echo [****| Step 1: Updating Python packages |****]
:: Using 'pip' to update Python and related packages.
python -m pip install --upgrade pip
python -m pip install --upgrade setuptools

:: Check the exit code of the Python package update command
if !errorlevel! neq 0 (
    echo [****| Error updating Python packages |****]
    echo [****| Exiting Update Python Packages. |****]
    pause
    goto menu
) else (
    echo [****| Step 1: Python packages updated successfully |****]
)

:: Return to the main menu after update is complete
goto update_python_packages_completed

:update_python_packages_completed
cls
echo [****| Python Packages updated successfully |****]
pause
goto menu