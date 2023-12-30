@echo off
cls
echo [****| Performing Full Setup with Kubernetes |****]
call \MonkeyHeadProject\[BAT]\setup.bat
call \MonkeyHeadProject\[BAT]\kubernetes.bat
echo [****| Full Setup with Kubernetes completed |****]
pause
exit /b
