@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-app
SET VOLUME_NAME=gencore-volume

echo [****Checking system prerequisites...****]
python --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Python is not installed on the host OS. Please install Python 3.12.0 or higher.****]
    exit /b 1
)
pip --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Pip is not installed on the host OS. Please install Pip.****]
    exit /b 1
)

echo [****Checking if Docker is running...****]
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Docker is not running. Please start Docker and try again.****]
    exit /b 1
)

echo [****Building or updating Docker Image...****]
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% || (
    echo [****Error: Failed to build or update Docker Image.****]
    exit /b 1
)

echo [****Ensuring Docker Volume exists...****]
docker volume inspect %VOLUME_NAME% > NUL 2>&1 || docker volume create %VOLUME_NAME%

echo [****Managing Docker Container...****]
docker container inspect %CONTAINER_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Creating and starting Docker Container...****]
    docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data -v %PROJECT_PATH%:/GenCore --restart unless-stopped %IMAGE_NAME% || (
        echo [****Error: Failed to create and start Docker Container.****]
        exit /b 1
    )
) else (
    echo [****Updating and restarting existing Docker Container...****]
    docker stop %CONTAINER_NAME% && docker rm %CONTAINER_NAME%
    docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data -v %PROJECT_PATH%:/GenCore --restart unless-stopped %IMAGE_NAME% || (
        echo [****Error: Failed to update and restart Docker Container.****]
        exit /b 1
    )
)

echo [****Verifying Python environment inside Docker Container...****]
docker exec %CONTAINER_NAME% python --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Python is not correctly installed inside the Docker Container.****]
    exit /b 1
)

echo [****All operations completed successfully.****]
pause