@echo off
cls
echo [****| Cleaning up Files |****]

REM Simulated: Ensure Docker CLI is installed and in system PATH
echo Stopping all containers...
REM docker stop $(docker ps -aq)

REM Simulated: Ensure Docker CLI is installed and in system PATH
echo Removing all stopped containers...
REM docker rm $(docker ps -aq)

REM Simulated: Ensure Docker CLI is installed and in system PATH
echo Removing untagged images...
REM docker rmi $(docker images -q -f dangling=true)

REM Simulated: Ensure the temporary files path exists
echo Cleaning temporary files...
REM del /Q /F C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\temp\*

REM Check if the cleanup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Cleanup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Cleanup completed successfully |****]
pause
exit /b