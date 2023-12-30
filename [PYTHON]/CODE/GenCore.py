import subprocess
import sys
import os

def check_python_version():
    try:
        python_version_output = subprocess.check_output(
            ["python", "--version"], stderr=subprocess.STDOUT, text=True
        )
        python_version = python_version_output.strip().split()[1]
        print(f"Python {python_version} is installed.")
        version_parts = python_version.split(".")
        major, minor = map(int, version_parts[:2])
        patch = int(''.join(filter(str.isdigit, version_parts[2])))
        if (major, minor, patch) < (3, 12, 0):
            print("Error: Python version 3.12.0 or higher is required.")
            sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"Error: Python is not installed or not found in the system PATH. {e}")
        sys.exit(1)
    except ValueError as e:
        print(f"Error: Unexpected Python version format. {e}")
        sys.exit(1)

def setup_gen_core():
    # Set environment variables
    os.environ['PROJECT'] = 'GenCore'
    os.environ['ENVIRONMENT'] = 'Testing'

    # Perform additional setup steps here...

# Main execution
if __name__ == "__main__":
    check_python_version()
    setup_gen_core()
    # Other function calls...
