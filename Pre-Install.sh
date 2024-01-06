import subprocess
import os

def install_requirements(requirements_path):
    """
    Install packages from a requirements.txt file.
    
    Args:
    requirements_path (str): The path to the requirements.txt file.
    """
    try:
        subprocess.check_call(['pip', 'install', '-r', requirements_path])
        print("Successfully installed requirements.")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while installing requirements: {e}")

def clone_github_repo(repo_url, clone_path):
    """
    Clone a GitHub repository to a specified path.
    
    Args:
    repo_url (str): URL of the GitHub repository.
    clone_path (str): Directory path where the repo will be cloned.
    """
    try:
        subprocess.check_call(['git', 'clone', repo_url, clone_path])
        print(f"Repository cloned successfully at {clone_path}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while cloning the repository: {e}")

# Example usage
requirements_file = 'requirements.txt'  # Path to the requirements.txt file
github_repo_url = 'https://github.com/username/repo.git'  # GitHub repository URL
clone_directory = '/path/to/clone/directory'  # Path where the repo will be cloned

# Check if requirements file exists and install
if os.path.exists(requirements_file):
    install_requirements(requirements_file)
else:
    print(f"Requirements file not found at {requirements_file}")

# Clone the GitHub repository
clone_github_repo(github_repo_url, clone_directory)
