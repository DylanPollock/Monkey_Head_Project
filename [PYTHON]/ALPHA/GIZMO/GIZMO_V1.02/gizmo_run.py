import tkinter as tk
from tkinter import ttk
from gizmo_core import generate_answer, load_config, get_api_key, get_settings, ConversationBufferMemory, create_config_file, create_memory_file

class GizmoApp:
    def __init__(self, root):
        self.root = root
        self.configure_gui()
        self.load_configuration()
        self.create_widgets()

    def configure_gui(self):
        self.root.title("OpenAI Assistant")
        self.root.geometry("800x600")

    def load_configuration(self):
        create_config_file()
        create_memory_file()
        with load_config() as config:
            self.config = config
        self.memory = ConversationBufferMemory(memory_file_path=self.config['settings']['file_path'])
        self.memory.add_to_buffer("system", self.config['settings']['default_role_description'])

    def create_widgets(self):
        # Configuration Section
        self.create_config_section()
        # Conversation Section
        self.create_conversation_section()
        # Action Buttons
        self.create_action_buttons()

    def create_config_section(self):
        ttk.Label(self.root, text="API Key:").grid(row=0, column=0)
        self.api_key_var = tk.StringVar(value=self.config['openai']['api_key'])
        self.api_key_entry = ttk.Entry(self.root, textvariable=self.api_key_var)
        self.api_key_entry.grid(row=0, column=1)

        ttk.Label(self.root, text="Model:").grid(row=1, column=0)
        self.model_var = tk.StringVar(value=self.config['settings']['default_model'])
        self.model_combo = ttk.Combobox(self.root, textvariable=self.model_var, values=["gpt-3.5-turbo", "gpt-4"])
        self.model_combo.grid(row=1, column=1)

        ttk.Label(self.root, text="Temperature:").grid(row=2, column=0)
        self.temperature_var = tk.DoubleVar(value=self.config['settings']['default_temperature'])
        self.temperature_slider = ttk.Scale(self.root, from_=0.0, to_=1.0, variable=self.temperature_var, orient="horizontal")
        self.temperature_slider.grid(row=2, column=1)

    def create_conversation_section(self):
        self.conversation_text = tk.Text(self.root, wrap=tk.WORD, height=20, width=100)
        self.conversation_text.grid(row=3, column=0, columnspan=2)

        ttk.Label(self.root, text="Enter a question:").grid(row=4, column=0)
        self.question_var = tk.StringVar()
        self.question_entry = ttk.Entry(self.root, textvariable=self.question_var, width=80)
        self.question_entry.grid(row=4, column=1)

    def create_action_buttons(self):
        self.submit_button = ttk.Button(self.root, text="Submit", command=self.submit_question)
        self.submit_button.grid(row=5, column=0)

        self.quit_button = ttk.Button(self.root, text="Quit", command=self.root.quit)
        self.quit_button.grid(row=5, column=1)

    def submit_question(self):
        question = self.question_var.get()
        if question.strip() == "":
            self.conversation_text.insert(tk.END, "Error: Question cannot be empty.\n")
            return
        self.conversation_text.insert(tk.END, f"You: {question}\n")
        try:
            answer = generate_answer(
                self.config['openai']['api_key'],
                self.config['settings']['default_model'],
                self.config['settings']['default_role_description'],
                self.config['settings']['default_temperature'],
                self.memory,
                question
            )
            self.conversation_text.insert(tk.END, f"AI Assistant: {answer}\n")
        except Exception as e:
            self.conversation_text.insert(tk.END, f"Error: {str(e)}\n")

def run_app():
    root = tk.Tk()
    app = GizmoApp(root)
    root.mainloop()

if __name__ == "__main__":
    run_app()
