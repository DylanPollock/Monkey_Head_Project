@echo off
setlocal enabledelayedexpansion
cls
color 0A
echo [****|     GenCore AI/OS Deployment    |****]
echo.

:: Full Setup
echo [****| Performing Full Setup |****]

:: Call Python script for setup operations
python GenCore.py
if %errorlevel% neq 0 (
    echo FAIL: GenCore setup failed.
    goto end
) else (
    echo PASS: GenCore setup completed successfully.
)

:end
echo [****| GenCore AI/OS Deployment Complete |****]
pause
exit /b

endlocal
