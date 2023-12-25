@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\GenCore
SET CONTAINER_NAME=gencore-container
SET IMAGE_NAME=gencore-image
SET VOLUME_NAME=gencore-volume

echo Checking if Dockerfile and run.bat exist...
if not exist "%PROJECT_PATH%\Dockerfile" (
    echo Dockerfile does not exist.
    exit /b 1
)
if not exist "%PROJECT_PATH%\run.bat" (
    echo run.bat does not exist.
    exit /b 1
)

echo Checking if Docker environment is set up...
docker inspect %CONTAINER_NAME% > NUL 2>&1
if errorlevel 1 (
    echo Docker container %CONTAINER_NAME% does not exist.
    exit /b 1
)
docker volume inspect %VOLUME_NAME% > NUL 2>&1
if errorlevel 1 (
    echo Docker volume %VOLUME_NAME% does not exist.
    exit /b 1
)
docker image inspect %IMAGE_NAME% > NUL 2>&1
if errorlevel 1 (
    echo Docker image %IMAGE_NAME% does not exist.
    exit /b 1
)

echo Updating system...
docker exec %CONTAINER_NAME% apt-get update && docker exec %CONTAINER_NAME% apt-get dist-upgrade -y

echo Checking Python packages...
docker exec %CONTAINER_NAME% apt-get install -y python3 python3-full python3-venv

echo Setting up virtual environment...
docker exec %CONTAINER_NAME% python3 -m venv /venv

echo Installing and updating libraries in virtual environment...
docker exec %CONTAINER_NAME% /bin/bash -c "source /venv/bin/activate && pip install --upgrade pip && pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U"

echo Launching into virtual environment...
docker exec -it %CONTAINER_NAME% /bin/bash -c "source /venv/bin/activate"

echo Installing pip in virtual environment...
docker exec %CONTAINER_NAME% /bin/bash -c "source /venv/bin/activate && pip install pip"
pause
