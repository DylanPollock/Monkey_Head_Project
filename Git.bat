@echo off

REM Check if Git is installed
git --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo Git is not installed. Please install Git before running this script.
    pause
    exit /b
)

REM Check for network connectivity
ping -n 1 github.com >nul 2>&1
IF ERRORLEVEL 1 (
    echo No network connection detected. Please check your connection and try again.
    pause
    exit /b
)

REM Get the directory from which the script is being run
SET targetDir=%~dp0

REM Set the subdirectory name where the repository will be cloned
SET subDir=pygpt-net-repo

REM Set the repository URL for the submodule
SET repoURL=https://github.com/username/repo-name.git

REM Combine the target directory and subdirectory
SET fullDir=%targetDir%%subDir%

REM Check if the subdirectory exists
IF NOT EXIST "%fullDir%" (
    echo Subdirectory "%subDir%" does not exist. Creating it now...
    mkdir "%fullDir%"
) ELSE (
    echo Subdirectory "%subDir%" exists.
)

REM Check if the subdirectory is empty
FOR /F "usebackq" %%A IN (`dir /b "%fullDir%"`) DO SET nonEmpty=1

IF DEFINED nonEmpty (
    echo The subdirectory "%subDir%" is not empty.
) ELSE (
    echo The subdirectory "%subDir%" is empty. Cloning the repository...
    cd "%fullDir%"
    git clone "%repoURL%" . > clone_log.txt 2>&1
    IF ERRORLEVEL 1 (
        echo Failed to clone the repository. Please check the repository URL or your permissions.
        pause
        exit /b
    )
    echo Repository has been cloned into the subdirectory "%subDir%".
)

REM Optional: Check for updates to the Git repository
cd "%fullDir%"
git fetch --all > fetch_log.txt 2>&1
git pull > pull_log.txt 2>&1
IF ERRORLEVEL 1 (
    echo Failed to fetch or pull updates. Please check your network connection and try again.
    pause
    exit /b
)

echo Operation completed successfully.
pause
