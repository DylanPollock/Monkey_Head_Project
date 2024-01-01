@echo off
cls
echo [****| Starting GenCore System |****]

REM Command to start the gencore.py Python script
start /b python C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\[PYTHON]\FUNCTIONS\gencore.py

REM Check if the GenCore System was started successfully
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: GenCore System start failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| GenCore System started successfully |****]
pause
exit /b
