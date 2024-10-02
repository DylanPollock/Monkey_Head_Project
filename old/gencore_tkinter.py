import tkinter as tk
from tkinter import ttk
from gizmo_core import generate_answer, load_config, get_api_key, get_settings, ConversationBufferMemory, create_config_file, create_memory_file

class GizmoApp:
    def __init__(self, root):
        self.root = root
        self.configure_gui()
        self.load_configuration()
        self.create_frames()

    def configure_gui(self):
        self.root.title("Gizmo")  # Change title
        self.root.geometry("800x600")
        self.root.resizable(True, True)  # Make window resizable

    def load_configuration(self):
        create_config_file()
        create_memory_file()
        with load_config() as config:
            self.config = config
        self.memory = ConversationBufferMemory(memory_file_path=self.config['settings']['file_path'])
        self.memory.add_to_buffer("system", self.config['settings']['default_role_description'])

    def create_frames(self):
        # Configuration Frame
        self.config_frame = ttk.LabelFrame(self.root, text="Configuration", padding="10")
        self.config_frame.grid(row=0, column=0, sticky="ew", padx=10, pady=5)
        self.create_config_section()
        # Conversation Frame
        self.conversation_frame = ttk.LabelFrame(self.root, text="Conversation", padding="10")
        self.conversation_frame.grid(row=1, column=0, sticky="nsew", padx=10, pady=5)
        self.create_conversation_section()
        # Action Frame
        self.action_frame = ttk.Frame(self.root, padding="10")
        self.action_frame.grid(row=2, column=0, sticky="ew", padx=10, pady=5)
        self.create_action_buttons()

    def create_config_section(self):
        ttk.Label(self.config_frame, text="AI Role:").grid(row=0, column=0, sticky="w", padx=5, pady=2)
        self.role_var = tk.StringVar(value=self.config['settings']['default_role_description'])
        self.role_entry = ttk.Entry(self.config_frame, textvariable=self.role_var)
        self.role_entry.grid(row=0, column=1, sticky="ew", padx=5, pady=2)

        ttk.Label(self.config_frame, text="Model:").grid(row=1, column=0, sticky="w", padx=5, pady=2)
        self.model_var = tk.StringVar(value=self.config['settings']['default_model'])
        self.model_combo = ttk.Combobox(self.config_frame, textvariable=self.model_var, values=["gpt-3.5-turbo", "gpt-4"])
        self.model_combo.grid(row=1, column=1, sticky="ew", padx=5, pady=2)

        ttk.Label(self.config_frame, text="Temperature:").grid(row=2, column=0, sticky="w", padx=5, pady=2)
        self.temperature_var = tk.StringVar(value=str(self.config.getfloat('settings', 'default_temperature')))
        self.temperature_slider = ttk.Scale(self.config_frame, from_=0.0, to_=1.0, variable=self.temperature_var, orient="horizontal", command=self.update_temperature_label)
        self.temperature_slider.grid(row=2, column=1, sticky="ew", padx=5, pady=2)
        self.temperature_value_label = ttk.Label(self.config_frame, textvariable=self.temperature_var)
        self.temperature_value_label.grid(row=2, column=2, padx=5, pady=2)

        self.config_frame.columnconfigure(1, weight=1)  # Make the second column expandable

    def update_temperature_label(self, value):
        self.temperature_var.set(value)  # Update the temperature label

    def create_conversation_section(self):
        self.conversation_text = tk.Text(self.conversation_frame, wrap=tk.WORD, height=20)
        self.conversation_text.grid(row=0, column=0, columnspan=2, sticky="nsew", padx=5, pady=2)

        ttk.Label(self.conversation_frame, text="Enter a question:").grid(row=1, column=0, sticky="w", padx=5, pady=2)
        self.question_var = tk.StringVar()
        self.question_entry = ttk.Entry(self.conversation_frame, textvariable=self.question_var)
        self.question_entry.grid(row=1, column=1, sticky="ew", padx=5, pady=2)

        self.conversation_frame.columnconfigure(1, weight=1)  # Make the second column expandable

    def create_action_buttons(self):
        self.submit_button = ttk.Button(self.action_frame, text="Submit", command=self.submit_question)
        self.submit_button.grid(row=0, column=0, padx=5, pady=5)

        self.quit_button = ttk.Button(self.action_frame, text="Quit", command=self.root.quit)
        self.quit_button.grid(row=0, column=1, padx=5, pady=5)

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
            self.conversation_text.insert(tk.END, f"Gizmo: {answer}\n")  # Use Gizmo instead of AI Assistant
        except Exception as e:
            self.conversation_text.insert(tk.END, f"Error: {str(e)}\n")

def run_app():
    root = tk.Tk()
    app = GizmoApp(root)
    root.mainloop()

if __name__ == "__main__":
    run_app()
