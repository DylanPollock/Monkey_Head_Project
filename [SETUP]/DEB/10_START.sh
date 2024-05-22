#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     10_START.sh - Start Services and Applications   |****]\033[0m"
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
    echo "$(date) - Error: $1 failed with error code $?" >> "$(dirname "$0")/start_error_log.txt"
}

# Function to start Docker service
startDocker() {
    echo "Starting Docker service..."
    sudo systemctl start docker
    if [ $? -ne 0 ]; then
        echo "Docker service is already running."
    else
        checkError "Starting Docker Service"
    fi
}

# Function to check Docker service status
checkDockerStatus() {
    echo "Checking Docker service status..."
    sudo systemctl is-active --quiet docker
    if [ $? -ne 0 ]; then
        echo "Docker service is not running. Attempting to start..."
        startDocker
    else
        echo "Docker service is running."
    fi
}

# Function to start Minikube
startMinikube() {
    echo "Starting Minikube..."
    minikube start
    checkError "Starting Minikube"
}

# Function to check Minikube status
checkMinikubeStatus() {
    echo "Checking Minikube status..."
    minikube status > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Minikube is not running. Attempting to start..."
        startMinikube
    else
        echo "Minikube is running."
    fi
}

# Function to start application services
startAppServices() {
    echo "Starting application services..."
    # Add commands to start application services
    # For example:
    docker-compose up -d
    checkError "Starting Application Services"
}

# Function to check application services status
checkAppServicesStatus() {
    echo "Checking application services status..."
    docker-compose ps | grep "Up" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Application services are not running. Attempting to start..."
        startAppServices
    else
        echo "Application services are running."
    fi
}

# Function to start database service (if applicable)
startDatabase() {
    echo "Starting database service..."
    # Add commands to start database service
    # For example:
    # sudo systemctl start mysql
    checkError "Starting Database Service"
}

# Function to check database service status
checkDatabaseStatus() {
    echo "Checking database service status..."
    # Add commands to check database service status
    # For example:
    # sudo systemctl is-active --quiet mysql
    if [ $? -ne 0 ]; then
        echo "Database service is not running. Attempting to start..."
        startDatabase
    else
        echo "Database service is running."
    fi
}

# Function to start web server (if applicable)
startWebServer() {
    echo "Starting web server..."
    # Add commands to start web server
    # For example:
    # sudo systemctl start apache2
    checkError "Starting Web Server"
}

# Function to check web server status
checkWebServerStatus() {
    echo "Checking web server status..."
    # Add commands to check web server status
    # For example:
    # sudo systemctl is-active --quiet apache2
    if [ $? -ne 0 ]; then
        echo "Web server is not running. Attempting to start..."
        startWebServer
    else
        echo "Web server is running."
    fi
}

# Function to open application in browser (optional)
openBrowser() {
    echo "Opening application in web browser..."
    # Add command to open application in default web browser
    # For example:
    xdg-open http://localhost
}

# Function to log startup steps
logStartupStep() {
    echo "Logging startup step: $1"
    echo "$(date) - $1" >> start_log.txt
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Check Docker service status
checkDockerStatus

# Log startup step
logStartupStep "Checking Minikube Status"

# Check Minikube status
checkMinikubeStatus

# Log startup step
logStartupStep "Checking Application Services Status"

# Check application services status
checkAppServicesStatus

# Log startup step
logStartupStep "Checking Database Service Status"

# Check database service status (if applicable)
checkDatabaseStatus

# Log startup step
logStartupStep "Checking Web Server Status"

# Check web server status (if applicable)
checkWebServerStatus

# Log startup step
logStartupStep "Opening Browser"

# Open application in web browser (optional)
openBrowser

echo -e "\033[0;32m[****| All services and applications started successfully! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/start_error_log.txt"