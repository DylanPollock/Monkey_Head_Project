@echo off
SET PYTHON_IMAGE=python:3.11
SET DEBIAN_IMAGE=debian:trixie
SET SAVE_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\memory\TEMP

echo Pulling Debian and Python Docker images...
docker pull %PYTHON_IMAGE%
docker pull %DEBIAN_IMAGE%

echo Saving images to %SAVE_PATH%...
if not exist "%SAVE_PATH%" mkdir "%SAVE_PATH%"
docker save %PYTHON_IMAGE% > "%SAVE_PATH%\python-3.11.tar"
docker save %DEBIAN_IMAGE% > "%SAVE_PATH%\debian-bookworm.tar"

echo Images saved successfully.

pip download -r C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\requirements.txt -d C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\memory\TEMP
pause