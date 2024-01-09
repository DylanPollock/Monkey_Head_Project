import subprocess
import os
import sys

# Function to clear the screen for a cleaner UI
def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

# Function to verify Python installation
def verify_python_installation():
    try:
        python_version = subprocess.check_output(["python", "--version"], text=True)
        print(f"[GenCore]: Python version: {python_version}")
        return True
    except subprocess.CalledProcessError:
        print("[GenCore]: Python is not installed or not in PATH.")
        return False

# Function to install packages from a requirements.txt file
def install_requirements(requirements_path):
    try:
        subprocess.check_call(['pip', 'install', '-r', requirements_path])
        print("Successfully installed requirements.")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while installing requirements: {e}")

# Function to clone a GitHub repository to a specified path
def clone_github_repo(repo_url, clone_path):
    try:
        subprocess.check_call(['git', 'clone', repo_url, clone_path])
        print(f"Repository cloned successfully at {clone_path}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while cloning the repository: {e}")

# Other GenCore functions (as per the first part of the script)
# ...

# Menu options dictionary mapping option numbers to functions
menu_options = {
    # Add the corresponding function mappings here
    # ...
}

# Main menu function displaying options and handling user input
def main_menu():
    clear_screen()
    print("[****|     GenCore Management Console   |****]")
    print("[1] Full Setup")
    # Add other options as per your script
    # ...
    action = input("Select an option (1-10): ")
    if action in menu_options:
        menu_options[action]()
    else:
        print("Invalid Selection. Choose a valid option.")
        input("Press Enter to continue...")
        main_menu()

# Main execution block
if __name__ == "__main__":
    main_menu()

# Example usage of install_requirements and clone_github_repo
requirements_file = 'requirements.txt'
github_repo_url = 'https://github.com/username/repo.git'
clone_directory = '/path/to/clone/directory'

if os.path.exists(requirements_file):
    install_requirements(requirements_file)
else:
    print(f"Requirements file not found at {requirements_file}")

clone_github_repo(github_repo_url, clone_directory)
