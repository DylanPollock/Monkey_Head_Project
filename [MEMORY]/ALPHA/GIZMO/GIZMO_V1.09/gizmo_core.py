import os
import sys
import datetime
import configparser
import openai
import platform
from contextlib import contextmanager

# Define CoreGizmo class.
class CoreGizmo:
    def __init__(self, encoding='utf-8'):
        self.encoding = encoding
        self.os_check()
        self.initial_message()
        self.initial_variable()
        self.ensure_folders_exist()
        self.load_from_memory_file()

    def os_check(self):
        self.os_name = platform.system()
        os_messages = {
            "Windows": "Windows Operating System Detected...",
            "Darwin": "Mac Operating System Detected...",
            "Linux": "Linux Operating System Detected..."
        }
        message = os_messages.get(self.os_name, f"Unknown Operating System Detected, ({self.os_name})!")
        message_type = "status" if self.os_name in os_messages else "alert"
        self.print_message(message, message_type)
        return self.os_name

    def initial_variable(self):
        base_path = os.path.abspath(__file__)
        self.program_name = base_path
        self.current_folder = os.path.dirname(base_path)
        self.parent_folder = os.path.dirname(self.current_folder)
        self.folder_names = ["MEMORY", "BOOKS", "CONFIG", "CLI", "GUI", "SPLITTER", "FORMATTER", "GIZMO", "MONOPOLY", "BananaBrain"]
        for name in self.folder_names:
            setattr(self, f"{name.lower()}_folder", os.path.join(self.parent_folder, name))
        self.valid_message_types = ["initialization", "status", "info", "error", "debug", "alert", "user_input", "query", "summary", "warning", "fatal_error", "shutdown"]
        self.memory_file = os.path.join(self.config_folder, "Core_Memory.txt")
        self.config_file = os.path.join(self.config_folder, "Config.ini")
        self.max_retries = 10
        self.temperature = 0.2
        self.gpt_model = "gpt-4"
        self.role_description = (
            "Your name is Gizmo, and you're an AI Lab Assistant. You're an expert in Python code, "
            "Raspberry Pi hardware, Commodore 64 hardware, Linux, MacOS, Windows, deep learning, "
            "neural networks, Artificial Intelligence, machine learning."
        )
        self.buffer = []
        self.memory_file_path = os.path.join(self.memory_folder, "Core_History")

    def ensure_folders_exist(self):
        for folder in self.folder_names:
            self.print_message(f"Scanning '{folder}' folder...", "status")
            self.ensure_folder_exists(folder)
        
    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        self.print_message("Exiting the program.", "status")
        sys.exit()

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
                
    def ensure_folder_exists(self, folder_name):
        folder_path = os.path.join(self.parent_folder, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            if folder_name == "CONFIG":
                config_path = os.path.join(folder_path, self.config_file)
                default_config = configparser.ConfigParser()
                default_config[self.gpt_model] = {
                    "api_key": "enter_key_here"
                }
                default_config["settings"] = {
                    "default_role_description": self.role_description,
                    "default_model": self.gpt_model,
                    "default_temperature": str(self.temperature),
                    "file_path": str(self.parent_folder),
                }
                with open(config_path, "w") as f:
                    default_config.write(f)
                self.print_message(f"Created config file at {folder_path}. Please edit config file to better suit your needs.", "status")
                self.print_message("Start by adding your OpenAI API key. Then consider changing default role description. Model used may also be changed.", "status")
                self.print_message(f"Default role description is '{self.role_description}'", "status")
                self.print_message(f"Default model is '{self.gpt_model}'", "status")
            
            elif folder_name == "MEMORY":
                memory_file_path = os.path.join(folder_path, self.memory_file)
                formatted_program_name = ' '.join(word.capitalize() for word in os.path.basename(__file__).replace('.py', '').split('_'))
                with open(memory_file_path, "w") as f:
                    f.write(f"Monkey Head Project: Gizmo / BananaBrain - {formatted_program_name}\n")
                    f.write("Gizmo Core Memory File - Conversation History\n")
                    f.write(f"Parent Folder: {self.parent_folder}\n")
                
                self.print_message(f"Created memory file at '{folder_path}' called '{self.memory_file}'.", "status")
                self.print_message(f"Conversation history will be stored in '{self.memory_file}'.", "status")

    @contextmanager
    def load_config(self, config_path=None):
        if config_path is None:
            config_path = self.config_file
        config = configparser.ConfigParser()
        config.read(config_path)
        self.validate_config(config)
        
        try:
            yield config
        finally:
            with open(config_path, "w") as configfile:
                config.write(configfile)

    def get_api_key(self, config):
        if 'OPENAI_SECTION' not in config.sections():
            self.print_message("Missing 'OPENAI_SECTION'. Add it with the 'API_KEY_FIELD' key.", "error")
            raise ValueError()
        api_key = config.get('OPENAI_SECTION', 'API_KEY_FIELD') or os.environ.get("OPENAI_API_KEY")
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
        if model not in Config.VALID_MODELS:
            self.print_message(f"The model '{model}' is not valid. Please enter a valid model.", "error")
            raise ValueError()

    def get_openai_answer(self, input_content, api_key):
        openai.api_key = api_key
        if isinstance(input_content, list): 
            messages = input_content
        else:  
            messages = [{"role": "system", "content": "You're an AI Assistant."}, {"role": "user", "content": input_content}]
        response = openai.Completion.create(
            engine=self.gpt_model,
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
                    question = self.print_message("Enter a question or type 'quit' to exit", "user_input").strip()
                    
                    if question.lower() == 'quit':
                        self.graceful_exit()
                        break
                    
                    self.validate_question(question)
                    answer = self.generate_answer(question)
                    
                    self.print_message(answer, "info")
                    self.add_to_buffer("user", question)
                    self.add_to_buffer("assistant", answer)
        except Exception as e:
            self.print_message(f"An exception occurred: {e}", "error")
            self.graceful_exit()


if __name__ == '__main__':
    core = CoreGizmo()
    core.main()
