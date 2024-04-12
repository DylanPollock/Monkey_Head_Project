@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=gencore-mini-image
SET VOLUME_NAME=gencore-mini-volume
SET CONTAINER_NAME=gencore-mini-container

echo [****Welcome to the GenCore 'Mini' Deployment Process****]

:: Verifying Docker Installation and Running Status
echo [****Verifying Docker Installation and Status****]
docker --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo {*Docker is not installed. Please install Docker.*}
    exit /b 1
)
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo {*Docker is not running. Please start Docker.*}
    exit /b 1
)

:: Creating Docker Volume for Persistent Data
echo [****Creating Docker Volume for Persistent Data****]
docker volume create %VOLUME_NAME% > NUL

:: Building Docker Image
echo [****Building Docker Image...****]
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > NUL
if %errorlevel% neq 0 (
    echo {*Error: Failed to build Docker Image.*}
    exit /b 1
)

:: Running Docker Container
echo [****Running Docker Container...****]
docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/gencore %IMAGE_NAME% > NUL
if %errorlevel% neq 0 (
    echo {*Error: Failed to run Docker Container.*}
    exit /b 1
)

echo [****Docker Container with Volume Running****]
echo [****Mini Installation Complete!!****]
pause
exit /b
