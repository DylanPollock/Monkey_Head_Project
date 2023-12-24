@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=GenCore-app

echo Checking if Docker is running...
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo Docker is not running. Please start Docker and try again.
    exit /b 1
)

echo Checking if the container already exists...
docker ps -a | findstr /I %CONTAINER_NAME% > NUL
if %errorlevel% equ 0 (
    echo Found existing container. Attempting to start...
    docker start %CONTAINER_NAME%
    exit /b 0
)

echo Building Docker Image...
docker build -t %IMAGE_NAME% %PROJECT_PATH%

echo Running Docker Container...
docker run -d --name %CONTAINER_NAME% -v %PROJECT_PATH%:/GenCore %IMAGE_NAME%

echo Done.