@echo off
cls
echo [****| Building Image |****]

REM Change to the directory where the Dockerfile is located
cd /d C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\

REM Build the Docker image
docker build -t gencore-image .

REM Check if the build was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Image build failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Image built successfully |****]
pause
exit /b
