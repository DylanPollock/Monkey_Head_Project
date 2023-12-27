# Importing required libraries
import os
import sys
import glob
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class.
class ChapterSplitter:
    def __init__(self):
        self.current_folder = os.path.dirname(os.path.abspath(__file__))
        self.parent_folder = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.books_folder = os.path.join(self.parent_folder, "BOOKS")
        self.memory_folder = os.path.join(self.parent_folder, "MEMORY")
        self.corrected_lines = 0
        self.malformed_lines = 0
        self.print_message("Monkey Head Project: Chapter Splitter Initialized", "initialization")
        self.print_message("Scanning 'BOOKS' folder for new files...", "status")
        self.ensure_folder_exists('BOOKS')
        self.print_message("Scanning 'MEMORY' folder...", "status")
        self.ensure_folder_exists('MEMORY')

    def initial_message(self):
        program_name = os.path.basename(__file__).replace('.py', '')
        formatted_program_name = ' '.join(word.capitalize() for word in program_name.split('_'))
        title_message = f"[Initialization] Monkey Head Project: {formatted_program_name} Initialized"
        init_message = (f"Starting '{formatted_program_name}.py'...", "initialization")
        self.print_message(title_message, "initialization")
        self.print_message(init_message[0], init_message[1])

    def print_message(self, output_message, message_type):
        if not (isinstance(output_message, str) and isinstance(message_type, str)) or \
           (not output_message.strip() or not message_type.strip()):
            self.print_message("Invalid input to print_message function. Gracefully exiting.", "error")
            sys.exit()
        valid_message_types = ["initialization", "status", "info", "error", "debug", "alert", "user_input", "query", "summary", "warning", "fatal_error", "shutdown"]
        if message_type.lower() not in valid_message_types:
            self.print_message("Invalid message_type provided. Gracefully exiting.", "error")
            sys.exit()
        if message_type.lower() == "user_input":
            return input(f"> {message_type.capitalize()}: {output_message}")
        else:
            print(f"> {message_type.capitalize()}: {output_message}")
        
    def ensure_folder_exists(self, folder_name):
        folder_path = os.path.join(self.parent_folder, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
    def list_available_files(self):
        text_files = glob.glob(os.path.join(self.books_folder, '*.txt'))
        memory_files = glob.glob(os.path.join(self.memory_folder, '*.txt'))
        memory_file_names = [os.path.basename(f).replace('MEMORY-', '') for f in memory_files]
        if not text_files:
            self.print_message("No new text files detected in 'BOOKS' folder.", "info")
            return text_files
        self.print_message("Displaying content list of 'BOOKS' folder...", "info")
        available_files = []
        for idx, file in enumerate(text_files):
            if os.path.basename(file) not in memory_file_names:
                available_files.append(file)
                self.print_message(f"{len(available_files)}. {os.path.basename(file)}", "status")
        return available_files

    def get_user_selection(self, text_files):
        if not text_files:
            self.print_message("Function 'get_user_selection' received an empty input.", "debug")
            self.print_message("Manual oversight required!", "alert")
            exit()
        while True:
            try:
                self.print_message("Please enter your choice: ", "user_input")
                selection = int(input())
                if 1 <= selection <= len(text_files):
                    return text_files[selection - 1]
                else:
                    self.print_message("Function 'get_user_selection' received an out-of-range input.", "debug")
                    self.print_message("Manual oversight required!", "alert")
                    exit()
            except ValueError:
                self.print_message("Function 'get_user_selection' encountered a ValueError.", "debug")
                self.print_message("Manual oversight required!", "alert")
                exit()

    def parse_file_name(self, file_name):
        parts = file_name.split('-')
        if len(parts) == 3:
            self.print_message(f"'{file_name.replace('.txt', '')}' is a valid file for information extraction. It will be treated as a book.", "info")
            return parts[0].strip(), parts[1].strip(), parts[2].replace('.txt', '').strip()
        else:
            self.print_message(f"'{file_name.replace('.txt', '')}' is the original file name. Additional information needed.", "info")
            paper_name = input(self.print_message("What is the paper's name?", "user_input"))
            paper_author = input(self.print_message("Who authored the paper?", "user_input"))
            paper_chapter = input(self.print_message("What chapter of the paper is this?", "user_input"))
            return paper_name, paper_author, paper_chapter

        def split_chapters(self, file_path):
        new_file_name = f"MEMORY-{os.path.basename(file_path)}"
        book_title, book_author, chapter = self.parse_file_name(os.path.basename(file_path))
        
        with open(file_path, 'r', encoding='utf-8') as file:
            raw_text = file.read()
        
        sentences = sent_tokenize(raw_text)
        formatted_text = [f"{i+1:04d}| {sentence}" for i, sentence in enumerate(sentences)]
        
        complete_text = f"0000| {book_title} - {book_author} - {chapter}\n" + "\n".join(formatted_text)
        with open(os.path.join(self.memory_folder, new_file_name), 'w', encoding='utf-8') as file:
            file.write(complete_text)
        self.print_message("Initial format complete & chapters have been split into sentences.", "status")

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
                prev_number = current_number
            except ValueError:
                failed_lines += 1
                continue

        self.print_message(f"{failed_lines} lines have failed the digit check.", "warning")
        if failed_lines == 0 and is_sequential:
            self.print_message("The text file has passed all format checks.", "status")
            return True
        else:
            self.print_message("The text file has failed some format checks.", "status")
            return False

    def extra_format_attempt(self, file_name):
        self.print_message("Final format checks being done.", "status")
        final_digit_result = self.digit_check(file_name)
        
        if final_digit_result:
            self.print_message("Final digit checks suggest the file is already properly formatted.", "status")
            return True
        else:
            self.print_message("Final digit check has failed.", "warning")
            return False

    def check_format(self, new_file_name):
        self.print_message("Format check is currently underway...", "status")
        initial_digit_result = self.digit_check(new_file_name)
        
        if initial_digit_result:
            self.print_message("Initial digit checks suggest the file is already properly formatted.", "status")
            return True
        else:
            self.print_message("Initial digit check has failed.", "warning")
            return self.extra_format_attempt(new_file_name)

    def correct_format(self, file_path):
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

        
    def main(self):
        while True:
            text_files = self.list_available_files()
            if not text_files:
                self.print_message("No files available for processing in 'BOOKS' folder. Exiting.", "alert")
                break
            selected_file = self.get_user_selection(text_files)
            self.split_chapters(selected_file)
            new_file_name = f"MEMORY-{os.path.basename(selected_file)}"
            old_file_name = os.path.basename(selected_file)
            self.print_message(f"'{old_file_name}' has been selected for reformatting.", "status")
            file_path = os.path.join(self.memory_folder, new_file_name)
            if self.check_format(new_file_name):
                self.print_message(f"Successfully added '{old_file_name}' to MEMORY folder. New file is '{new_file_name}'.", "status")
            elif not self.check_format(new_file_name):
                self.print_message("The generated text file is not properly formatted. Triggering format corrector.", "alert")
                self.correct_format(file_path)
            else:
                self.print_message("An unexpected error occurred. Human oversight required.", "fatal_error")
                exit()
            decision = input(self.print_message("Do you want to reformat another text file? (Y/N)", "user_input"))
            if decision.lower() == 'n':
                break

# Create instance and run the main loop
if __name__ == '__main__':
    splitter = ChapterSplitter()
    splitter.main()
