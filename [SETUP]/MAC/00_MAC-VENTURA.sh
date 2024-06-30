#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color
clear
echo -e "\e[32m[****|    00 - WIN10.sh - GenCore AI/OS - Windows 11 Pro For Workstations x64   |****]\e[0m"
echo

# Function to ensure the script is running with administrative privileges
ensureAdmin() {
    if [ "$(id -u)" != "0" ]; then
        echo "Please run this script as root."
        read -p "Press Enter to exit..."
        exit 1
    fi
}

# Function to check the last command and exit if it failed
checkError() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed with error code $?."
        logError "$1"
        read -p "Press Enter to exit..."
        exit $?
    fi
}

# Function to log errors
logError() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Error: $1 failed with error code $?" >> error_log.txt
}

# Function to perform initial system checks
systemCheck() {
    echo "Performing system checks..."
    # Check for available disk space
    FreeSpace=$(df -h --output=avail "$SystemDrive" | tail -n 1)
    echo "Free space on $SystemDrive: $FreeSpace"
    # Check for internet connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: No internet connection detected."
        logError "Internet Connectivity Check"
        read -p "Press Enter to exit..."
        exit $?
    fi
    # Check for required software (e.g., PowerShell, Git)
    command -v git > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Git is not installed."
        logError "Git Availability Check"
        read -p "Press Enter to exit..."
        exit $?
    fi
    # Add any other necessary checks here
}

# Function to install common tools
installCommonTools() {
    echo "Installing common tools..."
    # Install Git
    apt-get install -y git
    checkError "Git Installation"
    # Install Node.js
    apt-get install -y nodejs
    checkError "NodeJS Installation"
    # Install VSCode
    apt-get install -y code
    checkError "VSCode Installation"
}

# Function to install additional tools
installAdditionalTools() {
    echo "Installing additional tools..."
    # Install Python
    apt-get install -y python
    checkError "Python Installation"
    # Install Docker
    apt-get install -y docker
    checkError "Docker Installation"
}

# Function to install optional tools
installOptionalTools() {
    echo "Installing optional tools..."
    # Uncomment the tools you need
    # apt-get install -y postman
    # checkError "Postman Installation"
    # apt-get install -y slack
    # checkError "Slack Installation"
    # apt-get install -y zoom
    # checkError "Zoom Installation"
    # apt-get install -y p7zip
    # checkError "7zip Installation"
    # apt-get install -y wget
    # checkError "Wget Installation"
    # apt-get install -y curl
    # checkError "Curl Installation"
    # apt-get install -y terraform
    # checkError "Terraform Installation"
    # apt-get install -y kubectl
    # checkError "kubectl Installation"
    # apt-get install -y minikube
    # checkError "Minikube Installation"
    # apt-get install -y awscli
    # checkError "AWS CLI Installation"
    # apt-get install -y azure-cli
    # checkError "Azure CLI Installation"
}

# Function to clone the repository
cloneRepository() {
    echo "Cloning repository..."
    if [ ! -d "$HOME/Source" ]; then
        mkdir "$HOME/Source"
    fi
    cd "$HOME/Source"
    git clone https://github.com/your/repo.git
    checkError "Git Clone"
}

# Function to set up Python environment
setupPythonEnv() {
    echo "Setting up Python environment..."
    cd "$HOME/Source/repo"
    python -m venv venv
    checkError "Python Virtual Environment Setup"
    source venv/bin/activate
    checkError "Activate Python Virtual Environment"
    pip install -r requirements.txt
    checkError "Install Python Requirements"
}

# Function to configure Git
configureGit() {
    echo "Configuring Git..."
    git config --global user.name "Your Name"
    checkError "Git Config Username"
    git config --global user.email "your.email@example.com"
    checkError "Git Config Email"
}

# Function to create common directories
createDirectories() {
    echo "Creating common directories..."
    mkdir "$HOME/Projects"
    checkError "Creating Projects Directory"
    mkdir "$HOME/Tools"
    checkError "Creating Tools Directory"
}

# Function to update environment variables (Optional)
updateEnvVariables() {
    echo "Updating environment variables..."
    export PATH="$PATH:$HOME/Tools"
    checkError "Updating PATH Environment Variable"
}

# Function to update Python packages
updatePythonPackages() {
    echo "Updating Python Packages..."
    pip install --upgrade pip
    checkError "Pip Upgrade"
    pip install --upgrade -r requirements.txt
    checkError "Update Python Packages"
}

# Function to build the system
buildSystem() {
    echo "Building System..."
    # Add commands to build the system here
    # Example:
    cd "$HOME/Source/repo"
    python setup.py build
    checkError "Build System"
}

# Function to manage Docker containers
manageContainers() {
    echo "Managing Containers..."
    # Add commands to manage Docker containers here
    # Example:
    docker-compose up -d
    checkError "Start Docker Containers"
    docker ps
    checkError "List Running Containers"
}

# Function to manage Docker volumes
manageVolumes() {
    echo "Managing Volumes..."
    # Add commands to manage Docker volumes here
    # Example:
    docker volume ls
    checkError "List Docker Volumes"
    docker volume prune -f
    checkError "Prune Docker Volumes"
}

# Function to deploy with Kubernetes
deployKubernetes() {
    echo "Deploying with Kubernetes..."
    # Add commands to deploy with Kubernetes here
    # Example:
    kubectl apply -f deployment.yaml
    checkError "Deploy Kubernetes Resources"
    kubectl get pods
    checkError "Get Kubernetes Pods"
}

# Function to start the system
startSystem() {
    echo "Starting System..."
    # Add commands to start the system here
    # Example:
    cd "$HOME/Source/repo"
    python main.py
    checkError "Start System"
}

# Function to set up HostOS
setupHostOS() {
    echo "Setting up HostOS..."
    # Add commands to set up HostOS here
    # Example:
    apt-get install -y htop
    checkError "Install htop"
}

# Function to set up SubOS
setupSubOS() {
    echo "Setting up SubOS..."
    # Add commands to set up SubOS here
    # Example:
    # Placeholder for SubOS setup commands
    checkError "Setup SubOS"
}

# Function to set up NanoOS
setupNanoOS() {
    echo "Setting up NanoOS..."
    # Add commands to set up NanoOS here
    # Example:
    # Placeholder for NanoOS setup commands
    checkError "Setup NanoOS"
}

# Function to manage Kubernetes
kubernetesManagement() {
    echo "Managing Kubernetes..."
    # Add commands to manage Kubernetes here
    # Example:
    kubectl get nodes
    checkError "Get Kubernetes Nodes"
    kubectl get services
    checkError "Get Kubernetes Services"
}

# Function to check system status
status() {
    echo "Checking System Status..."
    # Call a status script or include status commands here
    echo "Checking Docker status..."
    docker ps
    checkError "Check Docker Status"
    echo "Checking Kubernetes status..."
    kubectl get pods
    checkError "Check Kubernetes Status"
}

# Function to backup configurations
backupConfig() {
    echo "Backing up Configurations..."
    # Placeholder for backup commands
    # Example:
    cp -r "$HOME/Source/repo/config" "$HOME/Backup/repo/config"
    checkError "Backup Configurations"
}

# Function to restore configurations
restoreConfig() {
    echo "Restoring Configurations..."
    # Placeholder for restore commands
    # Example:
    cp -r "$HOME/Backup/repo/config" "$HOME/Source/repo/config"
    checkError "Restore Configurations"
}

# Function to check and install dependencies
checkDependencies() {
    echo "Checking and Installing Dependencies..."
    # Placeholder for dependency checks and installations
    # Example:
    command -v terraform > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        apt-get install -y terraform
        checkError "Install Terraform"
    fi
}

# Function to launch terminal
launchTerminal() {
    echo "Launching Terminal..."
    ensureAdmin
    x-terminal-emulator
    checkError "Launch Terminal"
}

# Main Execution Flow
echo "Ensuring script runs with administrative privileges..."
ensureAdmin

echo "Performing initial system checks..."
systemCheck

echo "Installing common tools..."
installCommonTools

echo "Installing additional tools..."
installAdditionalTools

echo "Cloning the repository..."
cloneRepository

echo "Setting up Python environment..."
setupPythonEnv

echo "Configuring Git..."
configureGit

echo "Creating common directories..."
createDirectories

echo "Updating environment variables..."
updateEnvVariables

while true; do
    clear
    echo
    echo "Main Menu:"
    echo
    echo "1. Full Setup"
    echo "2. Mini Setup"
    echo "3. Cleanup"
    echo "4. Launch Terminal"
    echo "5. Update Python Packages"
    echo "6. Build System"
    echo "7. Manage Containers"
    echo "8. Manage Volumes"
    echo "9. Deploy with Kubernetes"
    echo "10. Start System"
    echo "11. Setup HostOS"
    echo "12. Setup SubOS"
    echo "13. Setup NanoOS"
    echo "14. Kubernetes Management"
    echo "15. Check System Status"
    echo "16. Backup Configurations"
    echo "17. Restore Configurations"
    echo "18. Check Dependencies"
    echo "E. Exit"
    echo
    read -p "Enter your choice: " choice

    case $choice in
        1) fullSetup ;;
        2) miniSetup ;;
        3) cleanup ;;
        4) launchTerminal ;;
        5) updatePythonPackages ;;
        6) buildSystem ;;
        7) manageContainers ;;
        8) manageVolumes ;;
        9) deployKubernetes ;;
        10) startSystem ;;
        11) setupHostOS ;;
        12) setupSubOS ;;
        13) setupNanoOS ;;
        14) kubernetesManagement ;;
        15) status ;;
        16) backupConfig ;;
        17) restoreConfig ;;
        18) checkDependencies ;;
        [Ee]) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
