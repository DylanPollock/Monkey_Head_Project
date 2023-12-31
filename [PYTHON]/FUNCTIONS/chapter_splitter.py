import os
import sys
import glob
import atexit
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class
class ChapterSplitter:
    def __init__(self, encoding='utf-8'):
        self.encoding = encoding
        self.initial_message()
        self.initial_variable()
        self.folder_checks()
        atexit.register(self.graceful_exit)

    # Initialize important variables
    def initial_variable(self):
        self.program_name = os.path.abspath(__file__)
        self.current_folder = os.path.dirname(os.path.abspath(__file__))
        self.parent_folder = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.books_folder = os.path.join(self.parent_folder, "BOOKS")
        self.memory_folder = os.path.join(self.parent_folder, "MEMORY")

    # Handles resource cleanup and program exit
    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        self.print_message("Exiting the program.", "status")
        sys.exit()

    # A helper function to display progress bars
    def progress(self, current, total, status=""):
        bar_length = 60
        progress = float(current) / total
        arrow = "=" * int(round(progress * bar_length) - 1)
        spaces = " " * (bar_length - len(arrow))
        sys.stdout.write(f"Progress: [{arrow}{spaces}] {int(progress * 100)}% {status}\r")
        sys.stdout.flush()

    # Check and create required folders
    def folder_checks(self):
        self.print_message("Scanning 'BOOKS' folder for new files...", "status")
        self.ensure_folder_exists('BOOKS')
        self.print_message("Scanning 'MEMORY' folder...", "status")
        self.ensure_folder_exists('MEMORY')

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
            
    # Check if a folder exists, and create it if it doesn't
    def ensure_folder_exists(self, folder_name):
        folder_path = os.path.join(self.parent_folder, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
        # List available text files for processing
    def list_available_files(self):
        text_files = glob.glob(os.path.join(self.books_folder, '*.txt'))
        memory_files = glob.glob(os.path.join(self.memory_folder, '*.txt'))
        memory_file_names = [os.path.basename(f).replace('MEMORY-', '') for f in memory_files]
        
        if not text_files:
            self.print_message("No new text files detected in 'BOOKS' folder.", "info")
            return []
        
        self.print_message("Displaying content list of 'BOOKS' folder...", "info")
        available_files = [file for file in text_files if os.path.basename(file) not in memory_file_names]
        for idx, file in enumerate(available_files):
            self.print_message(f"{idx + 1}. {os.path.basename(file)}", "status")
        return available_files

    # Handle exceptions and provide debug information
    def handle_exception(self, error_type, function_name):
        self.print_message(f"Function '{function_name}' encountered a {error_type.__name__}.", "debug")
        self.print_message("Manual oversight required!", "alert")
        self.graceful_exit()

    # Get user's selection from the available files
    def get_user_selection(self, text_files):
        if not text_files:
            self.handle_exception(ValueError, "get_user_selection")

        user_input = input("Select a file by its number, or enter 'a' to process all: ")

        if user_input.lower() == 'a':
            return 'all'

        try:
            selection = int(user_input) - 1
            if selection < 0 or selection >= len(text_files):
                raise ValueError("Invalid selection.")
        except ValueError:
            self.handle_exception(ValueError, "get_user_selection")
            
        return text_files[selection]


    # Extract or request necessary information from the file name
    def parse_file_name(self, file_name):
        parts = file_name.split('-')
        if len(parts) == 3:
            return parts[0].strip(), parts[1].strip(), parts[2].replace('.txt', '').strip()
        
        paper_name = self.print_message("What is the paper's name?", "user_input")
        paper_author = self.print_message("Who authored the paper?", "user_input")
        paper_chapter = self.print_message("What chapter of the paper is this?", "user_input")
        return paper_name, paper_author, paper_chapter

    # Split the file into chapters and sentences
    def split_chapters(self, file_path):
        book_title, book_author, chapter = self.parse_file_name(os.path.basename(file_path))
        new_file_name = f"MEMORY-{os.path.basename(file_path)}"
        
        with open(file_path, 'r', encoding='utf-8') as file:
            raw_text = file.read()
        
        sentences = sent_tokenize(raw_text)
        formatted_text = [f"{i+1:04d}| {sentence}" for i, sentence in enumerate(sentences)]
        
        complete_text = f"0000| {book_title} - {book_author} - {chapter}\n" + "\n".join(formatted_text)
        with open(os.path.join(self.memory_folder, new_file_name), 'w', encoding='utf-8') as file:
            file.write(complete_text)

    # Perform a digit check to validate the format of the text file
    def digit_check(self, txt_name):
        self.print_message("Digit check underway...", "status")
        failed_lines = 0
        is_sequential = True
        prev_number = -1
        file_path = os.path.join(self.memory_folder, txt_name)
        
        with open(file_path, 'r') as file:
            lines = file.readlines()
        
        for i, line in enumerate(lines):
            try:
                current_number = int(line[:4])
                if prev_number >= current_number:
                    is_sequential = False
                    self.print_message(f"Non-sequential line numbers detected at line {i+1}. Prev: {prev_number}, Current: {current_number}", "debug")
                prev_number = current_number
            except ValueError:
                failed_lines += 1
                self.print_message(f"Line {i+1} failed the digit check: {line.strip()}", "debug")
        
        self.print_message("Digit check done.", "status")
        if failed_lines == 0 and is_sequential:
            self.print_message("The text file has passed all digit format checks.", "status")
            return True
        elif is_sequential == True:
            self.print_message("The text file has passed the sequntial order format checks.", "status")
            self.print_message("The text file has failed the line format checks.", "warning")
            return True
        elif is_sequential == False:
            self.print_message("The text file has failed digit format checks.", "warning")
            return False
        else:
            self.print_message("Improper 'digit_check' function input! Program will now close!", "alert")
            graceful_exit()

    # Perform final formatting checks on the text file
    def format_attempt(self, file_name):
        return self.digit_check(file_name)

    # Correct the format of the text file if needed
    def correct_format(self, file_path):
        self.print_message("Triggering format corrector.", "status")
        corrected_lines = []
        malformed_lines = 0
        prev_line = None
        prev_malformed_lines = float('inf')  # Initialize to infinity for comparison
        
        with open(file_path, 'r') as f:
            lines = f.readlines()

        for line in lines:
            line = line.strip()

            if line.startswith("0000| ") or line == '':
                continue

            if not line[:5].isdigit() and '|' not in line:
                malformed_lines += 1

            if not line[:5].isdigit() and '|' not in line:
                if prev_line is not None:
                    prev_line = f"{prev_line} {line}"
                    continue
            else:
                if prev_line is not None:
                    corrected_lines.append(prev_line)

            prev_line = line

        if prev_line is not None:
            corrected_lines.append(prev_line)

        if malformed_lines >= prev_malformed_lines:
            self.print_message("Algorithm failed to correct malformed lines.", "warning")
            return False
        else:
            with open(file_path, 'w') as f:
                f.write("\n".join(corrected_lines))
            return True
        
    # Main function that orchestrates the text file processing
    def main(self):
        text_files = self.list_available_files()
        
        if not text_files:
            self.print_message("No files available for processing in 'BOOKS' folder. Exiting.", "alert")
            return
        
        self.print_message(f"Found {len(text_files)} new text files. Starting processing...", "status")
        
        selected_files = []
        
        user_selection = self.get_user_selection(text_files)
        
        if user_selection == 'all':
            selected_files = text_files
        else:
            selected_files.append(user_selection)
        
        for selected_file in selected_files:
            self.split_chapters(selected_file)
            new_file_name = f"MEMORY-{os.path.basename(selected_file)}"
            
        if self.correct_format(os.path.join(self.memory_folder, new_file_name)) == True:
            self.print_message("Program has formatted text file.", "status")
        elif self.correct_format(os.path.join(self.memory_folder, new_file_name)) == False:
            self.print_message("Program failed to format text file properly.", "status")
        else:
            self.print_message("Improper 'main' function input! Program will now close!", "alert")
            graceful_exit()

# Create instance and run the main loop
if __name__ == '__main__':
    splitter = ChapterSplitter()
    splitter.main()
