
# Importing required libraries
import os
import glob
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class
class ChapterSplitter:
    def __init__(self):
        print("Gizmo / BananaBrain - Chapter Splitter")
        print("Checking BOOKS folder...")
        self.ensure_folder_exists('BOOKS')
        print("Checking MEMORY folder...")
        self.ensure_folder_exists('MEMORY')
        
    def ensure_folder_exists(self, folder_name):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        folder_path = os.path.join(parent_dir, '..', folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
    def list_available_files(self):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        text_files = glob.glob(os.path.join(parent_dir, '..', 'BOOKS', '*.txt'))
        memory_files = glob.glob(os.path.join(parent_dir, '..', 'MEMORY', '*.txt'))
        memory_file_names = [os.path.basename(f).replace('MEMORY-', '') for f in memory_files]
        
        if not text_files:
            print("No text files found in 'BOOKS' directory.")
            exit()

        print("OUTPUT: Printing \"BOOKS\" content list...")
        available_files = []
        for idx, file in enumerate(text_files):
            if os.path.basename(file) not in memory_file_names:
                available_files.append(file)
                print(f"{len(available_files)}. {os.path.basename(file)}")
        return available_files

    def get_user_selection(self, text_files):
        while True:
            try:
                print("INPUT: ", end='')
                selection = int(input())
                if 1 <= selection <= len(text_files):
                    return text_files[selection - 1]
            except ValueError:
                pass
            print("Invalid input. Please try again.")
            
    def split_chapters(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
        sentences = sent_tokenize(text)
        formatted_text = "\n".join([f"{i+1:04d}| {sentence}" for i, sentence in enumerate(sentences) if sentence.strip()]) + "\n"
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        new_file_name = f"MEMORY-{os.path.basename(file_path)}"
        book_title, book_author, chapter = self.parse_file_name(os.path.basename(file_path))
        with open(os.path.join(parent_dir, '..', 'MEMORY', new_file_name), 'w', encoding='utf-8') as file:
            file.write(f"0000| {book_title} - {book_author} - {chapter}\n" + formatted_text)
        print("UPDATE: Initial format complete.")

    def parse_file_name(self, file_name):
        parts = file_name.split('-')
        if len(parts) == 3:
            return parts[0].strip(), parts[1].strip(), parts[2].replace('.txt', '').strip()
        else:
            print(f"QUESTION: Who was {file_name.replace('.txt', '')} written by?")
            print("INPUT: ", end='')
            return file_name.replace('.txt', ''), input(), ''
        
    def final_check(self, new_file_name):
        corrected_lines = 0
        malformed_lines = 0
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(parent_dir, '..', 'MEMORY', new_file_name)
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        for i, line in enumerate(lines):
            tokens = line.split("|", 1)
            if len(tokens) != 2 or not tokens[0].isdigit() or not tokens[1].strip():
                malformed_lines += 1
                corrected_lines += 1
                lines[i] = f"{i:04d}| {tokens[-1].strip()}"
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)
        if malformed_lines:
            print(f"WARNING: {malformed_lines} MALFORMED LINES FOUND!")
            print(f"WARNING: {corrected_lines} LINES CORRECTED!")
            print(f"WARNING: {malformed_lines - corrected_lines} LINES REMAIN MALFORMED!")

    def extra_check(self, new_file_name):
        corrected_lines = 0
        malformed_lines = 0
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(parent_dir, '..', 'MEMORY', new_file_name)
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        for i, line in enumerate(lines):
            tokens = line.split("|", 1)
            if len(tokens) != 2 or not tokens[0].isdigit() or not tokens[1].strip():
                corrected_lines += 1
                lines[i] = f"{i:04d}| {tokens[-1].strip()}"
                malformed_lines += 1
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)
        print("UPDATE: Extra check complete.")
        print(f"WARNING: {corrected_lines} MALFORMED LINES CORRECTED!")
        if malformed_lines != 0:
            print(f"WARNING: {malformed_lines} MALFORMED LINES REMAIN!")
            print(f"WARNING: HUMAN OVERSIGHT REQUIRED!")
            exit()

    def main(self):
        while True:
            text_files = self.list_available_files()
            selected_file = self.get_user_selection(text_files)
            self.split_chapters(selected_file)
            new_file_name = f"MEMORY-{os.path.basename(selected_file)}"
            self.final_check(new_file_name)
            parent_dir = os.path.dirname(os.path.abspath(__file__))
            file_path = os.path.join(parent_dir, '..', 'MEMORY', new_file_name)
            with open(file_path, 'r', encoding='utf-8') as file:
                lines = file.readlines()
            
            if len(lines) < 2 or not lines[0].startswith("0000|"):
                print(f"WARNING: FAILED FORMATTING (NEEDS HUMAN OVERSIGHT)!")
                continue
            
            print(f'UPDATE: Successfully reformatted "{os.path.basename(selected_file)}"')
            print(f'UPDATE: New file was created in memory called "{new_file_name}"')
            
            print("QUESTION: Do you want to reformat another text file? (y/n)")
            print("INPUT: ", end='')
            decision = input()
            if decision.lower() == 'n':
                break

# Create instance and run the main loop
if __name__ == '__main__':
    splitter = ChapterSplitter()
    splitter.main()
