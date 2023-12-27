#!/usr/bin/env python3

import os
import sys
import json
import socket
import logging
import requests
import subprocess
import platform
import tempfile
import psutil
from bs4 import BeautifulSoup

from CLI.cli_print import print_message, valid_types

class GizmoDiskManager:
    def __init__(self):
        self.check_if_already_initialized()
        self.valid_message_types = valid_types
        self.current_folder = os.getcwd()
        self.config_name = 'config.json'
        self.agreement_name = 'UserAgreement.json'
        self.agreement_folder = os.path.join(self.current_folder, 'agreements')
        
        if not self.check_folder_permissions(self.current_folder):
            self.print_message("WARNING: You don't have write permission for the current folder. Proceed at your own risk.", "alert")
        
        self.hardware_checks()
        self.agreement_location = os.path.join(self.current_folder, self.agreement_name)
        self.load_config()

    def check_64bit(self):
        if not sys.maxsize > 2**32:
            self.print_message("64-bit architecture is required. Exiting.", "alert")
            self.graceful_exit()

    def check_disk_space(self):
        statvfs = os.statvfs('/')
        total_disk_space_gb = (statvfs.f_frsize * statvfs.f_blocks) / (1024 ** 3)
        if total_disk_space_gb < 120:
            self.print_message("Total disk space is less than 120 GB. Exiting.", "alert")
            self.graceful_exit()

    def check_ram(self):
        virtual_memory = psutil.virtual_memory()
        total_ram_gb = virtual_memory.total / (1024 ** 3)
        if total_ram_gb < 4.4:
            self.print_message("Total RAM is less than 4.4 GB. Exiting.", "alert")
            self.graceful_exit()

    def check_cpu(self):
        cpu_info = psutil.cpu_freq()
        if psutil.cpu_count(logical=False) < 4 or cpu_info.max < 2000.0:
            self.print_message("CPU does not meet minimum requirements. Exiting.", "alert")
            self.graceful_exit()

    def load_config(self):
        config_path = os.path.join(self.current_folder, self.config_name)
        if os.path.exists(config_path):
            self.default_config = self.read_json_file(config_path)
        else:
            self.default_config = self.create_default_config()

    def read_json_file(self, file_path):
        try:
            with open(file_path, 'r') as f:
                return json.load(f)
        except Exception as e:
            self.print_message(f"An error occurred while reading the JSON file: {e}", "alert")
            return {}

    def create_default_config(self):
        self.default_config = {
            'General': {
                'Encoding': 'utf-8',
                'MaxRetries': 3,
                'Temperature': 0.7,
                'TokenLimit': 100
            },
            'Paths': {
                'MemoryFile': 'memory.txt',
                'ConfigFile': 'config.json',
                'MemoryFilePath': 'path/to/memory/file'
            },
            'Libraries': [],
            'MessageTypes': self.valid_message_types,
            'API': {
                'APIKey': 'your_api_key',
                'GPTModel': 'gpt-4'
            },
            'Role': {
                'RoleDescription': 'Your name is Gizmo! You are an AI Lab Partner.'
            },
            'SystemRequirements': {
                'Architecture': '64bit',
                'DiskSpaceGB': 128,  # User-friendly number
                'HardDiskSpaceGB': 120,  # Hard-bar
                'RAMGB': 8,  # User-friendly number
                'HardRAMGB': 4.4,  # Hard-bar
                'CPUCores': 4,
                'CPUSpeedGHz': 2
            }
        }
        return self.default_config

    def display_user_agreement(self):
        self.fetch_and_save_license()
        try:
            with open(os.path.join(self.agreement_folder, 'UserAgreement.txt'), 'r') as f:
                print(f.read())
        except FileNotFoundError:
            self.print_message("User Agreement file not found. Exiting the program.", "alert")
            self.graceful_exit()

    def check_user_agreement(self):
        if not os.path.exists(self.config_file):
            self.create_default_config()
            with open(self.config_file, 'w') as f:
                json.dump(self.default_config, f, indent=4)

        config = read_json_file(self.config_file)
        if 'UserAgreement' not in config:
            self.display_user_agreement()
            user_response = input("Do you agree to the terms? (yes/no): ").strip().lower()
            if user_response != 'yes':
                self.print_message("User agreement not accepted. Exiting the program.", "alert")
                self.graceful_exit()
            config['UserAgreement'] = {'Agreed': 'yes'}
            with open(self.config_file, 'w') as f:
                json.dump(config, f, indent=4)
            self.print_message("User agreement accepted. Continuing the program.", "status")

    def check_folder_permissions(self, folder_path):
        try:
            with tempfile.NamedTemporaryFile(dir=folder_path):
                pass
            return True
        except PermissionError:
            self.print_message(f"No write permission for folder: {folder_path}", "error")
            return False
        except Exception as e:
            self.print_message(f"An unexpected error occurred while checking folder permissions: {str(e)}", "error")
            return False
        
    def check_if_already_initialized(self):
        # Check for the existence of a specific folder or file
        if os.path.exists("/path/to/specific/folder_or_file"):
            self.print_message("The system has already been initialized. Exiting.", "alert")
            self.graceful_exit()

    def os_check(self):
        self.os_name = platform.system()
        if self.os_name != 'Linux':
            self.print_message("This program requires a Linux Operating System. Exiting.", "alert")
            self.graceful_exit()
        else:
            self.print_message("Linux Operating System Detected...", "status")

    def check_network(self):
        try:
            s = socket.create_connection(("8.8.8.8", 53), timeout=5)
            s.close()
            self.print_message("Network is available.", "status")
        except OSError:
            self.print_message("Network is not available.", "alert")
            self.graceful_exit()
            
    def load_config_and_memory(self):
        if not os.path.exists('path/to/your/config.json'):
            with open('path/to/your/config.json', 'w') as f:
                json.dump(self.default_config, f, indent=4)
                
        with open('path/to/your/config.json', 'r') as f:
            config = json.load(f)
        
        self.encoding = config['General']['Encoding']
        self.max_retries = config['General']['MaxRetries']
        self.temperature = config['General']['Temperature']
        self.token_limit = config['General']['TokenLimit']
        self.memory_file = config['Paths']['MemoryFile']
        self.config_file = config['Paths']['ConfigFile']
        self.memory_file_path = config['Paths']['MemoryFilePath']
        self.required_libraries = config['Libraries']
        self.valid_message_types = config['MessageTypes']
        self.api_key = config['API']['APIKey']
        self.gpt_model = config['API']['GPTModel']
        self.role_description = config['Role']['RoleDescription']

    def create_config_file(self, config_path):
        default_config = configparser.ConfigParser()
        default_config[self.gpt_model] = {
            "api_key": "enter_key_here"
        }
        default_config["settings"] = {
            "default_role_description": self.role_description,
            "default_model": self.gpt_model,
            "default_temperature": str(self.temperature),
            "file_path": str(self.current_folder),
        }
        with open(config_path, "w") as f:
            default_config.write(f)
        self.print_message(f"Created config file at {config_path}. Please edit the config file to better suit your needs.", "status")
    
    def create_memory_file(self, memory_file_path):
        formatted_program_name = ' '.join(word.capitalize() for word in os.path.basename(__file__).replace('.py', '').split('_'))
        with open(memory_file_path, "w") as f:
            f.write(f"Monkey Head Project: Gizmo - {formatted_program_name}\n")
            f.write("Gizmo Core Memory File - Conversation History\n")
            f.write(f"Parent Folder: {self.current_folder}\n")
        self.print_message(f"Created memory file at '{memory_file_path}'.", "status")

    def create_temp_config_file(self):
        temp_config_path = os.path.join(self.current_folder, 'temp_config.json')
        with open(temp_config_path, 'w') as f:
            json.dump(self.create_default_config(), f, indent=4)
        self.print_message(f"Created temporary config file at {temp_config_path}. Please edit the config file to better suit your needs.", "status")


    def print_message(self, output_message, message_type):
        self.validate_print_message_input(output_message, message_type)
        
        prefixes = {
            "alert": "Alert has been triggered & program may fail!",
            "user_input": "> {}",
            "default": "> {}"
        }
        
        prefix = prefixes.get(message_type.lower(), prefixes["default"])
        
        formatted_message = prefix.format(f"{message_type.capitalize()}: {output_message}")
        
        if message_type.lower() == "user_input":
            return input(formatted_message)
        else:
            print(formatted_message)
            return None

    def validate_print_message_input(self, output_message, message_type):
        try:
            if not isinstance(output_message, str):
                raise TypeError("output_message must be a string.")
            if not output_message.strip():
                raise ValueError("output_message cannot be an empty string.")
            if not isinstance(message_type, str):
                raise TypeError("message_type must be a string.")
            if not message_type.strip():
                raise ValueError("message_type cannot be an empty string.")
            if message_type.lower() not in self.valid_message_types:
                raise ValueError(f"Invalid message_type provided. Valid types are {', '.join(self.valid_message_types)}")
        except (TypeError, ValueError) as e:
            self.print_message(str(e), "error")
            self.graceful_exit()

    def validate_config(self, config):
        required_sections = {
            'openai': [('api_key', str)],
            'settings': [
                ('default_role_description', str),
                ('default_model', str),
                ('default_temperature', float),
                ('file_path', str)
            ]
        }

        missing_sections = []
        missing_keys = {}
        incorrect_types = {}
        
        for section, keys in required_sections.items():
            if section not in config.sections():
                missing_sections.append(section)
            else:
                missing_keys_in_section = []
                incorrect_types_in_section = []
                for key, expected_type in keys:
                    if key not in config[section]:
                        missing_keys_in_section.append(key)
                    else:
                        value = config[section][key]
                        if not isinstance(value, expected_type):
                            incorrect_types_in_section.append((key, expected_type))
                
                if missing_keys_in_section:
                    missing_keys[section] = missing_keys_in_section
                if incorrect_types_in_section:
                    incorrect_types[section] = incorrect_types_in_section

        errors = False

        if missing_sections:
            self.print_message(f"Missing sections: {', '.join(missing_sections)}", "error")
            errors = True
        if missing_keys:
            for section, keys in missing_keys.items():
                self.print_message(f"Missing keys in section '{section}': {', '.join(keys)}", "error")
            errors = True
        if incorrect_types:
            for section, types in incorrect_types.items():
                for key, expected_type in types:
                    self.print_message(f"Incorrect type for key '{key}' in section '{section}'. Expected {expected_type.__name__}.", "error")
            errors = True

        if errors:
            self.print_message("Please update the configuration file.", "alert")
            self.graceful_exit()


    def handle_exception(self, error_type, function_name):
        self.print_message(f"Function '{function_name}' encountered a {error_type.__name__}.", "debug")
        self.print_message("Manual oversight required!", "alert")
        self.graceful_exit()

    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        # Additional Cleanup Code
        temp_files = [os.path.join(self.current_folder, 'temp_config.json')]  # Add more if needed
        for temp_file in temp_files:
            try:
                if os.path.exists(temp_file):
                    os.remove(temp_file)
                    self.print_message(f"Removed temporary file: {temp_file}", "status")
            except Exception as e:
                self.print_message(f"Failed to remove temporary file: {temp_file}. Error: {e}", "error")
        self.print_message("Exiting the program.", "status")
        sys.exit()

    def hardware_checks(self):
        self.check_64bit()
        self.check_disk_space()
        self.check_ram()
        self.check_cpu()

    def ensure_volume_exists(self, volume_name, parent_drive=None):
        parent_drive = parent_drive or self.current_folder
        volume_path = os.path.join(parent_drive, volume_name)
        try:
            if not os.path.exists(volume_path):
                os.makedirs(volume_path)
            
            if volume_name == "CONFIG":
                config_path = os.path.join(volume_path, self.config_file)
                if not os.path.exists(config_path):
                    self.create_config_file(config_path)
                    
            elif volume_name == "MEMORY":
                memory_file_path = os.path.join(volume_path, self.memory_file)
                if not os.path.exists(memory_file_path):
                    self.create_memory_file(memory_file_path)
                    
        except Exception as e:
            self.print_message(f"An error occurred while ensuring volume existence: {str(e)}", "error")
            self.handle_exception(type(e), "ensure_volume_exists")

    def fetch_and_save_license(self):
        license_file_path = os.path.join(self.agreement_folder, "UserAgreement.txt")
        if os.path.exists(license_file_path):
            self.print_message("License file 'UserAgreement.txt' already exists. Skipping fetch.", "status")
            return

        url = "https://www.gnu.org/licenses/gpl-3.0.en.html"

        try:
            response = requests.get(url)
            response.raise_for_status()

            soup = BeautifulSoup(response.content, 'html.parser')
            license_text_element = soup.find(id='content-inner')

            if license_text_element:
                license_text = license_text_element.get_text()

                with open(license_file_path, "w") as f:
                    f.write(license_text)
                
                self.print_message("License text fetched and saved to 'UserAgreement.txt'.", "status")
            else:
                self.print_message("Failed to find the license text on the page.", "error")

        except requests.RequestException as e:
            self.print_message(f"An error occurred while fetching the license: {e}", "error")

    def create_partitions(self, preset, min_os_size_gb=64.4, min_storage_size_gb=16.4, max_storage_size_gb=128):
        try:
            # Step 1: Hardware Checks
            self.hardware_checks()
            # Step 2: Size Preset Selection
            if preset == '0':
                os_size_gb = min_os_size_gb
                storage_size_gb = min_storage_size_gb
            elif preset == '1':
                os_size_gb = min_os_size_gb
                storage_size_gb = max_storage_size_gb
            elif preset is None:
                os_size_gb = float(self.print_message("Enter the size for the OS partition in GB: ", 'user_input'))
                storage_size_gb = float(self.print_message("Enter the size for the storage partition in GB: ", 'user_input'))
            else:
                self.print_message("Invalid preset value ('{sys.argv[0]}'). Exiting.", "alert")
                self.graceful_exit()
            # Step 3: Size Validation
            if os_size_gb < min_os_size_gb or storage_size_gb < min_storage_size_gb:
                self.print_message("Invalid sizes ('{sys.argv[0]}'). Exiting.", "alert")
                self.graceful_exit()
            # Step 4: Get Drive Location
            drive_location = self.print_message("Enter the location of the drive to be partitioned (e.g., /dev/sdb): ", 'user_input')
            if not os.path.exists(drive_location):
                self.print_message(f"The drive {drive_location} does not exist. Exiting.", "alert")
                self.graceful_exit()
            # Step 5: Confirm Drive
            confirm = self.print_message(f"Are you sure you want to partition {drive_location}? [y/n]: ", 'user_input')
            if confirm.lower() != 'y':
                self.print_message("Exiting without partitioning.", "status")
                return
            # Step 6: Unmount Drive
            subprocess.run(["umount", "-f", f"{drive_location}*"], check=True)
            # Step 7: Partition the Drive
            try:
                cmd = subprocess.Popen(["fdisk", drive_location], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
                cmd.stdin.write("d\n")  # Delete existing partitions

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("p\n")  # Primary partition
                cmd.stdin.write("1\n")  # Partition number 1
                cmd.stdin.write("\n")   # Default - start at beginning of disk 
                cmd.stdin.write("+64.4G\n")  # 64.4GB partition size for OS

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("p\n")  # Primary partition
                cmd.stdin.write("2\n")  # Partition number 2
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+1.4G\n")  # 1.4GB partition size for BOOT

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("p\n")  # Primary partition
                cmd.stdin.write("3\n")  # Partition number 3
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+1.4G\n")  # 1.4GB partition size for CONFIG

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("p\n")  # Primary partition
                cmd.stdin.write("4\n")  # Partition number 4
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+16.4G\n")  # 16.4GB partition size for IMAGE

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("e\n")  # Extended partition
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("\n")   # Use the rest of the disk for the extended partition

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("\n")   # Default - first logical partition
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+16.4G\n")  # 16.4GB partition size for BACKUP

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("\n")   # Default - next logical partition
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+504M\n")  # 504MB partition size for ESP

                cmd.stdin.write("n\n")  # New partition
                cmd.stdin.write("\n")   # Default - next logical partition
                cmd.stdin.write("\n")   # Default - start immediately after preceding partition
                cmd.stdin.write("+16.4G\n")  # 16.4GB partition size for SWAP

                cmd.stdin.write("w\n")  # Write changes
                stdout, stderr = cmd.communicate()
            except subprocess.CalledProcessError:
                self.print_message("Failed to partition the drive. Exiting.", "alert")
                self.graceful_exit()

            # Step 8: Format Partitions with Labels
            try:
                subprocess.run(["mkfs.ext4", "-L", "OS", f"{drive_location}1"], check=True)  # OS partition
                subprocess.run(["mkfs.ext2", "-L", "BOOT", f"{drive_location}2"], check=True)  # BOOT partition
                subprocess.run(["mkfs.ext4", "-L", "CONFIG", f"{drive_location}3"], check=True)  # CONFIG partition
                subprocess.run(["mkfs.ext4", "-L", "IMAGE", f"{drive_location}4"], check=True)  # IMAGE partition
                subprocess.run(["mkfs.ext4", "-L", "BACKUP", f"{drive_location}5"], check=True)  # BACKUP partition
                subprocess.run(["mkfs.vfat", "-n", "ESP", "-F32", f"{drive_location}6"], check=True)  # ESP partition
                subprocess.run(["mkswap", "-L", "SWAP", f"{drive_location}7"], check=True)  # SWAP partition
                subprocess.run(["mkfs.exfat", "-n", "EXTRA", f"{drive_location}8"], check=True)  # Another partition formatted as exFAT, if needed. Replace this line according to your specific needs.
            except subprocess.CalledProcessError:
                self.print_message("Failed to format the partitions. Exiting.", "alert")
                self.graceful_exit()

            # Step 9: Mount Partitions
        try:
            # Create mount points if they don't exist
            mount_points = {
                "os_partition": "/mnt/os_partition",
                "boot_partition": "/mnt/boot_partition",
                "config_partition": "/mnt/config_partition",
                "image_partition": "/mnt/image_partition",
                "backup_partition": "/mnt/backup_partition",
                "esp_partition": "/mnt/esp_partition",
                "swap_partition": "/mnt/swap_partition",
                "extra_partition": "/mnt/extra_partition"  # Replace this according to your specific needs
            }

            for label, path in mount_points.items():
                if not os.path.exists(path):
                    os.makedirs(path)

            # Mount each partition to its mount point
            subprocess.run(["mount", f"{drive_location}1", mount_points["os_partition"]], check=True)  # OS partition
            subprocess.run(["mount", f"{drive_location}2", mount_points["boot_partition"]], check=True)  # BOOT partition
            subprocess.run(["mount", f"{drive_location}3", mount_points["config_partition"]], check=True)  # CONFIG partition
            subprocess.run(["mount", f"{drive_location}4", mount_points["image_partition"]], check=True)  # IMAGE partition
            subprocess.run(["mount", f"{drive_location}5", mount_points["backup_partition"]], check=True)  # BACKUP partition
            subprocess.run(["mount", f"{drive_location}6", mount_points["esp_partition"]], check=True)  # ESP partition
            subprocess.run(["swapon", f"{drive_location}7"], check=True)  # SWAP partition

            # For the extra partition (if needed), you can mount it as well
            subprocess.run(["mount", f"{drive_location}8", mount_points["extra_partition"]], check=True)  # Another partition, if needed

        except subprocess.CalledProcessError:
            self.print_message("Failed to mount the partitions. Exiting.", "alert")
            self.graceful_exit()

            # Step 10: Completion Message
            self.print_message("Partitioning completed successfully.", "status")

        except subprocess.CalledProcessError as e:
            self.print_message(f"An error occurred: {e}", "error")
            self.graceful_exit()

        except Exception as e:
            self.print_message(f"An unexpected error occurred: {e}", "error")
            self.graceful_exit()

if __name__ == "__main__":
    gizmo = GizmoDiskManager()
    gizmo.print_message(f"DO NOT RUN THIS APPLICATION ON ITS OWN! ('{sys.argv[0]}')", "alert")
