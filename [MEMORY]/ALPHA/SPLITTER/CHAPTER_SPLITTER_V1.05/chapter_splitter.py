# Importing required libraries
import os
import glob
from nltk.tokenize import sent_tokenize

# Define ChapterSplitter class
class ChapterSplitter:
    def __init__(self):
        print("Gizmo / BananaBrain - Chapter Splitter")
        print("UPDATE: Checking BOOKS folder...")
        self.ensure_folder_exists('BOOKS')
        print("UPDATE: Checking MEMORY folder...")
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
            print("UPDATE: No new text files found in 'BOOKS' directory.")

        print("UPDATE: Printing BOOKS content list...")
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
            print("UPDATE: Invalid number input, please try again.")
            
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
            print(f"OUTPUT: Who was '{file_name.replace('.txt', '')}' written by?")
            print("INPUT: ", end='')
            return file_name.replace('.txt', ''), input(), ''

    def digit_check(self, file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()
        for line in lines:
            if not line[:4].isdigit():
                return False
        return True

    def check_format(self, new_file_name):
        print(f"UPDATE: Format check is currently underway...")
        # Inital format checks.
        print(f"UPDATE: Running inital digit check...")
        # First digit check
        inital_digit_result = self.digit_check(file_path)
        print(f"WARNING: INITAL DIGIT CHECK RETURNED A RESULT OF '{inital_digit_result}'!")
        if (inital_digit_result== True):
            print(f"UPDATE: Inital digit checks suggest the file is already properly formatted.")
            print(f"WARNING: CHECK WILL STOP HERE TO PREVENT DATA CORRUPTION!")
            return True
        # First malformed lines check
        print(f"UPDATE: Running inital malformed lines check...")
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
        print(f"WARNING: INITAL MALFORMED LINES COUNT IS '{malformed_lines}'!")

        # Decides what messages to display depending on results of inital checks.
        if (inital_digit_result == True) and (malformed_lines == 0):
            print(f"UPDATE: Inital digit check was passed, ('{inital_digit_result}' was returned).")
            print(f"UPDATE: Inital malformed lines check was passed, ('{malformed_lines}' was returned).")
            print(f"UPDATE: Formatting successfully complete during first attempt.")
            return True
        elif (inital_digit_result == False) and (malformed_lines != 0):
            print(f"WARNING: INITAL DIGIT CHECK HAS FAILED!")
            print(f"WARNING: '{malformed_lines}' MALFORMED LINES REMAIN!")
            print(f"UPDATE: Running more formatting checks...")
        elif (inital_digit_result == True) and (malformed_lines != 0):
            print(f"UPDATE: Inital digit check was passed, ('{inital_digit_result}' was returned).")
            print(f"WARNING: '{malformed_lines}' MALFORMED LINES REMAIN!")
            print(f"UPDATE: Running more formatting checks...")
        else:
            print("WARNING: PROGRAM HAS FAILED")
            print("WARNING: INITAL CHECK HAS RETURNED UNEXPECTED ANSWERS!")
            print("WARNING: INITAL DIGIT CHECK - '{inital_digit_result}', & MALFORMED LINES CHECK - '{malformed_lines}'!")
            print("WARNING: THE TEXT FILE COULD BE CORRUPTED!")
            print("WARNING: HUMAN OVERSIGHT REQUIRED!")
            exit()

        # Final attempt at formatting the text file.
        
        """
        ### Final formatting attempt logic still to be written based on tests!!

        """

        # Final checks done to new text file.
        print(f"UPDATE: Final format checks being done.")
        # Resets corrected lines variable to 0.
        corrected_lines = 0
        # Final digit check
        print(f"UPDATE: Running final digit check...")
        final_digit_result = self.digit_check(file_path)
        print(f"WARNING: FINAL DIGIT CHECK RETURNED A RESULT OF '{final_digit_result}'!")
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
            print(f"UPDATE: First check completed successfully.")
            print(f"UPDATE: No inconsistencies found.")
            print(f"UPDATE: Proceeding to last check.")

        print("UPDATE: Last check is underway...")
        print(f"WARNING: {corrected_lines} MALFORMED LINES CORRECTED!")
        print(f"WARNING: {malformed_lines} MALFORMED LINES REMAIN!")
        

    def main(self):
        while True:
            file_path = os.path.join(parent_dir, '..', 'MEMORY', new_file_name)
            parent_dir = os.path.dirname(os.path.abspath(__file__))
            
            text_files = self.list_available_files()
            selected_file = self.get_user_selection(text_files)
            self.split_chapters(selected_file)
            
            new_file_name = (f"MEMORY-{os.path.basename(selected_file)}")
            old_file_name = (f"{os.path.basename(selected_file)}")

            #Does all the checks, then returns the result of either True/False
            print("UPDATE: Initiating format checks...")
            check_result = self.check_format(new_file_name)
            if (check_result == True):
                print(f"UPDATE: '{old_file_name)}' has been added to MEMORY.")
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
