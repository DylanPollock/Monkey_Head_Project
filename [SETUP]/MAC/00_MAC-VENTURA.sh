#!/bin/bash

# Function to check for administrative privileges
ensureAdmin() {
    if [[ $EUID -ne 0 ]]; then
        echo "Please run this script as root or with sudo."
        exit 1
    fi
}

# Function to check the last command and exit if it failed
checkError() {
    if [[ $? -ne 0 ]]; then
        echo "Error: $1 failed with error code $?."
        logError "$1"
        exit 1
    fi
}

# Function to log errors
logError() {
    echo "$(date) - Error: $1 failed with error code $?" >> error_log.txt
}

# Function to perform initial system checks
systemCheck() {
    echo "Performing system checks..."
    # Check for macOS version
    sw_vers -productVersion | grep -q "13"
    checkError "macOS Ventura Check"

    # Check for available disk space
    FreeSpace=$(df / | tail -1 | awk '{print $4}')
    echo "Free space on /: ${FreeSpace}K"

    # Check for internet connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Error: No internet connection detected."
        logError "Internet Connectivity Check"
        exit 1
    fi

    # Check for required software (e.g., Homebrew, Git)
    which git > /dev/null
    checkError "Git Availability Check"
}

# Function to install Homebrew if not already installed
installHomebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        checkError "Homebrew Installation"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to update system files and health
updateSystem() {
    echo "Updating system..."
    softwareupdate --all --install --force
    checkError "System Update"
}

# Function to install common tools
installCommonTools() {
    echo "Installing common tools..."
    brew install git
    checkError "Git Installation"
    brew install node
    checkError "Node.js Installation"
    brew install --cask visual-studio-code
    checkError "VSCode Installation"
}

# Function to install additional tools
installAdditionalTools() {
    echo "Installing additional tools..."
    brew install python
    checkError "Python Installation"
    brew install --cask docker
    checkError "Docker Installation"
}

# Function to install optional tools
installOptionalTools() {
    echo "Installing optional tools..."
    brew install postman
    checkError "Postman Installation"
    brew install slack
    checkError "Slack Installation"
    brew install zoom
    checkError "Zoom Installation"
    brew install p7zip
    checkError "7zip Installation"
    brew install wget
    checkError "Wget Installation"
    brew install curl
    checkError "Curl Installation"
    brew install terraform
    checkError "Terraform Installation"
    brew install kubectl
    checkError "kubectl Installation"
    brew install minikube
    checkError "Minikube Installation"
    brew install awscli
    checkError "AWS CLI Installation"
    brew install azure-cli
    checkError "Azure CLI Installation"
}

# Function to clone the repository
cloneRepository() {
    echo "Cloning repository..."
    mkdir -p "$HOME/Source"
    cd "$HOME/Source"
    git clone https://github.com/your/repo.git
    checkError "Git Clone"
}

# Function to set up Python environment
setupPythonEnv() {
    echo "Setting up Python environment..."
    cd "$HOME/Source/repo"
    python3 -m venv venv
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
    mkdir -p "$HOME/Projects"
    checkError "Creating Projects Directory"
    mkdir -p "$HOME/Tools"
    checkError "Creating Tools Directory"
}

# Function to update environment variables (Optional)
updateEnvVariables() {
    echo "Updating environment variables..."
    export PATH="$PATH:$HOME/Tools"
    checkError "Updating PATH Environment Variable"
}

# Function to update Python packages
update_python_packages() {
    echo "Updating Python Packages..."
    pip install --upgrade pip
    checkError "Pip Upgrade"
    pip install --upgrade -r requirements.txt
    checkError "Update Python Packages"
}

# Function to build the system
build_system() {
    echo "Building System..."
    cd "$HOME/Source/repo"
    python setup.py build
    checkError "Build System"
}

# Function to manage Docker containers
manage_containers() {
    echo "Managing Containers..."
    cd "$HOME/Source/repo"
    docker-compose up -d
    checkError "Start Docker Containers"
    docker ps
    checkError "List Running Containers"
}

# Function to manage Docker volumes
manage_volumes() {
    echo "Managing Volumes..."
    docker volume ls
    checkError "List Docker Volumes"
    docker volume prune -f
    checkError "Prune Docker Volumes"
}

# Function to deploy with Kubernetes
deploy_kubernetes() {
    echo "Deploying with Kubernetes..."
    cd "$HOME/Source/repo"
    kubectl apply -f deployment.yaml
    checkError "Deploy Kubernetes Resources"
    kubectl get pods
    checkError "Get Kubernetes Pods"
}

# Function to start the system
start_system() {
    echo "Starting System..."
    cd "$HOME/Source/repo"
    python main.py
    checkError "Start System"
}

# Function to set up HostOS
setup_hostos() {
    echo "Setting up HostOS..."
    brew install htop
    checkError "Install htop"
}

# Function to set up SubOS
setup_subos() {
    echo "Setting up SubOS..."
    # Add commands to set up SubOS here
    echo "SubOS setup is a placeholder."
    checkError "Setup SubOS"
}

# Function to set up NanoOS
setup_nanoos() {
    echo "Setting up NanoOS..."
    # Add commands to set up NanoOS here
    echo "NanoOS setup is a placeholder."
    checkError "Setup NanoOS"
}

# Function to manage Kubernetes
kubernetes_management() {
    echo "Managing Kubernetes..."
    kubectl get nodes
    checkError "Get Kubernetes Nodes"
    kubectl get services
    checkError "Get Kubernetes Services"
}

# Function to check system status
status() {
    echo "Checking System Status..."
    echo "Checking Docker status..."
    docker ps
    checkError "Check Docker Status"
    echo "Checking Kubernetes status..."
    kubectl get pods
    checkError "Check Kubernetes Status"
}

# Function to backup configurations
backup_config() {
    echo "Backing up Configurations..."
    mkdir -p "$HOME/Backup/repo/config"
    cp -r "$HOME/Source/repo/config" "$HOME/Backup/repo/config"
    checkError "Backup Configurations"
}

# Function to restore configurations
restore_config() {
    echo "Restoring Configurations..."
    cp -r "$HOME/Backup/repo/config" "$HOME/Source/repo/config"
    checkError "Restore Configurations"
}

# Function to check and install dependencies
check_dependencies() {
    echo "Checking and Installing Dependencies..."
    if ! command -v terraform &> /dev/null; then
        brew install terraform
        checkError "Install Terraform"
    fi
}

# Function to launch terminal
launch_terminal() {
    echo "Launching Terminal..."
    ensureAdmin
    open -a Terminal .
    checkError "Launch Terminal"
}

# Function to handle full setup
full_setup() {
    echo "Starting Full Setup..."
    ensureAdmin
    systemCheck
    installHomebrew
    updateSystem
    installCommonTools
    installAdditionalTools
    installOptionalTools
    cloneRepository
    setupPythonEnv
    configureGit
    createDirectories
    updateEnvVariables
    echo "Full Setup Complete."
    checkError "Full Setup"
}

# Function to handle mini setup
mini_setup() {
    echo "Starting Mini Setup..."
    ensureAdmin
    systemCheck
    installHomebrew
    updateSystem
    installCommonTools
    installAdditionalTools
    echo "Mini Setup Complete."
    checkError "Mini Setup"
}

# Main Execution Flow
ensureAdmin
systemCheck
installHomebrew
updateSystem
installCommonTools
installAdditionalTools
installOptionalTools
cloneRepository
setupPythonEnv
configureGit
createDirectories
updateEnvVariables

# Main menu
while true; do
    clear
    echo "Main Menu:"
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
    read -p "Enter your choice: " choice
    case $choice in
        1) full_setup ;;
        2) mini_setup ;;
        3) cleanup ;;
        4) launch_terminal ;;
        5) update_python_packages ;;
        6) build_system ;;
        7) manage_containers ;;
        8) manage_volumes ;;
        9) deploy_kubernetes ;;
        10) start_system ;;
        11) setup_hostos ;;
        12) setup_subos ;;
        13) setup_nanoos ;;
        14) kubernetes_management ;;
        15) status ;;
        16) backup_config ;;
        17) restore_config ;;
        18) check_dependencies ;;
        [Ee]) echo "Exiting script. Thank you for using GenCore."; exit 0 ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
    read -p "Press any key to return to the main menu..." -n1 -s
done
