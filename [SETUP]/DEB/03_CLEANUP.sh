#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color (only works in some terminals)
clear
echo -e "\033[0;32m[****|     03_CLEANUP.sh - Cleanup Development Environment   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/error_log.txt"
}

# Function to remove virtual environment
removeVirtualEnv() {
    echo "Removing virtual environment..."
    if [ -d "repository/venv" ]; then
        rm -rf "repository/venv"
        checkError "Removing Virtual Environment"
    else
        echo "No virtual environment found."
    fi
}

# Function to remove cloned repository
removeRepository() {
    echo "Removing cloned repository..."
    if [ -d "repository" ]; then
        rm -rf "repository"
        checkError "Removing Cloned Repository"
    else
        echo "No cloned repository found."
    fi
}

# Function to remove common directories (Optional)
removeDirectories() {
    echo "Removing common directories..."
    if [ -d "$HOME/Projects" ]; then
        rm -rf "$HOME/Projects"
        checkError "Removing Projects Directory"
    else
        echo "No Projects directory found."
    fi
    if [ -d "$HOME/Tools" ]; then
        rm -rf "$HOME/Tools"
        checkError "Removing Tools Directory"
    else
        echo "No Tools directory found."
    fi
}

# Function to clear environment variables (Optional)
clearEnvVariables() {
    echo "Clearing environment variables..."
    # Uncomment and modify the following line to clear specific environment variables
    # unset PATH
}

# Function to remove temporary files
removeTempFiles() {
    echo "Removing temporary files..."
    rm -rf /tmp/*
    checkError "Removing Temp Files"
}

# Function to clear npm cache
clearNpmCache() {
    echo "Clearing npm cache..."
    npm cache clean --force
    checkError "Clearing NPM Cache"
}

# Function to clear pip cache
clearPipCache() {
    echo "Clearing pip cache..."
    pip cache purge
    checkError "Clearing Pip Cache"
}

# Function to remove Docker containers, images, and volumes (Optional)
cleanupDocker() {
    echo "Cleaning up Docker..."
    docker system prune -a -f --volumes
    checkError "Cleaning Up Docker"
}

# Main Execution Flow
echo "Ensuring script runs with administrative privileges..."
ensureAdmin

echo "Removing virtual environment..."
removeVirtualEnv

echo "Removing cloned repository..."
removeRepository

echo "Removing common directories (Optional)..."
removeDirectories

echo "Clearing environment variables (Optional)..."
clearEnvVariables

echo "Removing temporary files..."
removeTempFiles

echo "Clearing npm cache..."
clearNpmCache

echo "Clearing pip cache..."
clearPipCache

echo "Cleaning up Docker (Optional)..."
cleanupDocker

echo -e "\033[0;32m[****| Cleanup complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/error_log.txt"
