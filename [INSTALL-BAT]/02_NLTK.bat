@echo off

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python first.
    pause
    exit /b
)

:: Install NLTK
echo Installing NLTK...
python -m pip install nltk

:: Check if NLTK installation was successful
python -c "import nltk" >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to install NLTK.
    pause
    exit /b
)

:: Download NLTK packages
echo Downloading NLTK packages...
python -m nltk.downloader punkt
python -m nltk.downloader averaged_perceptron_tagger

echo NLTK installation and packages download complete.
pause
