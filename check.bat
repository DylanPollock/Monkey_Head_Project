@echo off
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume

echo [****Checking GenCore System Components****]

:: Check if Docker Image Exists
echo Checking if Docker Image %IMAGE_NAME% exists...
docker images | findstr /i "%IMAGE_NAME%"
if %errorlevel% neq 0 (
    echo [****Docker Image %IMAGE_NAME% does not exist.****]
) else (
    echo [****Docker Image %IMAGE_NAME% exists.****]
)

:: Check if Docker Container Exists and is Running
echo Checking if Docker Container %CONTAINER_NAME% exists and is running...
docker ps -a | findstr /i "%CONTAINER_NAME%"
if %errorlevel% neq 0 (
    echo [****Docker Container %CONTAINER_NAME% does not exist or is not running.****]
) else (
    echo [****Docker Container %CONTAINER_NAME% is up and running.****]
)

:: Check if Docker Volume Exists
echo Checking if Docker Volume %VOLUME_NAME% exists...
docker volume inspect %VOLUME_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo [****Docker Volume %VOLUME_NAME% does not exist.****]
) else (
    echo [****Docker Volume %VOLUME_NAME% exists.****]
)

echo [****GenCore System Check Completed****]
pause