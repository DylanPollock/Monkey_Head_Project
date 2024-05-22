#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\033[0;32m[****|     04_TERMINAL.sh - Terminal Setup and Configuration   |****]\033[0m"
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

# Function to install Windows Terminal if not already installed
installTerminal() {
    echo "Checking for Windows Terminal..."
    if command -v wt &> /dev/null; then
        echo "Windows Terminal is already installed."
    else
        echo "Installing Windows Terminal..."
        sudo apt update
        sudo apt install -y gnome-terminal
        checkError "Windows Terminal Installation"
    fi
}

# Function to create default terminal settings if settings file does not exist
createDefaultSettings() {
    echo "Checking for terminal settings file..."
    if [ ! -f "terminal-settings.json" ]; then
        echo "Creating default terminal settings..."
        cat <<EOT > "terminal-settings.json"
{
    "profiles": {
        "defaults": {},
        "list": []
    },
    "schemes": [],
    "actions": [],
    "globals": {}
}
EOT
        checkError "Creating Default Terminal Settings"
    else
        echo "Custom terminal settings file found."
    fi
}

# Function to back up existing terminal settings
backupExistingSettings() {
    read -p "Would you like to back up existing terminal settings? (Y/N): " backupChoice
    if [[ "$backupChoice" =~ ^[Yy]$ ]]; then
        echo "Backing up existing terminal settings..."
        if [ -f "$HOME/.config/gnome-terminal/settings.json" ]; then
            cp "$HOME/.config/gnome-terminal/settings.json" "$HOME/.config/gnome-terminal/settings_backup.json"
            checkError "Backing Up Existing Terminal Settings"
        else
            echo "No existing terminal settings found to back up."
        fi
    else
        echo "Skipping backup of existing terminal settings."
    fi
}

# Function to configure Windows Terminal settings
configureTerminal() {
    echo "Configuring Windows Terminal settings..."
    mkdir -p "$HOME/.config/gnome-terminal"
    cp "terminal-settings.json" "$HOME/.config/gnome-terminal/settings.json"
    checkError "Copying Terminal Settings"
}

# Function to install optional terminal tools and extensions
installOptionalTools() {
    read -p "Would you like to install optional terminal tools and extensions? (Y/N): " toolsChoice
    if [[ "$toolsChoice" =~ ^[Yy]$ ]]; then
        echo "Installing optional terminal tools and extensions..."
        sudo apt update
        sudo apt install -y git
        checkError "Git Installation"
        sudo apt install -y zsh
        checkError "Zsh Installation"
        # Uncomment and modify the following lines to install additional tools and extensions
        # sudo apt install -y posh-git
        # checkError "Posh-Git Installation"
        # sudo apt install -y oh-my-zsh
        # checkError "Oh-My-Zsh Installation"
    else
        echo "Skipping installation of optional tools and extensions."
    fi
}

# Function to verify installation
verifyInstallation() {
    echo "Verifying Windows Terminal installation..."
    if command -v gnome-terminal &> /dev/null; then
        echo "Windows Terminal installed successfully."
    else
        echo "Error: Windows Terminal installation failed."
        logError "Windows Terminal Installation Verification"
        exit 1
    fi
}

# Ensure the script runs with administrative privileges
ensureAdmin

# Install Windows Terminal
installTerminal

# Create default terminal settings if necessary
createDefaultSettings

# Back up existing terminal settings
backupExistingSettings

# Configure Windows Terminal settings
configureTerminal

# Install optional terminal tools and extensions
installOptionalTools

# Verify installation
verifyInstallation

echo -e "\033[0;32m[****| Terminal setup complete! |****]\033[0m"
echo "Logs can be found in $(dirname "$0")/error_log.txt"