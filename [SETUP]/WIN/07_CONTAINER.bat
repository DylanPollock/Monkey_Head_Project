@echo off
cls
echo [****| Creating Container |****]

REM Create a new Docker container from the gencore-image
docker run -d --name gencore-container -p 80:80 gencore-image

REM Check if the container was created successfully
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Container creation failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Container created successfully |****]
pause
exit /b
