import datetime
import os
import time
from contextlib import contextmanager
import openai
import logging
from gizmo_memory import Config

logger = logging.getLogger(__name__)

def create_file(file_path: str):
    if not Path(file_path).exists():
        Path(file_path).touch()

def create_memory_file(memory_file_path: str = Config.MEMORY_FILE):
    create_file(memory_file_path)

def create_config_file(config_path: str = Config.CONFIG_FILE):
    if not Path(config_path).exists():
        cwd = Path.cwd()
        default_config = configparser.ConfigParser()
        default_config[Config.OPENAI_SECTION] = {
            Config.API_KEY_FIELD: Config.ENTER_KEY,
        }
        default_config[Config.SETTINGS_SECTION] = {
            "default_role_description": "You're an AI Assistant.",
            "default_model": "gpt-4",
            "default_temperature": 0.2,
            "file_path": str(cwd / Config.MEMORY_FILE),
        }

        with open(config_path, "w") as f:
            default_config.write(f)
    required_sections = [Config.OPENAI_SECTION, Config.SETTINGS_SECTION]
    for section in required_sections:
        if section not in config.sections():
            raise ValueError(f"{Config.CONFIG_FILE} is missing the '{section}' section. Please add it with the necessary keys.")

def get_api_key(config):
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

    default_role_description = config.get(Config.SETTINGS_SECTION, "default_role_description")
    default_model = config.get(Config.SETTINGS_SECTION, "default_model")
    default_temperature = config.getfloat(Config.SETTINGS_SECTION, "default_temperature")
    file_path = config.get(Config.SETTINGS_SECTION, "file_path")

    return default_role_description, default_model, default_temperature, file_path

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

def generate_answer(api_key, model, role_description, temperature, memory, question):
    OpenAIHelper.validate_question(question)
    OpenAIHelper.validate_model(model)

    memory.add_to_buffer("user", question)
    conversation_history = memory.get_history()

    answer = OpenAIHelper.get_openai_answer(conversation_history, api_key, model)

    memory.add_to_buffer("assistant", answer)
    return answer

def main():
    create_config_file()
    create_memory_file()

    with load_config() as config:
        api_key = get_api_key(config)
        default_role_description, default_model, default_temperature, file_path = get_settings(config)

        memory = ConversationBufferMemory(memory_file_path=file_path)
        memory.add_to_buffer("system", default_role_description)

        while True:
            print("\nEnter a question (or 'quit' to exit):")
            question = input().strip()
            if question.lower() == "quit":
                print("\nThank you for using the service. Goodbye!")
                break

            for i in range(Config.MAX_RETRIES):
                try:
                    answer = generate_answer(api_key, default_model, default_role_description, default_temperature, memory, question)
                    print(f"\nAnswer: {answer}")
                    break
                except Exception as e:
                    logger.error(f"Error: {e}")
                    time.sleep(Config.BACKOFF_FACTOR * (i + 1))  # Exponential backoff
            else:
                logger.error("Failed to generate an answer after maximum retries.")

if __name__ == "__main__":
    main()
