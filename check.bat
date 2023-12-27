@echo off
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container

echo [**** Performing System Checks... ****]

:: Check Docker Installation
docker --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo Fail: Docker not installed
    goto checkEnd
)

:: Check Docker Running Status
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo Fail: Docker not running
    goto checkEnd
)

:: Check Docker Volume
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo Fail: Volume %VOLUME_NAME% not found
    goto checkEnd
)

:: Check Docker Image
docker images | findstr /i "%IMAGE_NAME%" > NUL
if %errorlevel% neq 0 (
    echo Fail: Image %IMAGE_NAME% not found
    goto checkEnd
)

:: Check Docker Container
docker ps -a | findstr /i "%CONTAINER_NAME%" > NUL
if %errorlevel% neq 0 (
    echo Fail: Container %CONTAINER_NAME% not found or not running
    goto checkEnd
)

echo Pass
:checkEnd
pause
exit /b