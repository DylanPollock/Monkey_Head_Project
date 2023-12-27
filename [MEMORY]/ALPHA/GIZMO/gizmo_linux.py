#!/usr/bin/env python3

import platform
import subprocess
import sys
from typing import List, Dict

from CLI.cli_print import print_message, valid_types
from GIZMO.gizmo_checks import hardware_check

class GizmoLinux:
    def __init__(self):
        self.packages_to_remove = ["*firefox*", "*libreoffice*"]
        self.software_dependencies: List[Dict[str, str]] = [
            {"name": "apt", "command": "which apt"},
            {"name": "grub-efi", "command": "which grub"},
            {"name": "python3", "command": "which python3"},
            {"name": "idle3", "command": "which idle3"},
            {"name": "gparted", "command": "which gparted"},
            {"name": "putty", "command": "which putty"},
            {"name": "openssh-server", "command": "which openssh-server"},
            {"name": "chromium", "command": "which chromium"},
            {"name": "nano", "command": "which nano"},
            {"name": "lightdm", "command": "which lightdm"},
            {"name": "mate-core", "command": "which mate-core"},
        ]
        self.main()

    def os_check(self) -> None:
        os_name = platform.system()
        if os_name != "Linux":
            print_message("This program is designed to run on Linux systems only.", "error")
            return False
        else:
            return True

    def check_root_permission(self) -> None:
        if subprocess.getstatusoutput("whoami")[1] != 'root':
            print_message("This script requires root permissions. Run it as root or with sudo.", "error")
            return False
        else:
            return True

    def check_software_dependencies(self, missing_dependencies) -> None:
        for dependency in self.software_dependencies:
            try:
                subprocess.run(dependency['command'], check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                print_message(f"{dependency['name']} found.", "info")
            except subprocess.CalledProcessError:
                missing_dependencies.append(dependency['name'])
                print_message(f"{dependency['name']} not found.", "warning")

        if missing_dependencies:
            print_message(f"Missing dependencies: {', '.join(missing_dependencies)}. Please install them.", "error")
            return missing_dependencies
        else:
            return True

    def install_packages(self, packages: List[str]) -> bool:
        try:
            for package in packages:
                print_message(f"Attempting to install package: {package}", "info")
                subprocess.run(["apt-get", "install", "-y", package], check=True)
                print_message(f"{package} has been installed successfully.", "info")
            return True
        except subprocess.CalledProcessError as e:
            print_message(f"An error occurred while trying to install {package}: {e}", "error")
            return False


    def remove_packages(self) -> None:
        for package in self.packages_to_remove:
            try:
                print_message(f"Attempting to purge package: {package}", "info")
                subprocess.run(["apt-get", "purge", "-y", package], check=True)
                
                print_message(f"Attempting to autoremove package: {package}", "info")
                subprocess.run(["apt-get", "autoremove", "-y"], check=True)
                
                print_message(f"{package} has been purged and auto-removed successfully.", "info")
                
            except subprocess.CalledProcessError as e:
                print_message(f"An error occurred while trying to remove {package}: {e}", "error")
                continue

    def check_for_updates_and_upgrade(self) -> None:
        try:
            print_message("Checking for updates...", "info")
            subprocess.run(["apt-get", "update"], check=True)
            
            print_message("Performing a full distribution upgrade...", "info")
            subprocess.run(["apt-get", "dist-upgrade", "-y"], check=True)
            
            print_message("Updates and upgrade completed successfully.", "info")
        except subprocess.CalledProcessError as e:
            print_message(f"An error occurred during the update and upgrade process: {e}", "error")

    def delete_default_user(self) -> None:
        user_to_remove = "dlrp"
        try:
            # Check if the user exists
            result = subprocess.run(["id", user_to_remove], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode == 0:
                print_message(f"Deleting user {user_to_remove} and its home directory...", "info")
                subprocess.run(["userdel", "-r", user_to_remove], check=True)
                print_message(f"User {user_to_remove} and its home directory have been deleted successfully.", "info")
            else:
                print_message(f"User {user_to_remove} does not exist. No action taken.", "info")
        except subprocess.CalledProcessError as e:
            print_message(f"An error occurred while trying to delete user {user_to_remove}: {e}", "error")

    def clean_system(self) -> None:
        try:
            # Clean: Clears out the local repository of retrieved package files
            print_message("Cleaning the local repository of retrieved package files...", "info")
            subprocess.run(["apt-get", "clean"], check=True)
            
            # Autoclean: Like clean, but only removes package files that can no longer be downloaded
            print_message("Cleaning no longer downloadable package files...", "info")
            subprocess.run(["apt-get", "autoclean"], check=True)
            
            # Autoremove: Removes packages that were installed by other packages and are no longer used
            print_message("Removing packages that are no longer used...", "info")
            subprocess.run(["apt-get", "autoremove", "-y"], check=True)
            
            print_message("System cleaning operations completed successfully.", "info")
        except subprocess.CalledProcessError as e:
            print_message(f"An error occurred during the system cleaning operations: {e}", "error")

    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        # Additional Cleanup Code to be added
        self.print_message("Exiting the program.", "status")
        sys.exit()

    def main(self) -> None:
        # Initial system checks
        if not hardware_check():
            print_message(f"Hardware does not pass check. Please check README.txt for more information on supported hardware.", "error")
            self.graceful_exit()
        elif not self.os_check():
            print_message(f"Operating System does not pass check. Please check README.txt for more information on supported OS.", "error")
            self.graceful_exit()
        elif not self.check_root_permission():
            print_message(f"Operating System does not pass check. Please check README.txt for more information on supported OS.", "error")
            self.graceful_exit()
        else:
            print_message(f"Initial checks passed.", "status")

        # Check for updates and perform a full dist-upgrade
        self.check_for_updates_and_upgrade()

        # Software & Package checks
        missing_dependencies_list = []
        if self.check_software_dependencies(missing_dependencies_list) != True:
            print_message(f"Installing software dependencies.", "status")
            if not self.install_packages(missing_dependencies_list):
                print_message(f"Install of dependencies has failed.", "error")
            else:
                print_message(f"Install of dependencies has passed.", "status")
        else:
            print_message(f"Software dependencies check passed.", "status")

        # Remove default 'dlrp' user & home folder.
        self.delete_default_user()

        # Software & package purge
        if self.remove_packages():
            print_message(f"Package purge passed.", "status")
        else:
            print_message(f"Package purge has failed.", "error")
            self.graceful_exit()

        # System clean using 'clean', 'autoclean', & 'autoremove'.
        self.clean_system()

        print_message(f"Changes complete.", "status")
        self.graceful_exit()

            

if __name__ == "__main__":
    GizmoLinux()
    print_message(f"DO NOT RUN THIS APPLICATION ON ITS OWN! ('{sys.argv[0]}')", "warning")
