#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     08_VOLUME.sh - Docker Volume Management   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/volume_error_log.txt"
}

# Function to install Docker if not already installed
installDocker() {
    echo "Checking for Docker installation..."
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        checkError "Docker Installation"
    else
        echo "Docker is already installed."
    fi
}

# Function to start Docker service
startDocker() {
    echo "Starting Docker service..."
    sudo systemctl start docker
    checkError "Starting Docker Service"
}

# Function to check Docker daemon status
checkDockerDaemon() {
    echo "Checking Docker daemon status..."
    if ! sudo systemctl is-active --quiet docker; then
        echo "Docker daemon is not running. Attempting to start..."
        sudo systemctl start docker
        sleep 10
        if ! sudo systemctl is-active --quiet docker; then
            echo "Error: Docker daemon failed to start."
            checkError "Starting Docker Daemon"
        else
            echo "Docker daemon started successfully."
        fi
    else
        echo "Docker daemon is running."
    fi
}

# Function to create a Docker volume
createVolume() {
    read -p "Enter the name of the volume to create: " volumeName
    if [ -z "$volumeName" ]; then
        echo "Volume name cannot be empty."
        exit 1
    fi
    echo "Creating Docker volume $volumeName..."
    docker volume create "$volumeName"
    checkError "Creating Docker Volume"
}

# Function to list all Docker volumes
listVolumes() {
    echo "Listing all Docker volumes..."
    docker volume ls
    checkError "Listing Docker Volumes"
}

# Function to inspect a Docker volume
inspectVolume() {
    read -p "Enter the name of the volume to inspect: " volumeName
    if [ -z "$volumeName" ]; then
        echo "Volume name cannot be empty."
        exit 1
    fi
    echo "Inspecting Docker volume $volumeName..."
    docker volume inspect "$volumeName"
    checkError "Inspecting Docker Volume"
}

# Function to remove a Docker volume
removeVolume() {
    read -p "Enter the name of the volume to remove: " volumeName
    if [ -z "$volumeName" ]; then
        echo "Volume name cannot be empty."
        exit 1
    fi
    echo "Removing Docker volume $volumeName..."
    docker volume rm "$volumeName"
    checkError "Removing Docker Volume"
}

# Function to prune unused Docker volumes
pruneVolumes() {
    echo "Pruning unused Docker volumes..."
    docker volume prune -f
    checkError "Pruning Docker Volumes"
}

# Function to back up a Docker volume (Optional)
backupVolume() {
    read -p "Enter the name of the volume to back up: " volumeName
    if [ -z "$volumeName" ]; then
        echo "Volume name cannot be empty."
        exit 1
    fi
    read -p "Enter the backup directory path: " backupDir
    if [ -z "$backupDir" ]; then
        echo "Backup directory cannot be empty."
        exit 1
    fi
    echo "Backing up Docker volume $volumeName to $backupDir..."
    docker run --rm -v "$volumeName:/volume" -v "$backupDir:/backup" alpine tar czf /backup/"$volumeName".tar.gz -C /volume .
    checkError "Backing Up Docker Volume"
}

# Function to restore a Docker volume (Optional)
restoreVolume() {
    read -p "Enter the name of the volume to restore: " volumeName
    if [ -z "$volumeName" ]; then
        echo "Volume name cannot be empty."
        exit 1
    fi
    read -p "Enter the backup file path: " backupFile
    if [ -z "$backupFile" ]; then
        echo "Backup file cannot be empty."
        exit 1
    fi
    echo "Restoring Docker volume $volumeName from $backupFile..."
    docker run --rm -v "$volumeName:/volume" -v "$backupFile:/backup" alpine sh -c "rm -rf /volume/* && tar xzf /backup/$(basename "$backupFile") -C /volume"
    checkError "Restoring Docker Volume"
}

# Function to log volume management steps
logVolumeStep() {
    echo "Logging volume management step: $1"
    echo "$(date) - $1" >> volume_log.txt
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Install Docker if not already installed
installDocker

# Start Docker service
startDocker

# Check Docker daemon status
checkDockerDaemon

while true; do
    clear
    echo -e "\033[0;32m[****|     Docker Volume Management   |****]\033[0m"
    echo "[1] Create a Docker Volume"
    echo "[2] List Docker Volumes"
    echo "[3] Inspect a Docker Volume"
    echo "[4] Remove a Docker Volume"
    echo "[5] Prune Unused Docker Volumes"
    echo "[6] Back Up a Docker Volume"
    echo "[7] Restore a Docker Volume"
    echo "[E] Exit"
    echo
    read -p "Please select an option (1-7, E to exit): " action
    case "$action" in
        1) createVolume ;;
        2) listVolumes ;;
        3) inspectVolume ;;
        4) removeVolume ;;
        5) pruneVolumes ;;
        6) backupVolume ;;
        7) restoreVolume ;;
        [Ee]) break ;;
        *) echo "Invalid selection, please try again."
           sleep 2 ;;
    esac
done

echo -e "\033[0;32m[****| Docker volume management complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/volume_error_log.txt"