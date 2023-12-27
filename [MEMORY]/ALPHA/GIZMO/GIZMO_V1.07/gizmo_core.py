import os
import sys
import datetime
import configparser
import openai
from contextlib import contextmanager

# Define CoreGizmo class.
class CoreGizmo:
    def __init__(self, encoding='utf-8'):
        self.encoding = encoding
        self.initial_message()
        self.initial_variable()
        self.folder_checks()

    # Initialize important variables.
    def initial_variable(self):
        # File & path variables
        self.program_name = os.path.abspath(__file__)
        self.current_folder = os.path.dirname(os.path.abspath(__file__))
        self.parent_folder = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.memory_folder = os.path.join(self.parent_folder, "MEMORY")
        self.books_folder = os.path.join(self.parent_folder, "BOOKS")
        self.config_folder = os.path.join(self.parent_folder, "CONFIG")
        self.cli_folder = os.path.join(self.parent_folder, "CLI")
        self.gui_folder = os.path.join(self.parent_folder, "GUI")
        self.splitter_folder = os.path.join(self.parent_folder, "SPLITTER")
        self.formatter_folder = os.path.join(self.parent_folder, "FORMATTER")
        self.gizmo_folder = os.path.join(self.parent_folder, "GIZMO")
        self.monopoly_folder = os.path.join(self.parent_folder, "MONOPOLY")
        self.bananabrain_folder = os.path.join(self.parent_folder, "BananaBrain")
        self.memory_file = "Core_Memory.txt"
        self.config_file = "Config.ini"
        # Default variables
        self.max_retries = 10
        self.temperature = 0.2
        self.gpt_model = "gpt-4"
        self.role_description = "You're name is Gizmo, & you're an AI Lab Assistant. You're an expert in Python code, Raspberry Pi hardware, Commodore 64 hardware, Linux, MacOS, Windows, deep learning, neural networks, Artificial Intelligence, machine learning."
        # Memory buffer variables
        self.buffer = []
        self.memory_file_path = self.memory_folder 
        
    # Handles resource cleanup & program exit
    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        self.print_message("Exiting the program.", "status")
        sys.exit()

    # Check and create required folders
    def folder_checks(self):
        self.print_message("Scanning 'BOOKS' folder...", "status")
        self.ensure_folder_exists('BOOKS')
        self.print_message("Scanning 'MEMORY' folder...", "status")
        self.ensure_folder_exists('MEMORY')
        self.print_message("Scanning 'CONFIG' folder...", "status")
        self.ensure_folder_exists('CONFIG')
        self.print_message("Scanning 'GUI' folder...", "status")
        self.ensure_folder_exists('GUI')
        self.print_message("Scanning 'CLI' folder...", "status")
        self.ensure_folder_exists('CLI')
        self.print_message("Scanning 'SPLITTER' folder...", "status")
        self.ensure_folder_exists('SPLITTER')
        self.print_message("Scanning 'FORMATTER' folder...", "status")
        self.ensure_folder_exists('FORMATTER')
        self.print_message("Scanning 'MONOPOLY' folder...", "status")
        self.ensure_folder_exists('MONOPOLY')
        self.print_message("Scanning 'BananaBrain' folder...", "status")
        self.ensure_folder_exists('BananaBrain')

    # Display initial messages
    def initial_message(self):
        program_name = os.path.basename(__file__).replace('.py', '')
        formatted_program_name = ' '.join(word.capitalize() for word in program_name.split('_'))
        title_message = f"[Initialization] Monkey Head Project: {formatted_program_name} Initialized"
        init_message = (f"Starting '{formatted_program_name}.py'...", "initialization")
        print(f"Monkey Head Project: Gizmo / BananaBrain - {formatted_program_name}")
        self.print_message(title_message, "initialization")
        self.print_message(init_message[0], init_message[1])

    # General-purpose message printing function
    def print_message(self, output_message, message_type):
        # Validation and Error Handling extracted to a separate function
        self.validate_print_message_input(output_message, message_type)
        # Actual message printing
        if message_type.lower() == "alert":
            output_message = f"Alert has been triggered & program may fail!'{output_message}'"
        if message_type.lower() == "user_input":
            return input(f"> {message_type.capitalize()}: {output_message}")
        else:
            print(f"> {message_type.capitalize()}: {output_message}")

    # Handle exceptions & provide debug information
    def handle_exception(self, error_type, function_name):
        self.print_message(f"Function '{function_name}' encountered a {error_type.__name__}.", "debug")
        self.print_message("Manual oversight required!", "alert")
        self.graceful_exit()

    # Validate the inputs to print_message function
    def validate_print_message_input(self, output_message, message_type):
        try:
            if not (isinstance(output_message, str) and isinstance(message_type, str)):
                raise TypeError("Invalid input types for print_message function.")
            elif not output_message.strip() or not message_type.strip():
                raise ValueError("Empty strings are not allowed.")
            valid_message_types = ["initialization", "status", "info", "error", "debug", "alert", "user_input", "query", "summary", "warning", "fatal_error", "shutdown"]
            if message_type.lower() not in valid_message_types:
                raise ValueError("Invalid message_type provided.")
        except (TypeError, ValueError) as e:
            self.print_message(str(e), "error")
            self.graceful_exit()
            
    # Check if a folder exists, & create it if it doesn't
    def ensure_folder_exists(self, folder_name):
        folder_path = os.path.join(self.parent_folder, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            # Checks to see if the folder_name is CONFIG, then creates a default config file.
            if folder_name == "CONFIG":
                default_config = configparser.ConfigParser()
                default_config[self.gpt_model] =
                {
                    self.api_key: self.enter_key
                }
                default_config["settings"] =
                {
                    "default_role_description": "{self.role_description}",
                    "default_model": "{self.gpt_model}",
                    "default_temperature": "{self.temperature}",
                    "file_path": str(self.parent_folder),
                }

                with open(config_path, "w") as f:
                    default_config.write(f)
                self.print_message("Created config file at {self.config_folder}. Please edit config file to better suit your needs.","status")
                self.print_message("Start by adding your OpenAI API key. Then consider changing default role discription. Model used may also be changed.", "status")
                self.print_message("Default role description is '{self.role_description}'","status")
                self.print_message("Default model is '{self.gpt_model}'","status")
            elif folder_name == "MEMORY":
                #Creates 'self.memory_file' txt file in the memory folder ('self.memory_folder')
                #Sets first line of the new memory txt file as "Monkey Head Project: Gizmo / BananaBrain - {formatted_program_name}"
                #Sets second line of the new memory txt file as "Gizmo Core Memory File - Conversation History"
                #Sets third line of the new memory txt file as "Parent Folder: {parent_folder}"
                self.print_message("Created memory file at '{self.memory_folder}' called '{self.memory_file}'.","status")
                self.print_message("Conversation history will be stored in '{self.memory_file}'.", "status")

    @contextmanager
    def load_config(config_path: str = Config.CONFIG_FILE):
        config = configparser.ConfigParser()
        config.read(config_path)
        validate_config(config)
        yield config
        with open(config_path, "w") as configfile:
            config.write(configfile)

    def validate_config(self, config):
        required_sections = "" #Insert list of required sections
        for section in required_sections:
            if section not in config.sections():
                raise ValueError(f"{Config.CONFIG_FILE} is missing the '{section}' section. Please add it with the necessary keys.")

    # OpenAI specific functions
    def get_api_key(self, config):
        if Config.OPENAI_SECTION not in config.sections():
            raise ValueError(f"{Config.CONFIG_FILE} is missing the '{Config.OPENAI_SECTION}' section. Please add it with the '{Config.API_KEY_FIELD}' key.")

        api_key = config.get(Config.OPENAI_SECTION, Config.API_KEY_FIELD) or os.environ.get("OPENAI_API_KEY")

        if not api_key or api_key == Config.ENTER_KEY:
            retries = 0
            while retries < Config.MAX_RETRIES:
                logger.info("No API key found. Please enter your OpenAI API key:")
                api_key = input().strip()
                if api_key:
                    config.set(Config.OPENAI_SECTION, Config.API_KEY_FIELD, api_key)
                    break
                retries += 1
            else:
                raise ValueError("API key validation failed after maximum retries.")

        return api_key


    def get_settings(config):
        if Config.SETTINGS_SECTION not in config.sections():
            raise ValueError(f"{Config.CONFIG_FILE} is missing the '{Config.SETTINGS_SECTION}' section. Please add it with the necessary keys.")

        default_role_description = config.get("settings", "default_role_description")
        default_model = config.get("settings", "default_model")
        default_temperature = config.getfloat("settings", "default_temperature")
        file_path = config.get("settings", "file_path")

        return default_role_description, default_model, default_temperature, file_path

    def validate_question(question: str):
        if not question.strip():
            raise ValueError("The question cannot be empty. Please enter a valid question.")
        if len(question.split()) > self.token_limit:
            raise ValueError("The question is too long. Please enter a question with fewer tokens.")

    def validate_model(model: str):
        if model not in Config.VALID_MODELS:
            raise ValueError(f"The model '{model}' is not valid. Please enter a valid model.")

    def get_openai_answer(input_content, api_key, model="gpt-4"):
        openai.api_key = api_key

        if isinstance(input_content, list):  # Handling conversation history
            messages = input_content
        else:  # Handling single question string
            messages = [{"role": "system", "content": "You're an AI Assistant."}, {"role": "user", "content": input_content}]

        if model in Config.VALID_MODELS:
            response = openai.ChatCompletion.create(
                model=model,
                messages=messages
            )
            return response['choices'][0]['message']['content'].strip()
        else:
            response = openai.Completion.create(
                engine=model,
                prompt=input_content,
                max_tokens=150
            )
            return response.choices[0].text.strip()
    
    # Define Conversation Buffer Memory functions.
    def add_to_buffer(self, role: str, content: str):
        self.buffer.append({"role": role, "content": content})
        self.save_to_memory_file({"role": role, "content": content})

    def get_history(self):
        return self.buffer

    def save_to_memory_file(self, memory: dict):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(self.memory_file, "a") as file:
            file.write(f"{timestamp} - {memory['role']}: {memory['content']}\n") #Temp formatting, please revise.

    # Generate answer to questions asked.
    def generate_answer(api_key, model, role_description, temperature, memory, question):
        self.validate_question(question)
        self.validate_model(model)

        memory.add_to_buffer("user", question)
        conversation_history = memory.get_history()

        answer = OpenAIHelper.get_openai_answer(conversation_history, api_key, model)

        memory.add_to_buffer("assistant", answer)
        return answer
            
    # Main Function
    def main(self):
        try:
            with self.load_config() as config:
                api_key = self.get_api_key(config)
                default_role_description, default_model, default_temperature, file_path = self.get_settings(config)

                memory = ConversationBufferMemory(memory_file_path=file_path)
                memory.add_to_buffer("system", default_role_description)

                while True:
                    self.print_message("Enter a question (or 'N' to exit):", "user_input")
                    question = input().strip()
                    if question.lower() == "n":
                        self.print_message("Exit has been selected.", "shutdown")
                        break

                    for i in range(self.max_retries):
                        try:
                            answer = generate_answer(api_key, default_model, default_role_description, default_temperature, memory, question)
                            self.print_message("\nAnswer: {answer}", "status")
                            break
                        except Exception as e:
                            self.print_massage("Error: {e}", "alert")
                            self.graceful_exit()
                    else:
                        self.print_message("Failed to generate an answer after maximum retries ({self.max_retries}).", "alert")
                        self.graceful_exit()
        finally:
            self.graceful_exit()


# Create instance & run the main loop
if __name__ == '__main__':
    core = CoreGizmo()
    core.main()
