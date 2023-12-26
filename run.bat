@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-app
SET VOLUME_NAME=gencore-volume

echo Checking if Docker is running...
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Error: Docker is not running. Please start Docker and try again.****]
    exit /b 1
)

echo [****Checking if the Docker image already exists...****]
docker image inspect %IMAGE_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Building Docker Image...****]
    docker build -t %IMAGE_NAME% %PROJECT_PATH% || (
        echo [****Error: Failed to build Docker Image.****]
        exit /b 1
    )
) else (
    echo [****Docker Image already exists. Skipping build.****]
)

echo [****Checking if the Docker volume exists...****]
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Creating Docker Volume...****]
    docker volume create %VOLUME_NAME%
)

echo [****Checking if the Docker container already exists...****]
docker container inspect %CONTAINER_NAME% > NUL 2>&1
if %errorlevel% neq 0 (
    echo [****Running Docker Container...****]
    docker run -d --name %CONTAINER_NAME% -v %VOLUME_NAME%:/data -v %PROJECT_PATH%:/GenCore --restart unless-stopped %IMAGE_NAME% || (
        echo [****Error: Failed to run Docker Container.****]
        exit /b 1
    )
) else (
    echo [****Docker Container already exists. Checking if it's running...****]
    SET RUNNING=0
    FOR /f "tokens=*" %%i IN ('docker inspect -f "{{.State.Running}}" %CONTAINER_NAME%') DO SET RUNNING=%%i
    if "!RUNNING!"=="true" (
        echo [****Docker Container is already running.****]
    ) else (
        echo [****Starting existing Docker Container...****]
        docker start %CONTAINER_NAME% || (
            echo [****Error: Failed to start Docker Container.****]
            exit /b 1
        )
    )
)

echo [****All operations completed successfully.****]
pause