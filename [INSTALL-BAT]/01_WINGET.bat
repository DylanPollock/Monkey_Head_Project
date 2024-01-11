@echo off
setlocal enabledelayedexpansion

:: Check if Winget is installed
winget -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Winget is not detected. Installing the latest version...
    :: Add commands to install Winget here
    echo Winget installed successfully.
) else (
    echo Winget is already installed.
)

echo Installing applications from the Microsoft Store...

:: Install Windows Notepad
echo Installing Windows Notepad...
call winget install Microsoft.WindowsNotepad
if %errorlevel% neq 0 (
    echo Error: Failed to install Windows Notepad.
) else (
    echo Windows Notepad installed successfully.
)

:: Install Debian and Windows Subsystem for Linux
echo Installing Windows Subsystem for Linux...
call winget install Microsoft.WSL
if %errorlevel% neq 0 (
    echo Error: Failed to install Windows Subsystem for Linux.
) else (
    echo Windows Subsystem for Linux installed successfully.
    echo Installing Debian for WSL...
    call winget install Debian
    if %errorlevel% neq 0 (
        echo Error: Failed to install Debian.
    ) else (
        echo Debian installed successfully.
    )
)

:: Install Python 3.12
echo Installing Python 3.12...
call winget install Python.Python.3 --version 3.12
if %errorlevel% neq 0 (
    echo Error: Failed to install Python 3.12.
) else (
    echo Python 3.12 installed successfully.
)

:: Install Windows Terminal
echo Installing Windows Terminal...
call winget install Microsoft.WindowsTerminal
if %errorlevel% neq 0 (
    echo Error: Failed to install Windows Terminal.
) else (
    echo Windows Terminal installed successfully.
)

:: Install PowerShell
echo Installing PowerShell...
call winget install Microsoft.Powershell
if %errorlevel% neq 0 (
    echo Error: Failed to install PowerShell.
) else (
    echo PowerShell installed successfully.
)

echo All installations complete.
pause
