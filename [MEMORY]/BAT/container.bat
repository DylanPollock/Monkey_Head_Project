@echo off
echo [**** Starting Container Launch Process ****]

:: Call the check script to perform system checks
call check.bat

:: Check if the last command (check.bat) executed successfully
if %errorlevel% neq 0 (
    echo [**** System Check Failed. Exiting... ****]
    exit /b
)

:: Define the container name
SET CONTAINER_NAME=gencore-container

:: Start the Docker Container
echo [**** Launching Docker Container... ****]
docker start %CONTAINER_NAME%

:: Error handling if Docker start fails
if %errorlevel% neq 0 (
    echo [**** Error: Failed to start Docker Container ****]
    pause
    exit /b
)

:: Open an interactive shell to the running container
echo [**** Opening Interactive Shell to Docker Container... ****]
docker exec -it %CONTAINER_NAME% /bin/bash

:: End of script
echo [**** Exiting Container Launch Process ****]
pause
exit /b