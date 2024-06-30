#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     05_UPDATE.sh - Update Installed Packages and Tools   |****]\033[0m"
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

# Function to update the system itself
updateSystem() {
    echo "Updating system..."
    sudo apt update && sudo apt upgrade -y
    checkError "System Update"
}

# Function to update npm global packages
updateNpmPackages() {
    echo "Updating npm global packages..."
    npm update -g
    checkError "NPM Global Packages Update"
}

# Function to update pip packages
updatePipPackages() {
    echo "Updating pip packages..."
    python3 -m pip install --upgrade pip
    checkError "Pip Update"
    outdated=$(pip list --outdated --format=freeze | grep -v "^\-e")
    for pkg in $outdated; do
        python3 -m pip install -U "${pkg%%=*}"
        checkError "Pip Packages Update"
    done
}

# Function to update VSCode extensions
updateVSCodeExtensions() {
    echo "Updating VSCode extensions..."
    extensions=$(code --list-extensions)
    for ext in $extensions; do
        code --install-extension "$ext"
        checkError "VSCode Extensions Update"
    done
}

# Function to update PowerShell modules
updatePSModules() {
    echo "Updating PowerShell modules..."
    pwsh -Command "Get-InstalledModule | ForEach-Object { Update-Module -Name \$_ -Force }"
    checkError "PowerShell Modules Update"
}

# Function to update Docker images
updateDockerImages() {
    echo "Updating Docker images..."
    images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")
    for img in $images; do
        docker pull "$img"
        checkError "Docker Images Update"
    done
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Update the system itself
updateSystem

# Update npm global packages
updateNpmPackages

# Update pip packages
updatePipPackages

# Update VSCode extensions
updateVSCodeExtensions

# Update PowerShell modules
updatePSModules

# Update Docker images
updateDockerImages

echo -e "\033[0;32m[****| Updates complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/error_log.txt"