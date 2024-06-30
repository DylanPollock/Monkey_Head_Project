#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color (only works in some terminals)
clear
echo -e "\033[0;32m[****|     02_MINI.sh - Minimal Development Environment Setup   |****]\033[0m"
echo

# Function to ensure the script is running with administrative privileges
ensureAdmin() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as an administrator."
        exit 1
    fi
}

# Function to check the last command and exit if it failed
checkError() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed with error code $?."
        logError "$1"
        exit 1
    fi
}

# Function to log errors
logError() {
    echo "$(date) - Error: $1 failed with error code $?" >> error_log.txt
}

# Function to perform initial system checks
systemCheck() {
    echo "Performing system checks..."
    # Check for macOS version
    sw_vers -productVersion | grep "10.15" > /dev/null
    checkError "macOS 10.15 Check"
    # Check for available disk space
    FreeSpace=$(df / | tail -1 | awk '{print $4}')
    echo "Free space on /: $FreeSpace KB"
    # Check for internet connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: No internet connection detected."
        logError "Internet Connectivity Check"
        exit 1
    fi
    # Check for required software
    which git > /dev/null 2>&1
    checkError "Git Availability Check"
}

# Function to install necessary packages using Homebrew
installBrewPackages() {
    echo "Installing necessary packages..."
    brew update && brew install git node python3
    checkError "Homebrew Packages Installation"
}

# Function to clone the repository
cloneRepository() {
    echo "Cloning repository..."
    if [ ! -d "$HOME/Source" ]; then
        mkdir -p "$HOME/Source"
    fi
    cd "$HOME/Source"
    git clone https://github.com/example/repository.git
    checkError "Git Clone"
}

# Function to set up Python environment
setupPythonEnv() {
    echo "Setting up Python environment..."
    cd "$HOME/Source/repository"
    python3 -m venv venv
    checkError "Python Virtual Environment Setup"
    source venv/bin/activate
    checkError "Activate Python Virtual Environment"
    pip install --upgrade pip
    checkError "Upgrading pip"
    pip install -r requirements.txt
    checkError "Installing Python Dependencies"
}

# Function to configure Git
configureGit() {
    echo "Configuring Git..."
    git config --global user.name "Your Name"
    checkError "Git Config Username"
    git config --global user.email "your.email@example.com"
    checkError "Git Config Email"
}

# Function to create common directories
createDirectories() {
    echo "Creating common directories..."
    mkdir -p "$HOME/Projects"
    checkError "Creating Projects Directory"
    mkdir -p "$HOME/Tools"
    checkError "Creating Tools Directory"
}

# Function to update environment variables (Optional)
updateEnvVariables() {
    echo "Updating environment variables..."
    export PATH="$PATH:$HOME/Tools"
    checkError "Updating PATH Environment Variable"
}

# Function to perform additional optional setup tasks (Optional)
additionalSetup() {
    echo "Performing additional setup tasks..."
    # Uncomment the tasks you need
    # echo "Installing Python packages..."
    # pip install some-package
    # checkError "Python Package Installation"
    # echo "Configuring additional settings..."
    # Add additional configuration commands here
}

# Main Execution Flow
echo "Ensuring script runs with administrative privileges..."
ensureAdmin

echo "Performing initial system checks..."
systemCheck

echo "Installing necessary packages..."
installBrewPackages

echo "Cloning the repository..."
cloneRepository

echo "Setting up Python environment..."
setupPythonEnv

echo "Configuring Git..."
configureGit

echo "Creating common directories..."
createDirectories

echo "Updating environment variables..."
updateEnvVariables

echo "Performing additional optional setup tasks..."
additionalSetup

echo -e "\033[0;32m[****| Minimal setup complete! |****]\033[0m"