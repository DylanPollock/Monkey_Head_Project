#!/bin/bash

# Function for Full Setup
full_setup() {
    echo "****|     Performing Full Setup   |****"
    
    # Check if Python is installed
    if ! command -v python3 &> /dev/null; then
        echo "****| Python is not installed. Please install Python. |****"
        exit 1
    else
        echo "****| Python is installed. |****"
    fi

    # Set environment variables
    export PROJECT=GenCore
    export ENVIRONMENT=Testing
    echo "****| Environment variables set successfully |****"

    # Install additional dependencies
    echo "****| Installing additional dependencies |****"
    sudo apt-get update
    sudo apt-get install -y build-essential git python3-pip python3-venv

    # Clone the GenCore repository
    echo "****| Cloning GenCore repository |****"
    git clone https://github.com/GenCore/GenCore.git

    # Install project-specific dependencies
    echo "****| Installing project-specific dependencies |****"
    cd GenCore
    python3 -m pip install -r requirements.txt

    # Build the project
    echo "****| Building the project |****"
    python3 setup.py build

    echo "****| Full Setup completed successfully |****"
}

# Function for 'Mini' Setup
mini_setup() {
    echo "****| Setting up 'Mini' Environment |****"
    
    # Install minimal necessary software
    python3 -m pip install requests beautifulsoup4 lxml

    # Configure specific settings
    export MINI_ENV_SETTING=Minimal

    echo "****| 'Mini' Environment Setup completed successfully |****"
}

# Function for Cleanup Files
cleanup_files() {
    echo "****| Cleaning up Files |****"
    
    # Cleanup commands
    rm -rf /tmp/*
    rm -rf ~/.cache/*

    echo "****| Cleanup completed successfully |****"
}

# Function for Launch Terminal
launch_terminal() {
    echo "****| Launching Terminal |****"
    bash
    echo "****| Terminal launched successfully |****"
}

# Function for Update Python Packages
update_python_packages() {
    echo "****| Updating Python Packages |****"
    pip3 install --upgrade pip
    pip3 install --upgrade setuptools
    echo "****| Python Packages updated successfully |****"
}

# Function for Kubernetes Setup
kubernetes() {
    echo "****| Setting up Kubernetes |****"
    # Add your Kubernetes setup logic here
    echo "****| Kubernetes Setup completed successfully |****"
}

# Display menu and process user input
menu() {
    clear
    echo "****|     1. Full Setup                |****"
    echo "****|     2. 'Mini' Setup              |****"
    echo "****|     3. Cleanup Files             |****"
    echo "****|     4. Launch Terminal           |****"
    echo "****|     5. Update Python Packages    |****"
    echo "****|     6. Create Build              |****"
    echo "****|     7. Create Volume             |****"
    echo "****|     8. Create Container          |****"
    echo "****|     9. Kubernetes                |****"
    echo "****|    10. Exit Program              |****"
    echo

    read -p "Please select an option (1-10): " action

    case "$action" in
        1) full_setup ;;
        2) mini_setup ;;
        3) cleanup_files ;;
        4) launch_terminal ;;
        5) update_python_packages ;;
        9) kubernetes ;;
        10) exit 0 ;;
        *) echo "Invalid Selection. Choose a valid option."
           sleep 2 ;;
    esac
}

# Continuously display the menu
while true; do
    menu
done