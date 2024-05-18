@echo off
cls
echo [****| Updating Python Packages |****]

REM Update pip and setuptools
python -m pip install --upgrade pip setuptools

REM Check if the update was successful
if %ERRORLEVEL% NEQ 0 (
    echo [****| Error: Updating Python Packages failed with error code %ERRORLEVEL%. |****]
    pause
    exit /b %ERRORLEVEL%
)

echo [****| Python Packages updated successfully |****]
pause
exit /b