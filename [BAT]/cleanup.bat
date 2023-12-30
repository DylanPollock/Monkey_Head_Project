@echo off
cls
echo [****| Cleaning up Files |****]

REM Stop all running containers
echo Stopping all containers...
docker stop $(docker ps -aq)

REM Remove all stopped containers
echo Removing all stopped containers...
docker rm $(docker ps -aq)

REM Remove all untagged images
echo Removing untagged images...
docker rmi $(docker images -q -f dangling=true)

REM Clean up any temporary files in the project directory
echo Cleaning temporary files...
del /Q /F C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\temp\*

REM Check if the cleanup was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Cleanup failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Cleanup completed successfully |****]
pause
exit /b
