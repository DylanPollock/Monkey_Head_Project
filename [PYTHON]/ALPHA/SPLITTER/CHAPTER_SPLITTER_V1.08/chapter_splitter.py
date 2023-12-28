# Importing required libraries
import os
import sys
import glob
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class.
class ChapterSplitter:
    def __init__(self):
        # Initialize global variables
        self.current_folder = os.path.dirname(os.path.abspath(__file__))
        self.parent_folder = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.books_folder = os.path.join(self.parent_folder, "BOOKS")
        self.memory_folder = os.path.join(self.parent_folder, "MEMORY")
        self.corrected_lines = 0
        self.malformed_lines = 0
        # Initial message to the user, displaying project name & program being run.
        print("Monkey Head Project - Gizmo / BananaBrain - 'Chapter Splitter'")
        # BOOKS & MEMORY folder checks
        print("UPDATE: Checking 'BOOKS' folder...")
        self.ensure_folder_exists('BOOKS')
        print("UPDATE: Checking 'MEMORY' folder...")
        self.ensure_folder_exists('MEMORY')
        
    def ensure_folder_exists(self, folder_name):
        # Checks folder name to see if it exists as a sister folder, & if it doesnt the folder is created.
        folder_path = os.path.join(self.parent_folder, folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
    def list_available_files(self):
        # Creates a list of text files located in the BOOKS folder.
        text_files = glob.glob(os.path.join(self.books_folder, '*.txt'))
        # Creates a list of text files located in the MEMORY folder
        memory_files = glob.glob(os.path.join(self.memory_folder, '*.txt'))
        # Checks the two lists, minus "MEMORY-",to see what has already been done.
        memory_file_names = [os.path.basename(f).replace('MEMORY-', '') for f in memory_files]
        if not text_files:
            print("UPDATE: No new text files found in 'BOOKS' directory.")
            return text_files
        # Prints list of avaliable text files to be formatted
        print("UPDATE: Printing 'BOOKS' content list...")
        available_files = []
        for idx, file in enumerate(text_files):
            if os.path.basename(file) not in memory_file_names:
                available_files.append(file)
                print(f"{len(available_files)}. {os.path.basename(file)}")
        return available_files

    def get_user_selection(self, text_files):
        # Check if text_files is empty
        if not text_files:
            print("WARNING: INVALID FUNCTION INPUT!")
            print("UPDATE: Input into the function 'get_user_selection' was 'Empty'.")
            print("WARNING: HUMAN OVERSIGHT REQUIRED!")
            exit()
        while True:
            try:
                # Check for valid range
                print("INPUT: ", end='')
                selection = int(input())
                if 1 <= selection <= len(text_files):
                    return text_files[selection - 1]
                else:
                    print("WARNING: INVALID FUNCTION INPUT!")
                    print("UPDATE: Input into the function 'get_user_selection' was out of valid range.")
                    print("WARNING: HUMAN OVERSIGHT REQUIRED!")
                    exit()
            except ValueError:
                print("WARNING: INVALID FUNCTION INPUT!")
                print("UPDATE: Input into the function 'get_user_selection' triggered a ValueError.")
                print("WARNING: HUMAN OVERSIGHT REQUIRED!")
                exit()

    def parse_file_name(self, file_name):
        # Splits file name into three parts.
        parts = file_name.split('-')
        # Treats information as a book.
        if len(parts) == 3:
            print(f"OUTPUT: '{file_name.replace('.txt', '')}' is in the correct name format for information extraction.")
            print(f"OUTPUT: File will be saved in book format.")
            print("OUTPUT: '{parts[0].strip()}' = Book Name, '{parts[1].strip()}' = Book Authour, {parts[2].replace('.txt', '').strip()} = Book Chapter")
            return parts[0].strip(), parts[1].strip(), parts[2].replace('.txt', '').strip()
        else:
            # Treats information as a paper.
            print(f"OUTPUT: '{file_name.replace('.txt', '')}' is the original name of the text file.")
            # Asks for missing information.
            print(f"OUTPUT: What is the papers name?")
            paper_name = input("INPUT: ")
            print(f"OUTPUT: Who was the paper written by?")
            paper_authour = input("INPUT: ")
            print(f"OUTPUT: What chapter of the paper is it?")
            paper_chapter = input("INPUT: ")
            print("OUTPUT: '{paper_name}' = Paper Name, '{authour_name}' = Paper Authour, {paper_chapter} = Paper Chapter")
            return paper_name, paper_authour, paper_chapter

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
        print("UPDATE: Initial format complete & chapters have been split into sentences.")

    def digit_check(self, txt_name):
        print("UPDATE: Digit check underway...")
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
        
        print(f"WARNING: '{failed_lines}' LINES HAVE FAILED!")
        if failed_lines == 0 and is_sequential:
            print("UPDATE: The text file has passed all format checks.")
            return True
        else:
            print("UPDATE: The text file has failed some format checks.")
            return False

    def extra_format_attempt(self, file_name):
        print("UPDATE: Final format checks being done.")
        final_digit_result = self.digit_check(file_name)
        
        if final_digit_result:
            print("UPDATE: Final digit checks suggest the file is already properly formatted.")
            return True
        else:
            print("WARNING: FINAL DIGIT CHECK HAS FAILED!")
            return False

    def check_format(self, new_file_name):
        print("UPDATE: Format check is currently underway...")
        initial_digit_result = self.digit_check(new_file_name)
        
        if initial_digit_result:
            print("UPDATE: Initial digit checks suggest the file is already properly formatted.")
            return True
        else:
            print("WARNING: INITIAL DIGIT CHECK HAS FAILED!")
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

            # Skip the title line and empty lines
            if line.startswith("0000| ") or line == '':
                continue

            # Identify malformed lines
            if not line[:5].isdigit() and '|' not in line:
                malformed_lines += 1

            # If a string is encountered (no numbering), append it to the previous line
            if not line[:5].isdigit() and '|' not in line:
                if prev_line is not None:
                    prev_line = f"{prev_line}{line}"
                    continue
            else:
                if prev_line is not None:
                    corrected_lines.append(prev_line)

            prev_line = line

        # Add the last line if it's not None
        if prev_line is not None:
            corrected_lines.append(prev_line)

        # Check if the algorithm has improved the text
        if malformed_lines >= prev_malformed_lines:
            print("WARNING: Algorithm failed to correct malformed lines.")
            return False
        else:
            with open(file_path, 'w') as f:
                f.write("\n".join(corrected_lines))
            return True
        
    def main(self):
        while True:
            # Creates a list of text files that haven't been formatted yet.
            text_files = self.list_available_files()
            # Check if text_files is empty
            if not text_files:
                print("WARNING: INVALID FUNCTION INPUT!")
                print("UPDATE: Input into the function 'main' was 'Empty'.")
                print("WARNING: PLEASE ADD MORE FILES TO 'BOOKS' FOLDER!")
                print("WARNING: CHAPTER SPLITTER WILL CLOSE NOW!")
                break
            # Gets the user selection for the input text.
            selected_file = self.get_user_selection(text_files)

            # Splits the text file the user selected into sentances. 
            self.split_chapters(selected_file)
            
            new_file_name = (f"MEMORY-{os.path.basename(selected_file)}")
            old_file_name = f"{os.path.basename(selected_file)}"
            print(f"UPDATE: '{old_file_name}' Hhas been selected for reformatting.")
            
            # Does all the checks, then returns the result of either True/False
            file_path = os.path.join(self.memory_folder, new_file_name)
            if (self.check_format(new_file_name)) == True:
                print(f"UPDATE: '{old_file_name}' has been added to MEMORY.")
                print(f"UPDATE: The new file created is named '{new_file_name}'")
            elif (self.check_format(new_file_name)) == False:
                print("WARNING: THE TEXT FILE THAT HAS BEEN GENERATED IS NOT PROPERLY FORMATTED!")
                print("WARNING: FORMAT CORRECTOR TRIGGERED!")
                self.correct_format(file_path)
            else:
                print("WARNING: PROGRAM HAS FAILED")
                print("WARNING: MAIN FUNCTION HAS RETURNED AN UNEXPECTED ANSWER OF '{self.check_format(new_file_name)}'!")
                print("WARNING: THE TEXT FILE COULD BE CORRUPTED!")
                print("WARNING: HUMAN OVERSIGHT REQUIRED!")
                exit()
                
            # Ends loop if user enters "n" or "N", otherwise it starts again.
            print("OUTPUT: Do you want to reformat another text file? (Y/N)")
            print("INPUT: ", end='')
            decision = input()
            if decision.lower() == 'n':
                break

# Create instance and run the main loop
if __name__ == '__main__':
    splitter = ChapterSplitter()
    splitter.main()
