#!/usr/bin/env python3

import platform
import subprocess
import sys

class GizmoRemover:
    def __init__(self):
        self.packages_to_remove = ["*firefox*", "*libreoffice*"]
        self.run()

    def os_check(self):
        os_name = platform.system()
        if os_name != "Linux":
            print("This program is designed to run on Linux systems only. Exiting.")
            sys.exit(1)

    def check_root_permission(self):
        if subprocess.getuid() != 0:
            print("This script requires root permissions. Run it as root or with sudo. Exiting.")
            sys.exit(1)

    def check_software_dependencies(self):
        missing_dependencies = []

        for dependency in self.software_dependencies:
            try:
                subprocess.run(dependency['command'], check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                self.print_message(f"{dependency['name']} found.", "status")
            except subprocess.CalledProcessError:
                missing_dependencies.append(dependency['name'])
                self.print_message(f"{dependency['name']} not found.", "alert")

        if missing_dependencies:
            self.print_message(f"Missing dependencies: {', '.join(missing_dependencies)}. Please install them.", "alert")
            self.graceful_exit()

    def remove_packages(self):
        for package in self.packages_to_remove:
            try:
                print(f"Attempting to purge package: {package}")
                subprocess.run(["apt-get", "purge", "-y", package], check=True)
                
                print(f"Attempting to autoremove package: {package}")
                subprocess.run(["apt-get", "autoremove", "-y"], check=True)
                
                print(f"{package} has been purged and auto-removed successfully.\n")
                
            except subprocess.CalledProcessError as e:
                print(f"An error occurred while trying to remove {package}: {e}")
                continue

    def run(self):
        self.os_check()
        self.check_root_permission()
        self.remove_packages()

if __name__ == "__main__":
    GizmoRemover()
