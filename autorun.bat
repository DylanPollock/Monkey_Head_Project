@echo off
echo [**** Welcome to the GenCore Deployment Process ****]

:start
:: Interactive Menu for AI/OS Actions
:menu
echo.
echo [** Select an action: **]
echo [** 1. Full Automatic Setup **]
echo [** 2. Mini Setup **]
echo [** 3. Perform System Checks **]
echo [** 4. Exit Program **]
set /p action="Please select an option (1-4): "

if "%action%"=="1" call "C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\setup.bat"
if "%action%"=="2" call "C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\mini.bat"
if "%action%"=="3" call "C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\check.bat"
if "%action%"=="4" goto end
echo [* Invalid Selection. Please choose a valid option. *]
goto menu

:end
echo [**** Exiting GenCore Deployment Process. ****]
pause
exit /b

