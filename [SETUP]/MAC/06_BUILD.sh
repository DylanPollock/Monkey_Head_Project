#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     06_BUILD.sh - Project Build Script   |****]\033[0m"
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

# Function to check for required environment variables
checkEnvVars() {
    echo "Checking for required environment variables..."
    # Uncomment and modify the following lines to check for specific environment variables
    # if [ -z "$MY_ENV_VAR" ]; then
    #     echo "Error: Environment variable MY_ENV_VAR not set."
    #     logError "Environment variable MY_ENV_VAR not set"
    #     exit 1
    # fi
}

# Function to install required build tools
installBuildTools() {
    echo "Installing required build tools..."
    # Uncomment and modify the following lines to install additional build tools
    # sudo apt-get install -y maven
    # checkError "Maven Installation"
    # sudo apt-get install -y gradle
    # checkError "Gradle Installation"
    # sudo apt-get install -y msbuild
    # checkError "MSBuild Installation"
}

# Function to clean the project
cleanProject() {
    echo "Cleaning project..."
    # Add commands to clean the project
    # For example, for a Node.js project:
    # npm run clean
    checkError "Project Clean"
}

# Function to install project dependencies
installDependencies() {
    echo "Installing project dependencies..."
    # Add commands to install project dependencies
    # For example, for a Node.js project:
    # npm install
    # For a Python project:
    # pip install -r requirements.txt
    checkError "Installing Dependencies"
}

# Function to compile the project
compileProject() {
    echo "Compiling project..."
    # Add commands to compile the project
    # For example, for a Java project with Maven:
    # mvn compile
    checkError "Project Compile"
}

# Function to run tests
runTests() {
    echo "Running tests..."
    # Add commands to run tests
    # For example, for a Python project with pytest:
    # pytest
    checkError "Tests Run"
}

# Function to generate documentation
generateDocs() {
    echo "Generating documentation..."
    # Add commands to generate documentation
    # For example, for a Python project with Sphinx:
    # sphinx-build -b html docs/source docs/build
    checkError "Documentation Generation"
}

# Function to package the application
packageApp() {
    echo "Packaging application..."
    # Add commands to package the application
    # For example, for a Node.js project:
    # npm run build
    checkError "Application Packaging"
}

# Function to deploy the application (Optional)
deployApp() {
    echo "Deploying application..."
    # Add commands to deploy the application
    # For example, deploying to a cloud service:
    # aws s3 cp build/ s3://your-bucket-name/ --recursive
    checkError "Application Deployment"
}

# Function to clean up after build (Optional)
postBuildCleanup() {
    echo "Cleaning up after build..."
    # Add commands to clean up after the build
    # For example, removing temporary files:
    # rm -rf temp/*
    checkError "Post Build Cleanup"
}

# Function to log build steps
logBuildStep() {
    echo "Logging build step: $1"
    echo "$(date) - $1" >> build_log.txt
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Check for required environment variables
checkEnvVars

# Install required build tools
installBuildTools

# Log build step
logBuildStep "Clean Project"

# Clean the project
cleanProject

# Log build step
logBuildStep "Install Dependencies"

# Install project dependencies
installDependencies

# Log build step
logBuildStep "Compile Project"

# Compile the project
compileProject

# Log build step
logBuildStep "Run Tests"

# Run tests
runTests

# Log build step
logBuildStep "Generate Documentation"

# Generate documentation
generateDocs

# Log build step
logBuildStep "Package Application"

# Package the application
packageApp

# Log build step
logBuildStep "Deploy Application"

# Deploy the application (Optional)
deployApp

# Log build step
logBuildStep "Post Build Cleanup"

# Clean up after build (Optional)
postBuildCleanup

echo -e "\033[0;32m[****| Build complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/error_log.txt"
