@echo off
cls
echo [****| Updating Python Packages |****]
python -m pip install --upgrade pip setuptools
echo [****| Python Packages updated successfully |****]
pause
exit /b
