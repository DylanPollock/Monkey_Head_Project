#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     E_EXIT.sh - Shutdown and Cleanup   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/exit_error_log.txt"
}

# Function to stop Docker containers
stopDockerContainers() {
    echo "Stopping Docker containers..."
    for container_id in $(docker ps -q); do
        docker stop "$container_id" > /dev/null 2>&1
        checkError "Stopping Docker Container $container_id"
    done
}

# Function to remove Docker containers
removeDockerContainers() {
    echo "Removing Docker containers..."
    for container_id in $(docker ps -a -q); do
        docker rm "$container_id" > /dev/null 2>&1
        checkError "Removing Docker Container $container_id"
    done
}

# Function to stop Minikube
stopMinikube() {
    echo "Stopping Minikube..."
    if minikube status | grep -q "host: Running"; then
        minikube stop > /dev/null 2>&1
        checkError "Stopping Minikube"
    else
        echo "Minikube is not running."
    fi
}

# Function to stop application services
stopAppServices() {
    echo "Stopping application services..."
    if docker-compose ps > /dev/null 2>&1; then
        docker-compose down > /dev/null 2>&1
        checkError "Stopping Application Services"
    else
        echo "No application services to stop."
    fi
}

# Function to stop database service (if applicable)
stopDatabaseService() {
    echo "Stopping database service..."
    # Add commands to check and stop database service
    # For example:
    # if systemctl is-active --quiet mysql; then
    #     systemctl stop mysql
    #     checkError "Stopping MySQL Service"
    # else
    #     echo "MySQL service is not running."
    # fi
}

# Function to stop web server (if applicable)
stopWebServer() {
    echo "Stopping web server..."
    # Add commands to check and stop web server
    # For example:
    # if systemctl is-active --quiet apache2; then
    #     systemctl stop apache2
    #     checkError "Stopping Apache2 Web Server"
    # else
    #     echo "Apache2 web server is not running."
    # fi
}

# Function to clean up temporary files
cleanupTempFiles() {
    echo "Cleaning up temporary files..."
    rm -rf /tmp/*
    checkError "Cleaning Up Temporary Files"
}

# Function to log shutdown steps
logShutdownStep() {
    echo "Logging shutdown step: $1"
    echo "$(date) - $1" >> "$(dirname "$0")/exit_log.txt"
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Log shutdown step
logShutdownStep "Stopping Docker Containers"

# Stop Docker containers
stopDockerContainers

# Log shutdown step
logShutdownStep "Removing Docker Containers"

# Remove Docker containers
removeDockerContainers

# Log shutdown step
logShutdownStep "Stopping Minikube"

# Stop Minikube
stopMinikube

# Log shutdown step
logShutdownStep "Stopping Application Services"

# Stop application services
stopAppServices

# Log shutdown step
logShutdownStep "Stopping Database Service"

# Stop database service (if applicable)
stopDatabaseService

# Log shutdown step
logShutdownStep "Stopping Web Server"

# Stop web server (if applicable)
stopWebServer

# Log shutdown step
logShutdownStep "Cleaning Up Temporary Files"

# Clean up temporary files
cleanupTempFiles

echo -e "\033[0;32m[****| Shutdown and cleanup complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/exit_error_log.txt"