#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     07_CONTAINER.sh - Docker Container Management   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/docker_error_log.txt"
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

# Function to build Docker image
buildDockerImage() {
    echo "Building Docker image..."
    # Add the command to build the Docker image
    # For example:
    docker build -t myapp:latest .
    checkError "Docker Image Build"
}

# Function to run Docker container
runDockerContainer() {
    echo "Running Docker container..."
    # Add the command to run the Docker container
    # For example:
    docker run -d -p 80:80 --name myapp_container myapp:latest
    checkError "Docker Container Run"
}

# Function to stop Docker container
stopDockerContainer() {
    echo "Stopping Docker container..."
    # Add the command to stop the Docker container
    # For example:
    docker stop myapp_container
    checkError "Docker Container Stop"
}

# Function to remove Docker container
removeDockerContainer() {
    echo "Removing Docker container..."
    # Add the command to remove the Docker container
    # For example:
    docker rm myapp_container
    checkError "Docker Container Remove"
}

# Function to manage Docker volumes (Optional)
manageDockerVolumes() {
    echo "Managing Docker volumes..."
    # Add commands to manage Docker volumes
    # For example, to create a volume:
    # docker volume create myapp_data
    # To remove a volume:
    # docker volume rm myapp_data
}

# Function to manage Docker networks (Optional)
manageDockerNetworks() {
    echo "Managing Docker networks..."
    # Add commands to manage Docker networks
    # For example, to create a network:
    # docker network create myapp_network
    # To remove a network:
    # docker network rm myapp_network
}

# Function to log Docker steps
logDockerStep() {
    echo "Logging Docker step: $1"
    echo "$(date) - $1" >> docker_log.txt
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Install Docker if not already installed
installDocker

# Start Docker service
startDocker

# Check Docker daemon status
checkDockerDaemon

# Log Docker step
logDockerStep "Build Docker Image"

# Build Docker image
buildDockerImage

# Log Docker step
logDockerStep "Run Docker Container"

# Run Docker container
runDockerContainer

# Log Docker step
logDockerStep "Manage Docker Volumes"

# Manage Docker volumes (Optional)
manageDockerVolumes

# Log Docker step
logDockerStep "Manage Docker Networks"

# Manage Docker networks (Optional)
manageDockerNetworks

# Log Docker step
logDockerStep "Stop Docker Container"

# Stop Docker container (Optional)
stopDockerContainer

# Log Docker step
logDockerStep "Remove Docker Container"

# Remove Docker container (Optional)
removeDockerContainer

echo -e "\033[0;32m[****| Docker container management complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/docker_error_log.txt"
