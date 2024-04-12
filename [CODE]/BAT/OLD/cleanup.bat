@echo off
echo [**** Starting Cleanup Process ****]

:: Define the path to temporary files
SET TEMP_PATH=C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\[MEMORY]\TEMP

:: Remove Temporary Files
echo [**** Removing Temporary Files... ****]
if exist "%TEMP_PATH%" (
    rmdir /s /q "%TEMP_PATH%"
    echo [**** Temporary Files Removed ****]
) else (
    echo [**** No Temporary Files to Remove ****]
)

:: Cleanup Docker Resources
echo [**** Cleaning Up Docker Resources... ****]
docker system prune -af --volumes

:: Check if Docker cleanup was successful
if %errorlevel% neq 0 (
    echo [**** Docker Cleanup Failed ****]
    pause
    exit /b
)

echo [**** Docker Cleanup Completed ****]

:: End of script
echo [**** Cleanup Process Completed ****]
pause
exit /b