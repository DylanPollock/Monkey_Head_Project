# Importing required libraries
import os
import sys
import glob
from nltk.tokenize import sent_tokenize

# Global variables.
parent_folder_name = os.path.dirname(os.path.abspath(__file__))
books_folder = (os.path.dirname(os.path.abspath(__file__)) + "\BOOKS")
memory_folder = (os.path.dirname(os.path.abspath(__file__)) + "\MEMORY")

# Define ChapterSplitter class.
class ChapterSplitter:
    def __init__(self):
        # Initial message to the user, displaying project name & program being run.
        print("Monkey Head Project - Gizmo / BananaBrain - 'Chapter Splitter'")
        # BOOKS & MEMORY folder checks
        print("UPDATE: Checking 'BOOKS' folder...")
        self.ensure_folder_exists('BOOKS')
        print("UPDATE: Checking 'MEMORY' folder...")
        self.ensure_folder_exists('MEMORY')
        
    def ensure_folder_exists(self, folder_name):
        # Figures out parent directory name
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        # Sets the global variable for the parent folder, & the sister folders BOOKS & MEMORY.
        parent_folder_name = parent_dir
        books_folder = (os.path.dirname(os.path.abspath(__file__)) + "\BOOKS")
        memory_folder = (os.path.dirname(os.path.abspath(__file__)) + "\MEMORY")
        # Checks folder name to see if it exists as a sister folder, & if it doesnt the folder is created.
        folder_path = os.path.join(parent_dir, '..', folder_name)
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            
    def list_available_files(self):
        # Sets parent directory using global variable.
        parent_dir = parent_folder_name
        # Creates a list of text files located in the BOOKS folder.
        text_files = glob.glob(os.path.join(parent_dir, '..', 'BOOKS', '*.txt'))
        # Creates a list of text files located in the MEMORY folder
        memory_files = glob.glob(os.path.join(parent_dir, '..', 'MEMORY', '*.txt'))
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
            print(f"OUTPUT: Who was '{file_name.replace('.txt', '')}' written by?")
            paper_chapter = input("INPUT: ")
            print("OUTPUT: '{paper_name}' = Paper Name, '{authour_name}' = Paper Authour, {paper_chapter} = Paper Chapter")
            return paper_name, paper_authour, paper_chapter
            
    def split_chapters(self, file_path):
        # Sets directory variables
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        new_file_name = f"MEMORY-{os.path.basename(file_path)}"
        
        # Gets the book title, book author, & chapter from the file name.
        book_title, book_author, chapter = self.parse_file_name(os.path.basename(file_path))

        # Opens the original text file located in the BOOKS directory.
        with open(file_path, 'r', encoding='utf-8') as file:
            raw_text = file.read()
            
        # Creates a list that contains the chapter split into sentences.
        sentences = sent_tokenize(raw_text)
        
        # Creates empty list to add the formatted lines to.
        formatted_text = []
        
        # Runs through the list of split sentences, formats it, then adds it to the new formatted list.
        for i, sentence in enumerate(sentences):
            formatted_line = f"{i+1:04d}| {sentence}"
            formatted_text.append(formatted_line)
        
        # Combines the formatted text and writes it to the new text file located in MEMORY directory.
        complete_text = f"0000| {book_title} - {book_author} - {chapter}\n" + "\n".join(formatted_text)
        with open(os.path.join(parent_dir, '..', 'MEMORY', new_file_name), 'w', encoding='utf-8') as file:
            file.write(complete_text)
        
        print("UPDATE: Initial format complete & chapters have been split into sentences.")

    def digit_check(self, file_path):
        print("UPDATE: Digit check underway...")
        failed_lines = 0
        is_sequential = True
        prev_number = -1  
        # Opens new text file to check format of the start of lines.
        with open(file_path, 'r') as file:
            lines = file.readlines()
        
        for i, line in enumerate(lines):
            # Check the first four characters are digits
            if not line[:4].isdigit():
                failed_lines += 1
                continue
            # Check the fifth character is a "|"
            if line[4] != "|":
                failed_lines += 1
                continue
            # Check the sixth character is a space
            if line[5] != " ":
                failed_lines += 1
                continue
            # Check the seventh character exists and is not a space
            if len(line) < 7 or line[6] == " ":
                failed_lines += 1
                continue
            # Check for sequential order
            current_number = int(line[:4])
            if prev_number >= current_number:
                is_sequential = False
            prev_number = current_number
        
        print(f"WARNING: '{failed_lines}' HAVE FAILED!")
        if is_sequential:
            print("UPDATE: New text document in sequential order.")
        else:
            print("WARNING: NEW TEXT DOCUMENT NOT IN SEQUENTIAL ORDER!")
        print("UPDATE: Digit check complete.")
        # Return True only if no lines failed and the sequence is maintained
        return failed_lines == 0 and is_sequential


    def check_format(self, new_file_name):
        # Sets up parent directory variable, & sister directory variable.
        parent_dir = parent_folder_name 
        file_path = memory_folder
        print(f"UPDATE: Format check is currently underway...")
        print(f"UPDATE: Running initial digit check...")
        # First digit check
        initial_digit_result = self.digit_check(file_path)  
        if initial_digit_result == True:
            print(f"UPDATE: Initial digit checks suggest the file is already properly formatted.")
            print(f"WARNING: CHECK WILL STOP HERE TO PREVENT DATA CORRUPTION!")
            return True
        # First malformed lines check
        print(f"UPDATE: Running initial malformed lines check...")
        corrected_lines = 0
        malformed_lines = 0
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
        # Decides what messages to display depending on results of initial checks.
        if (initial_digit_result == True) and (malformed_lines == 0):
            print(f"UPDATE: Initial digit check was passed, ('{initial_digit_result}' was returned).")
            print(f"UPDATE: Initial malformed lines check was passed, ('{malformed_lines}' was returned).")
            print(f"UPDATE: Formatting successfully complete during first attempt.")
            return True
        elif (initial_digit_result == False) and (malformed_lines != 0):
            print(f"WARNING: INITIAL DIGIT CHECK HAS FAILED!")
            print(f"WARNING: INITIAL DIGIT CHECK RETURNED A RESULT OF '{initial_digit_result}'!")
            print(f"WARNING: INITIAL DIGIT CHECK HAS FAILED!")
            print(f"WARNING: '{malformed_lines}' MALFORMED LINES REMAIN!")
            print(f"UPDATE: Running more formatting checks...")
            continue
        elif (initial_digit_result == True) and (malformed_lines != 0):
            print(f"UPDATE: Initial digit check was passed, ('{initial_digit_result}' was returned).")
            print(f"WARNING: INITIAL DIGIT CHECK HAS FAILED!")
            print(f"WARNING: '{malformed_lines}' MALFORMED LINES REMAIN!")
            print(f"UPDATE: Running more formatting checks...")
            continue
        else:
            print("WARNING: PROGRAM HAS FAILED")
            print("WARNING: FUNCTION 'check_format' HAS RETURNED UNEXPECTED ANSWERS!")
            print("WARNING: INITIAL DIGIT CHECK - '{initial_digit_result}', & INITIAL MALFORMED LINES CHECK - '{malformed_lines}'!")
            print("WARNING: THE TEXT FILE COULD BE CORRUPTED!")
            print("WARNING: HUMAN OVERSIGHT REQUIRED!")
            exit()
        # Final attempt at formatting the text file.
        
        """
        ###
        ### Final formatting attempt logic still to be written based on tests!!
        ###

        """
        # Final checks done to new text file.
        print(f"UPDATE: Final format checks being done.")
        # Resets corrected lines variable to 0.
        corrected_lines = 0
        # Final digit check
        final_digit_result = self.digit_check(file_path)
        print(f"WARNING: FINAL DIGIT CHECK RETURNED A RESULT OF '{final_digit_result}'!")
        # Actions decided by results.
        if (final_digit_result == True):
            print(f"UPDATE: Final digit checks suggest the file is already properly formatted.")
            print(f"WARNING: CHECK WILL STOP HERE TO PREVENT DATA CORRUPTION!")
            return True
        elif (final_digit_result == False):
            print(f"WARNING: FINAL DIGIT CHECK HAS FAILED!")
            print(f"UPDATE: Moving on to final malformed lines check...")
        else:
            print("WARNING: PROGRAM HAS FAILED")
            print("WARNING: FINAL CHECK HAS RETURNED UNEXPECTED ANSWERS!")
            print("WARNING: FINAL DIGIT CHECK - '{final_digit_result}'!")
            print("WARNING: THE TEXT FILE COULD BE CORRUPTED!")
            print("WARNING: HUMAN OVERSIGHT REQUIRED!")
            exit()
        # Final malformed lines check
        if (malformed_lines !=0):
            print(f"WARNING: {malformed_lines} MALFORMED LINES FOUND DURING FINAL CHECK!")
            print(f"WARNING: {corrected_lines} LINES CORRECTED!")
            print(f"WARNING: {malformed_lines - corrected_lines} LINES REMAIN MALFORMED!")
        else:
            print(f"UPDATE: Final check completed successfully.")
            print(f"UPDATE: No inconsistencies found.")
        # Final counts are printed
        print(f"WARNING: {corrected_lines} MALFORMED LINES CORRECTED!")
        print(f"WARNING: {malformed_lines} MALFORMED LINES REMAIN!")
        return
        

    def main(self):
        while True:
            # Gets parent directory from global variable
            parent_dir = parent_folder_name
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
            print(f"WARNING: '{old_file_name}' HAS BEEN SELECTED FOR REFORMATTING!")
            
            # Does all the checks, then returns the result of either True/False
            file_path = os.path.join(parent_dir, '..', 'MEMORY', new_file_name)  
            check_result = self.check_format(new_file_name)
            if check_result == True:
                print(f"UPDATE: '{old_file_name}' has been added to MEMORY.")
            
                print(f"UPDATE: The new file created is named '{new_file_name}'")
            elif (check_result == False):
                print("WARNING: CHECK HAS FAILED")
                print("WARNING: THE TEXT FILE THAT HAS BEEN GENERATED IS NOT PROPERLY FORMATTED!")
                print("WARNING: HUMAN OVERSIGHT REQUIRED!")
                exit()
            else:
                print("WARNING: PROGRAM HAS FAILED")
                print("WARNING: THE CHECK HAS RETURNED AN UNEXPECTED ANSWER OF '{check_result}'!")
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
