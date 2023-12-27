import os
import sys
import datetime
import configparser
import openai
import platform
import logging
import subprocess
import socket
import psutil
import tempfile
import requests
from bs4 import BeautifulSoup
from contextlib import contextmanager

logging.basicConfig(filename='gizmo_record.log', level=logging.DEBUG)


# Define CoreGizmo class.
class CoreGizmo:
    def __init__(self, gizmo_code):
        # Initial checks
        self.check_disk_space()
        self.check_ram()
        self.check_network_availability()
        self.check_user_agreement()
        self.import_libraries()
        self.load_config()
        self.load_from_memory_file()
        
        # Initialize variables
        self.encoding = 'utf-8'
        self.os_name = self.os_check()
        self.imported_libraries = [
            'os', 'sys', 'datetime', 'configparser', 'openai', 'platform',
            'logging', 'subprocess', 'socket', 'psutil', 'tempfile',
            'requests', 'bs4.BeautifulSoup', 'contextlib'
        ]
        self.valid_message_types = [
            "initialization", "status", "info", "error", "debug", "alert",
            "user_input", "query", "summary", "warning", "fatal_error",
            "shutdown"
        ]
        self.memory_file = os.path.join(self.config_folder, "Core_Memory.txt")
        self.config_file = os.path.join(self.config_folder, "Config_Settings.ini")
        self.max_retries = 10
        self.temperature = 0.2
        self.token_limit = 8192
        self.api_key = config.get("API", "key", fallback=os.environ.get("OPENAI_API_KEY"))
        self.gpt_model = ["gpt-4", "gpt-3.5-turbo"]
        self.role_description = (
            "Your name is Gizmo, and you're an AI Lab Assistant. You're an expert in Python code, "
            "Raspberry Pi hardware, Commodore 64 hardware, Linux, MacOS, Windows, deep learning, "
            "neural networks, Artificial Intelligence, machine learning."
        )
        self.buffer = []
        self.memory_file_path = os.path.join(self.memory_folder, "Core_History")
        software_dependencies = [
            {'name': 'Python3', 'command': 'python3 --version'},
            {'name': 'IDLE3', 'command': 'idle3 --version'},
            {'name': 'PuTTY', 'command': 'putty -V'},
            {'name': 'VLC', 'command': 'vlc --version'},
            {'name': 'Bash', 'command': 'bash --version'},
            {'name': 'MATE', 'command': 'mate-about --version'},
            {'name': 'Caja', 'command': 'caja --version'},
            {'name': 'Pluma', 'command': 'pluma --version'},
            {'name': 'Chromium', 'command': 'chromium --version'},
            {'name': 'UFW', 'command': 'ufw --version'},
            {'name': 'QEMU', 'command': 'qemu-system-x86_64 --version'},
            {'name': 'Nano', 'command': 'nano --version'},
            {'name': 'GRUB', 'command': 'grub-install --version'},
            {'name': 'GParted', 'command': 'gparted --version'},
            {'name': 'PavuControl', 'command': 'pavucontrol --version'},
            {'name': 'OpenSSH Server', 'command': 'sshd -v'},
            {'name': 'Tar', 'command': 'tar --version'},
            {'name': 'Timeshift', 'command': 'timeshift --version'}
        ]

        # File restructure
        self.parent_folder = os.getcwd()
        self.level_1 = "GIZMO"
        self.level_2 = {
            "MEMORY": [],
            "BOOKS": [],
            "CONFIG": ["config_manager.py"],
            "CLI": ["gizmo_cli.py"],
            "GUI": ["gizmo_gui.py"],
            "SPLITTER": ["text_splitter.py"],
            "FORMATTER": ["text_formatter.py"],
            "MONOPOLY": ["monopoly_simulator.py"],
            "BananaBrain": ["banana_brain.py"],
            "AGREEMENT": []
        }
        self.gizmo_functions = gizmo_code
        self.setup_folders_and_files()
        self.ensure_files_exist()

        # Gizmo starts.
        self.initial_message()


    def display_user_agreement(self):
        try:
            with open(os.path.join(self.config_folder, 'UserAgreement.txt'), 'r') as f:
                print(f.read())
        except FileNotFoundError:
            self.print_message("User Agreement file not found. Exiting the program.", "alert")
            self.graceful_exit()


    def check_user_agreement(self):
        config = configparser.ConfigParser()
        config.read(self.config_file)

        user_agreement_path = os.path.join(self.agreement_folder, 'UserAgreement.txt')
        
        if not os.path.exists(user_agreement_path):
            self.fetch_and_save_license()

        if 'UserAgreement' not in config.sections():
            self.display_user_agreement()
            user_response = input("Do you agree to the terms? (yes/no): ").strip().lower()

            if user_response != 'yes':
                self.print_message("User agreement not accepted. Exiting the program.", "alert")
                self.graceful_exit()

            # Update config file
            config.add_section('UserAgreement')
            config.set('UserAgreement', 'Agreed', 'yes')

            with open(self.config_file, 'w') as configfile:
                config.write(configfile)

            self.print_message("User agreement accepted. Continuing the program.", "status")


    def check_network_availability(self):
        try:
            # Create a socket object and set timeout
            s = socket.create_connection(("8.8.8.8", 53), timeout=5)
            s.close()
            self.print_message("Network is available.", "status")
        except OSError:
            self.print_message("Network is not available.", "alert")
            self.graceful_exit()

    def fetch_and_save_license(self):
        url = "https://www.gnu.org/licenses/gpl-3.0.en.html#license-text"
        license_file_path = os.path.join(self.agreement_folder, "UserAgreement.txt")

        try:
            # Fetch the HTML content
            response = requests.get(url)
            response.raise_for_status()

            # Parse the HTML content with BeautifulSoup
            soup = BeautifulSoup(response.content, 'html.parser')

            # Extract license text. The id '#license-text' is assumed to be where the license text is stored.
            license_text_element = soup.find(id='license-text')

            if license_text_element:
                license_text = license_text_element.get_text()

                # Write to UserAgreement.txt
                with open(license_file_path, "w") as f:
                    f.write(license_text)
                
                self.print_message("License text fetched and saved to 'UserAgreement.txt'.", "status")
            else:
                self.print_message("Failed to find the license text on the page.", "error")

        except requests.RequestException as e:
            self.print_message(f"An error occurred while fetching the license: {e}", "error")

    def check_folder_permissions(self, folder_path):
        try:
            # Create a temporary file in the folder to check write permission
            with tempfile.NamedTemporaryFile(dir=folder_path):
                pass
            return True
        except PermissionError:
            self.print_message(f"No write permission for folder: {folder_path}", "error")
            return False
        except Exception as e:
            self.print_message(f"An unexpected error occurred while checking folder permissions: {str(e)}", "error")
            return False

    def import_libraries(self, retries=3):
        for _ in range(retries):
            missing_libraries = []
            for library in self.required_libraries:
                try:
                    self.imported_libraries[library] = __import__(library)
                except ImportError:
                    missing_libraries.append(library)
                    logging.error(f"Failed to import {library}")
            
            if missing_libraries:
                self.print_message("The following libraries are missing:", "error")
                for lib in missing_libraries:
                    self.print_message(f" - {lib}", "error")
                self.print_message("Retrying...", "error")
            else:
                break
        else:
            self.print_message("Failed after retries. Please install missing libraries.", "error")
            self.graceful_exit()

    def os_check(self):
        self.os_name = platform.system()
        if self.os_name != 'Linux':
            self.print_message("This program requires a Linux Operating System. Exiting.", "alert")
            self.graceful_exit()
        else:
            self.print_message("Linux Operating System Detected...", "status")
            self.check_software_dependencies()

    def check_disk_space(self):
        try:
            # Get disk space statistics
            statvfs = os.statvfs('/')
            
            # Calculate total disk space in GB
            total_disk_space_gb = (statvfs.f_frsize * statvfs.f_blocks) / (1024 ** 3)
            
            # Calculate available disk space in GB
            available_disk_space_gb = (statvfs.f_frsize * statvfs.f_bavail) / (1024 ** 3)
            
            # Check if total disk space is at least 64 GB
            if total_disk_space_gb < 64:
                self.print_message("Total disk space is less than 64 GB. Exiting.", "alert")
                self.graceful_exit()
            else:
                self.print_message(f"Total disk space: {total_disk_space_gb:.2f} GB", "status")
            
            # Check if available disk space is at least 4 GB
            if available_disk_space_gb < 4:
                self.print_message("Less than 4 GB of disk space is available. Exiting.", "alert")
                self.graceful_exit()
            else:
                self.print_message(f"Available disk space: {available_disk_space_gb:.2f} GB", "status")
            
        except Exception as e:
            self.print_message(f"An error occurred while checking disk space: {str(e)}", "error")
            self.handle_exception(type(e), "check_disk_space")

    def check_ram(self):
        try:
            # Get virtual memory statistics
            virtual_memory = psutil.virtual_memory()
            
            # Calculate total RAM in GB
            total_ram_gb = virtual_memory.total / (1024 ** 3)
            
            # Calculate available RAM in GB
            available_ram_gb = virtual_memory.available / (1024 ** 3)
            
            # Check if total RAM is at least 8 GB
            if total_ram_gb < 8:
                self.print_message("Total RAM is less than 8 GB. Exiting.", "alert")
                self.graceful_exit()
            else:
                self.print_message(f"Total RAM: {total_ram_gb:.2f} GB", "status")
            
            # Check if available RAM is at least 4 GB
            if available_ram_gb < 4:
                self.print_message("Less than 4 GB of RAM is available. Exiting.", "alert")
                self.graceful_exit()
            else:
                self.print_message(f"Available RAM: {available_ram_gb:.2f} GB", "status")
            
        except Exception as e:
            self.print_message(f"An error occurred while checking RAM: {str(e)}", "error")
            self.handle_exception(type(e), "check_ram")

    def load_config(self):
        config = configparser.ConfigParser()
        config.read(self.config_file)
        self.validate_config(config)
        self.api_key = self.get_api_key(config)
        role_description, model, temperature, file_path = self.get_settings(config)
        self.validate_model(model)

    def ensure_folders_exist(self):
        for folder in self.folder_names:
            self.print_message(f"Scanning '{folder}' folder...", "status")
            self.ensure_folder_exists(folder)
        
    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        self.print_message("Exiting the program.", "status")
        sys.exit()

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


    def initial_message(self):
        program_name = os.path.basename(__file__).replace('.py', '')
        formatted_program_name = ' '.join(word.capitalize() for word in program_name.split('_'))
        
        title_message = f"[Initialization] Monkey Head Project: {formatted_program_name} Initialized"
        init_message = f"Starting '{formatted_program_name}.py'..."
        
        common_prefix = "Monkey Head Project: Gizmo / BananaBrain"
        
        print(f"{common_prefix} - {formatted_program_name}")
        self.print_message(title_message, "initialization")
        self.print_message(init_message, "initialization")


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

    def handle_exception(self, error_type, function_name):
        self.print_message(f"Function '{function_name}' encountered a {error_type.__name__}.", "debug")
        self.print_message("Manual oversight required!", "alert")
        self.add_to_buffer(function_name, error_type)
        self.graceful_exit()

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

    def setup_folders_and_files(self):
        ensure_folder_exists(os.path.join(self.parent_folder, self.level_1))

        for folder, py_files in self.level_2_folders.items():
            folder_path = os.path.join(self.parent_folder, self.level_1, folder)
            self.ensure_folder_exists(folder_path)

            for py_file in py_files:
                self.create_python_file(folder_path, py_file, python_code.get(py_file, "# Sample code"))

    def ensure_folder_exists(self, folder_name, parent_folder=None):
        parent_folder = parent_folder or self.current_folder
        folder_path = os.path.join(parent_folder, folder_name)
        try:
            if not os.path.exists(folder_path):
                os.makedirs(folder_path)
            
            if folder_name == "CONFIG":
                config_path = os.path.join(folder_path, self.config_file)
                if not os.path.exists(config_path):
                    self.create_config_file(config_path)
                    
            elif folder_name == "MEMORY":
                memory_file_path = os.path.join(folder_path, self.memory_file)
                if not os.path.exists(memory_file_path):
                    self.create_memory_file(memory_file_path)
                    
        except Exception as e:
            self.print_message(f"An error occurred while ensuring folder existence: {str(e)}", "error")
            self.handle_exception(type(e), "ensure_folder_exists")

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

    def create_python_file(folder_path, py_file_name, code_content):
        py_file_path = os.path.join(folder_path, py_file_name)
        if not os.path.exists(py_file_path):
            with open(py_file_path, 'w') as f:
                f.write(code_content)
        
    @contextmanager
    def load_config(self, config_path=None):
        if config_path is None:
            config_path = self.config_file
        config = configparser.ConfigParser()
        config.read(config_path)
        self.validate_config(config)
        self.validate_model(config)
        try:
            yield config
        finally:
            with open(config_path, "w") as configfile:
                config.write(configfile)

    def reload_config(self):
        with self.load_config(self.config_file) as config:
            self.api_key = self.get_api_key(config)
            role_description, model, temperature, file_path = self.get_settings(config)

    def get_api_key(self, config):
        api_key = config.get('openai', 'api_key', fallback=os.environ.get("OPENAI_API_KEY"))
        if not api_key:
            self.print_message("API key is missing. Please add it to the config file or set the OPENAI_API_KEY environment variable.", "error")
            self.graceful_exit()
        return api_key

    def get_settings(self, config):
        if 'settings' not in config.sections():
            self.print_message("Missing 'settings' section. Add it with the necessary keys.", "error")
            raise ValueError()
        default_role_description = config.get("settings", "default_role_description")
        default_model = config.get("settings", "default_model")
        default_temperature = config.getfloat("settings", "default_temperature")
        file_path = config.get("settings", "file_path")
        return default_role_description, default_model, default_temperature, file_path

    def validate_question(self, question: str):
        if not question.strip():
            self.print_message("The question cannot be empty. Please enter a valid question.", "error")
            raise ValueError()
        if len(question.split()) > self.token_limit:
            self.print_message("The question is too long. Please enter a question with fewer tokens.", "error")
            raise ValueError()

    def validate_model(self, model: str):
        if model not in self.gpt_model:
            self.print_message(f"The model '{model}' is not valid. Please enter a valid model.", "error")
            raise ValueError()

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

    def get_user_input(self):
        return self.print_message(f"INPUT: ", "user_input")

    def get_openai_answer(self):
        input_content = get_user_input
        openai.api_key = self.api_key
        if isinstance(input_content, list): 
            messages = input_content
        else:  
            messages = [{"role": "system", "content": "You're an AI Assistant."}, {"role": "user", "content": input_content}]
        response = openai.Completion.create(
            engine=self.gpt_model[0],
            prompt=input_content,
            max_tokens=150
        )
        return response.choices[0].text.strip()
    
    def add_to_buffer(self, role: str, content: str):
        timestamp = datetime.datetime.now().strftime("%d-%m-%Y %H:%M:%S")
        memory_entry = f"{timestamp} - {role}: {content}"
        
        self.buffer.append(memory_entry)
        self.save_to_memory_file(memory_entry)

    def get_history(self):
        return self.buffer

    def save_to_memory_file(self, memory_entry: str):
        with open(self.memory_file, "a") as file:
            file.write(f"{memory_entry}\n")
        self.print_message(f"Saved entry to memory file: {memory_entry}", "status")

    def load_from_memory_file(self):
        try:
            with open(self.memory_file, "r") as file:
                self.buffer = file.readlines()
            self.buffer = [line.strip() for line in self.buffer]
        except FileNotFoundError:
            self.print_message("Memory file not found. Creating a new one.", "warning")
            self.buffer = []

    def generate_answer(self, question: str):
        self.validate_question(question)

        self.add_to_buffer("user", question)
        conversation_history = self.get_history()

        with self.load_config(self.config_file) as config:
            api_key = self.get_api_key(config)
            model = self.gpt_model
            temperature = self.temperature
            
        answer = self.get_openai_answer(conversation_history, api_key, model, temperature)

        self.add_to_buffer("assistant", answer)
        return answer
            
    def main(self):
        try:
            self.ensure_folders_exist()

            with self.load_config() as config:
                api_key = self.get_api_key(config)
                role_description, model, temperature, file_path = self.get_settings(config)
                self.add_to_buffer("system", role_description)
                
                while True:
                    question = self.print_message("Enter a question or type 'quit' to exit or 'reload config' to reload the configuration", "user_input").strip()
                    
                    if question.lower() == 'quit':
                        self.graceful_exit()
                        break
                    elif question.lower() == 'reload config':
                        self.reload_config()
                        self.print_message("Configuration reloaded.", "status")
                        continue

                    self.validate_question(question)
                    answer = self.generate_answer(question)
                    
                    self.print_message(answer, "info")
                    self.add_to_buffer("user", question)
                    self.add_to_buffer("assistant", answer)
        except Exception as e:
            self.print_message(f"An exception occurred: {e}", "error")
            self.handle_exception(type(e), "main")
            self.graceful_exit()


if __name__ == '__main__':
    pyhton_code = {
        "config_manager.py": "# Code to handle custom config files",
        "gizmo_cli.py": "# Code for CLI communication",
        "gizmo_gui.py": "# Code for GUI communication",
        "text_splitter.py": "# Code to split books into pieces",
        "text_formatter.py": "# Code to format book information",
        "monopoly_simulator.py": "# Code for Monopoly simulator with GPT interface",
        "banana_brain.py": "# Code for neural network related tasks"
    }
    core = CoreGizmo(python_code)
    core.main()
