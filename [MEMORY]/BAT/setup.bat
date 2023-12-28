@echo off
echo [**** Starting Full Automatic Setup of GenCore Project ****]

:: Define environment variables
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume
SET CONTAINER_NAME=gencore-container

:: Step 1: Create Docker Volume
echo [**** Step 1: Creating Docker Volume ****]
docker volume create %VOLUME_NAME%

:: Step 2: Build Docker Image
echo [**** Step 2: Building Docker Image ****]
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH%

:: Error handling if Docker build fails
if %errorlevel% neq 0 (
    echo [**** Error: Docker Image Build Failed ****]
    pause
    exit /b
)

:: Step 3: Run Docker Container
echo [**** Step 3: Running Docker Container ****]
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data %IMAGE_NAME%

:: Error handling if Docker run fails
if %errorlevel% neq 0 (
    echo [**** Error: Docker Container Run Failed ****]
    pause
    exit /b
)

echo [**** Full Automatic Setup Completed Successfully ****]
pause
exit /b