@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET IMAGE_NAME=gencore-image
SET CONTAINER_NAME=gencore-container
SET VOLUME_NAME=gencore-volume

echo Checking system prerequisites...
python --version > NUL 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or the version is incorrect.
    pause
    exit /b
) else (
    echo Python installation verified.
)

echo Verifying Docker status...
docker info > NUL 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker is not running or not installed.
    pause
    exit /b
) else (
    echo Docker is running and available.
)

echo Building Docker image: %IMAGE_NAME%...
docker build --no-cache -t %IMAGE_NAME% %PROJECT_PATH% > build.log
if %errorlevel% neq 0 (
    echo Build Error: See build.log for details.
    type build.log
    pause
    exit /b
) else (
    echo Docker image %IMAGE_NAME% built successfully.
)

echo Creating/Verifying persistent volume: %VOLUME_NAME%...
docker volume inspect %VOLUME_NAME% > NUL 2>&1 || docker volume create %VOLUME_NAME%
if %errorlevel% neq 0 (
    echo Error: Failed to create or verify Docker volume.
    pause
    exit /b
) else (
    echo Docker volume %VOLUME_NAME% is ready.
)

echo Running Docker container: %CONTAINER_NAME%...
docker run -d --name %CONTAINER_NAME% -p 4848:4848 -v %VOLUME_NAME%:/gencore/data %IMAGE_NAME%
if %errorlevel% neq 0 (
    echo Run Error: Failed to start Docker container.
    pause
    exit /b
) else (
    echo Docker container %CONTAINER_NAME% is running.
)

echo Setup completed successfully.
pause