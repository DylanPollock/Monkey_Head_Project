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

    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        temp_files = [os.path.join(self.current_folder, 'temp_config.json')]
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
        if self.check_64bit() and self.check_disk_space() and self.check_ram() and self.check_cpu():
            self.print_message(f"Hardware checks passed.", "status")
            return True
        else:
            self.print_message(f"Hardware checks failed.", "alert")
            return False
            

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

    def main():
        #Hardware Checks.
        if not hardware_checks():
            self.print_message(f"Program will not run on this device. For details on compatible hardware, please check README.txt file.", "error")
            graceful_exit()
        # Load config and memory
        self.load_config_and_memory()
        # Check User Agreement
        self.check_user_agreement()
        # OS Check
        self.os_check()
        # Network Check
        self.check_network()
        self.print_message("All checks completed successfully.", "status")
        
        
if __name__ == "__main__":
    gizmo = GizmoDiskManager()
    gizmo.print_message(f"DO NOT RUN THIS APPLICATION ON ITS OWN! ('{sys.argv[0]}')", "alert")
