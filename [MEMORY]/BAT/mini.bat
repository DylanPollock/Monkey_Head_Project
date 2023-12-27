@echo off
SET PROJECT_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject
SET IMAGE_NAME=mini-image
SET CONTAINER_NAME=mini-container

echo [****Building Docker Image (Mini Install)...****]
docker build -t %IMAGE_NAME% %PROJECT_PATH%

echo [****Running Docker Container (Mini Install)...****]
docker run -d --name %CONTAINER_NAME% %IMAGE_NAME%

echo [****All operations completed. (Mini Install)****]
pause