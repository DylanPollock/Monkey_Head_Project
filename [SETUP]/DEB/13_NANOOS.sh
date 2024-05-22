#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     13_NANOOS.sh - NanoOS Setup and Configuration   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/nanoos_error_log.txt"
}

# Function to verify internet connectivity
verifyInternet() {
    echo "Verifying internet connectivity..."
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: No internet connectivity."
        logError "Internet Connectivity"
        exit 1
    else
        echo "Internet connectivity verified."
    fi
}

# Function to check if a software is installed
checkSoftware() {
    echo "Checking for $1 installation..."
    if ! command -v "$1" &> /dev/null; then
        echo "$1 is not installed. Installing $1..."
        eval "$2"
        checkError "Installing $1"
    else
        echo "$1 is already installed."
    fi
}

# Function to check software version
checkSoftwareVersion() {
    echo "Checking $1 version..."
    $1 --version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$1 version check failed."
        logError "$1 Version Check"
    else
        echo "$1 version:"
        $1 --version
    fi
}

# Function to install required software
installSoftware() {
    echo "Installing required software..."
    checkSoftware "git" "apt-get install -y git"
    checkSoftwareVersion "git"
    checkSoftware "node" "apt-get install -y nodejs"
    checkSoftwareVersion "node"
    # Add more software checks and installations as needed
}

# Function to configure system settings
configureSystem() {
    echo "Configuring system settings..."
    # Add commands to configure system settings
    # For example, setting environment variables:
    export NANOOS_ENV_VAR="NanoOSValue"
    checkError "Setting Environment Variables"
}

# Function to create necessary directories
createDirectories() {
    echo "Creating necessary directories..."
    # Add commands to create necessary directories
    # For example:
    mkdir -p "/NanoOSData"
    checkError "Creating Directories"
}

# Function to update the system
updateSystem() {
    echo "Updating the system..."
    apt-get update && apt-get upgrade -y
    checkError "Updating System"
}

# Function to clean up temporary files
cleanupTempFiles() {
    echo "Cleaning up temporary files..."
    rm -rf /tmp/*
    checkError "Cleaning Up Temporary Files"
}

# Function to restart necessary services
restartServices() {
    echo "Restarting necessary services..."
    # Add commands to restart necessary services
    # For example:
    # systemctl restart some-service
    checkError "Restarting Services"
}

# Function to check system health
checkSystemHealth() {
    echo "Checking system health..."
    # Add commands to check system health
    # For example, checking disk space:
    df -h
    checkError "Checking System Health"
}

# Function to log setup steps
logSetupStep() {
    echo "Logging setup step: $1"
    echo "$(date) - $1" >> "$(dirname "$0")/nanoos_log.txt"
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Verify internet connectivity
verifyInternet

# Log setup step
logSetupStep "Installing Software"

# Install required software
installSoftware

# Log setup step
logSetupStep "Configuring System Settings"

# Configure system settings
configureSystem

# Log setup step
logSetupStep "Creating Directories"

# Create necessary directories
createDirectories

# Log setup step
logSetupStep "Updating System"

# Update the system
updateSystem

# Log setup step
logSetupStep "Cleaning Up Temporary Files"

# Clean up temporary files
cleanupTempFiles

# Log setup step
logSetupStep "Restarting Services"

# Restart necessary services
restartServices

# Log setup step
logSetupStep "Checking System Health"

# Check system health
checkSystemHealth

echo -e "\033[0;32m[****| NanoOS setup and configuration complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/nanoos_error_log.txt"