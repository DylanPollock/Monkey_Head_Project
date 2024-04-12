@echo off
echo [****Performing System Checks...****]

:: Check Docker Volume
docker volume inspect %VOLUME_NAME% > nul 2>&1
if %errorlevel% neq 0 (
    echo Fail: Volume %VOLUME_NAME% not found
    goto checkEnd
)

:: Check Docker Container
docker inspect %CONTAINER_NAME% > nul 2>&1
if %errorlevel% neq 0 (
    echo Fail: Container %CONTAINER_NAME% not found or not running
    goto checkEnd
)

:: Retrieve and display the container logs for debugging
echo Checking container logs for further insights...
docker logs %CONTAINER_NAME%

echo System checks completed. Review log output for errors.

:checkEnd
pause
exit /b