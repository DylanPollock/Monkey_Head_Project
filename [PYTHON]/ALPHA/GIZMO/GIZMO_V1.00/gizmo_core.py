import configparser
import datetime
import os
import time
from contextlib import contextmanager
from pathlib import Path
import openai
import logging

class Config:
    VALID_MODELS = frozenset({"gpt-3.5-turbo", "gpt-4"})
    TOKEN_LIMIT = 4096
    ENTER_KEY = "enter_key"
    MEMORY_FILE = "MEMORY.txt"
    CONFIG_FILE = "config.ini"
    OPENAI_SECTION = "openai"
    SETTINGS_SECTION = "settings"
    API_KEY_FIELD = "api_key"
    MAX_RETRIES = 5
    BACKOFF_FACTOR = 1.5

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger(__name__)

class Configuration:
    def __init__(self, config_path: str = Config.CONFIG_FILE):
        self.config = configparser.ConfigParser()
        self.config_path = config_path
        self.load_config()

    def load_config(self):
        self.config.read(self.config_path)
        self.validate_config()
        
    def validate_config(self):
        required_sections = [Config.OPENAI_SECTION, Config.SETTINGS_SECTION]
        for section in required_sections:
            if section not in self.config.sections():
                raise ValueError(f"{Config.CONFIG_FILE} is missing the '{section}' section. Please add it with the necessary keys.")

    def get_api_key(self):
        if Config.OPENAI_SECTION not in self.config.sections():
            raise ValueError(f"{Config.CONFIG_FILE} is missing the '{Config.OPENAI_SECTION}' section. Please add it with the '{Config.API_KEY_FIELD}' key.")
        api_key = self.config.get(Config.OPENAI_SECTION, Config.API_KEY_FIELD) or os.environ.get("OPENAI_API_KEY")
        if not api_key or api_key == Config.ENTER_KEY:
            raise ValueError("API key validation failed.")
        return api_key

    def get_settings(self):
        if Config.SETTINGS_SECTION not in self.config.sections():
            raise ValueError(f"{Config.CONFIG_FILE} is missing the '{Config.SETTINGS_SECTION}' section. Please add it with the necessary keys.")
        default_role_description = self.config.get(Config.SETTINGS_SECTION, "default_role_description")
        default_model = self.config.get(Config.SETTINGS_SECTION, "default_model")
        default_temperature = self.config.getfloat(Config.SETTINGS_SECTION, "default_temperature")
        file_path = self.config.get(Config.SETTINGS_SECTION, "file_path")
        return default_role_description, default_model, default_temperature, file_path

class Gizmo:
    def __init__(self):
        self.config = Configuration()
        self.memory = ConversationBufferMemory()
        self.default_role_description, self.default_model, self.default_temperature, self.file_path = self.config.get_settings()
        self.memory.add_to_buffer("system", self.default_role_description)
        self.api_key = self.config.get_api_key()

    def ask_question(self, question: str):
        try:
            answer = generate_answer(self.api_key, self.default_model, self.default_role_description, self.default_temperature, self.memory, question)
            return answer
        except Exception as e:
            logger.error(f"Error: {e}")
            return None

class ConversationBufferMemory:
    def __init__(self, memory_file_path: str = Config.MEMORY_FILE):
        self.buffer = []
        self.memory_file_path = memory_file_path

    def add_to_buffer(self, role: str, content: str):
        self.buffer.append({"role": role, "content": content})
        self.save_to_memory_file({"role": role, "content": content})

    def get_history(self):
        return self.buffer

    def save_to_memory_file(self, memory: dict):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(self.memory_file_path, "a") as file:
            file.write(f"{timestamp} - {memory['role']}: {memory['content']}\n")

class OpenAIHelper:
    @staticmethod
    def validate_question(question: str):
        if not question.strip():
            raise ValueError("The question cannot be empty. Please enter a valid question.")
        if len(question.split()) > Config.TOKEN_LIMIT:
            raise ValueError("The question is too long. Please enter a question with fewer tokens.")

    @staticmethod
    def validate_model(model: str):
        if model not in Config.VALID_MODELS:
            raise ValueError(f"The model '{model}' is not valid. Please enter a valid model.")

    @staticmethod
    def get_openai_answer(input_content, api_key, model="gpt-4"):
        openai.api_key = api_key
        if isinstance(input_content, list):
            messages = input_content
        else:
            messages = [{"role": "system", "content": "You're an AI Assistant."}, {"role": "user", "content": input_content}]
        if model in Config.VALID_MODELS:
            response = openai.ChatCompletion.create(model=model, messages=messages)
            return response['choices'][0]['message']['content'].strip()
        else:
            response = openai.Completion.create(engine=model, prompt=input_content, max_tokens=150)
            return response.choices[0].text.strip()

def generate_answer(api_key, model, role_description, temperature, memory, question):
    OpenAIHelper.validate_question(question)
    OpenAIHelper.validate_model(model)
    memory.add_to_buffer("user", question)
    conversation_history = memory.get_history()
    answer = OpenAIHelper.get_openai_answer(conversation_history, api_key, model)
    memory.add_to_buffer("assistant", answer)
    return answer

if __name__ == "__main__":
    gizmo = Gizmo()
    while True:
        print("\nEnter a question (or 'quit' to exit):")
        question = input().strip()
        if question.lower() == "quit":
            print("\nThank you for using the service. Goodbye!")
            break
        answer = gizmo.ask_question(question)
        if answer:
            print(f"\nAnswer: {answer}")
