
# Importing required libraries
import os
import glob
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class
class ChapterSplitter:
    def __init__(self):
        self.ensure_folder_exists('BOOKS')
        self.ensure_folder_exists('MEMORY')
        
    def ensure_folder_exists(self, folder_name):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        folder_path = os.path.join(parent_dir, '..', folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
    def list_available_files(self):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        text_files = glob.glob(os.path.join(parent_dir, '..', 'BOOKS', '*.txt'))
        if not text_files:
            print("No text files found in 'BOOKS' directory.")
            exit()
        for idx, file in enumerate(text_files):
            print(f"{idx+1}. {os.path.basename(file)}")
        return text_files
    
    def get_user_selection(self, text_files):
        while True:
            try:
                selection = int(input("Select a text file by entering its corresponding number: "))
                if 1 <= selection <= len(text_files):
                    return text_files[selection - 1]
            except ValueError:
                pass
            print("Invalid input. Please try again.")
            
    def split_chapters(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
        sentences = sent_tokenize(text)
        formatted_text = "\n".join([f"{i+1:04d}| {sentence}" for i, sentence in enumerate(sentences)])
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        with open(os.path.join(parent_dir, '..', 'MEMORY', os.path.basename(file_path)), 'w', encoding='utf-8') as file:
            file.write("0000| Book_Title - Book_Author - Chapter #\n" + formatted_text)
        print("Update: Initial format complete.")
        
    def final_check(self, file_path):
        corrected_lines = 0
        malformed_lines = 0
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        for i, line in enumerate(lines):
            tokens = line.split("|", 1)
            if len(tokens) != 2 or not tokens[0].isdigit():
                malformed_lines += 1
                corrected_lines += 1
                lines[i] = f"{i:04d}| {tokens[-1]}"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)
        if malformed_lines:
            print(f"Warning: {malformed_lines} malformed lines found.")
            print(f"Warning: {corrected_lines} lines corrected.")
            print(f"Warning: {malformed_lines - corrected_lines} lines remain malformed!")
            
    def extra_check(self, file_path):
        corrected_lines = 0
        malformed_lines = 0
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        for i, line in enumerate(lines):
            tokens = line.split("|", 1)
            if len(tokens) != 2 or not tokens[0].isdigit():
                corrected_lines += 1
                lines[i] = f"{i:04d}| {tokens[-1]}"
                malformed_lines += 1
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)
        print(f"Update: Extra check complete.")
        print(f"Warning: {corrected_lines} malformed lines corrected.")
        if malformed_lines != 0:
            print(f"Warning: {malformed_lines} malformed lines remain.")
            print(f"Warning: HUMAN OVERSIGHT REQUIRED!")
            
    def main(self):
        while True:
            text_files = self.list_available_files()
            selected_file = self.get_user_selection(text_files)
            self.split_chapters(selected_file)
            parent_dir = os.path.dirname(os.path.abspath(__file__))
            self.final_check(os.path.join(parent_dir, '..', 'MEMORY', os.path.basename(selected_file)))
            
            with open(os.path.join(parent_dir, '..', 'MEMORY', os.path.basename(selected_file)), 'r', encoding='utf-8') as file:
                lines = file.readlines()
            
            if len(lines) < 2 or not lines[0].startswith("0000|"):
                print("Failed formatting (needs human oversight).")
                continue
            
            print(f"Successfully reformatted '{os.path.basename(selected_file)}'.")
            
            decision = input("Do you want to reformat another text file? (y/n): ")
            if decision.lower() == 'n':
                break

# Create instance and run the main loop
if __name__ == '__main__':
    splitter = ChapterSplitter()
    splitter.main()
