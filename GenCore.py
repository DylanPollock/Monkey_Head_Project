import subprocess
import sys


def check_python_version():
    try:
        # Check if Python is installed and get its version
        python_version_output = subprocess.check_output(
            ["python", "--version"], stderr=subprocess.STDOUT, text=True
        )
        python_version = python_version_output.strip().split()[1]
        print(f"Python {python_version} is installed.")

        # Extract the major, minor, and patch version, ignoring pre-release identifiers
        version_parts = python_version.split(".")
        major, minor = map(int, version_parts[:2])
        # Extract the numeric part of the patch version (ignoring pre-release identifiers like 'a', 'b', or 'rc')
        patch = int(''.join(filter(str.isdigit, version_parts[2])))

        # Check if Python version is at least 3.12.0
        if (major, minor, patch) < (3, 12, 0):
            print("Error: Python version 3.12.0 or higher is required.")
            sys.exit(1)

    except subprocess.CalledProcessError as e:
        # Handle the case where Python is not installed or not found in the system PATH
        print(f"Error: Python is not installed or not found in the system PATH. {e}")
        sys.exit(1)
    except ValueError as e:
        # Handle unexpected Python version format
        print(f"Error: Unexpected Python version format. {e}")
        sys.exit(1)


if __name__ == "__main__":
    check_python_version()
    # Other function calls...
