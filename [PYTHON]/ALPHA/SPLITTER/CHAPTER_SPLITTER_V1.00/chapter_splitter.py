# Import necessary libraries
import os
import glob
import re
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

    def get_text_file_path(self):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        input_folder = os.path.join(parent_dir, '..', 'BOOKS')
        memory_folder = os.path.join(parent_dir, '..', 'MEMORY')
        
        # Cross-reference with MEMORY folder to list only new or different text files
        memory_files = set(os.path.basename(f).replace("MEMORY-", "") for f in glob.glob(os.path.join(memory_folder, 'MEMORY-*.txt')))
        text_files = [f for f in glob.glob(os.path.join(input_folder, '*.txt')) if os.path.basename(f) not in memory_files]
        
        if not text_files:
            print("No new or different text files found.")
            return None
        print("Available text files:")
        for idx, file in enumerate(text_files):
            print(f"{idx + 1}. {os.path.basename(file)}")
        while True:
            try:
                selection = int(input("Please enter the number corresponding to the text file you'd like to read: "))
                if 1 <= selection <= len(text_files):
                    return text_files[selection - 1]
                else:
                    print("Invalid selection. Please try again.")
            except ValueError:
                print("Please enter a valid number.")

    def final_format_check(self, output_file_path):
        with open(output_file_path, 'r') as f:
            lines = f.readlines()

        # Remove any empty lines
        lines = [line.strip() for line in lines if line.strip()]
        
        # Initialize an empty list to store the fixed lines
        fixed_lines = []
        
        # Initialize a buffer to store incomplete lines
        buffer_line = ''
        
        # Iterate through each line to check its format
        for line in lines:
            if re.match(r'^\d+ \|', line):
                if buffer_line:
                    fixed_lines.append(buffer_line)
                buffer_line = line.strip()
            else:
                buffer_line += ' ' + line.strip()
                
        # Append any remaining buffer content
        if buffer_line:
            fixed_lines.append(buffer_line)
        
        # Write the fixed lines back to the file
        with open(output_file_path, 'w') as f:
            f.write('\n'.join(fixed_lines))

    def split_chapters(self, file_path):
        parent_dir = os.path.dirname(os.path.abspath(__file__))
        output_folder = os.path.join(parent_dir, '..', 'MEMORY')
        output_file_name = f"MEMORY-{os.path.basename(file_path)}"
        output_file_path = os.path.join(output_folder, output_file_name)
        
        author_name = input("Please enter the author's name: ")

        book_title_match = re.search(r"MEMORY-(.*?)- ", output_file_name)
        book_title = book_title_match.group(1) if book_title_match else "Unknown"
        
        chapter_match = re.search(r"- (.+).txt", output_file_name)
        chapter_detail = chapter_match.group(1) if chapter_match else "Unknown"

        if not book_title_match and not chapter_match:
            # Treat the document as an individual paper
            book_title = os.path.basename(file_path).replace(".txt", "")
            chapter_detail = "Individual Paper"

        with open(file_path, 'r') as f:
            text = f.read()
        chapters = sent_tokenize(text)

        formatted_sentences = []
        formatted_sentences.append(f"0 | {book_title} - By: {author_name} - {chapter_detail}")
        
        for idx, chapter in enumerate(chapters):
            sentence_number = idx + 1
            formatted_sentences.append(f"{sentence_number} | {chapter}")

        # Write the initial formatted sentences to the file
        with open(output_file_path, 'w') as f:
            f.write('\n'.join(formatted_sentences))

        # Perform a final format check to correct any issues
        self.final_format_check(output_file_path)
        
        print(f"Finished! {os.path.basename(file_path)} was successfully reformatted.")

if __name__ == "__main__":
    splitter = ChapterSplitter()
    while True:
        text_file_path = splitter.get_text_file_path()
        if text_file_path:
            splitter.split_chapters(text_file_path)
        else:
            print("No new or different text files available for reformatting.")
        
        another_file = input("Do you want to reformat another text file? (y/n): ")
        if another_file.lower() != 'y':
            break
