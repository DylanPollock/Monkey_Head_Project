import os
import sys
from nltk.tokenize import sent_tokenize

def prompt_for_file_path(message):
    """Prompt the user for a file path and validate its existence."""
    file_path = input(f"{message}: ").strip()
    if not os.path.isfile(file_path):
        print("File not found. Please enter a valid file path.")
        sys.exit(1)
    return file_path

def prompt_for_output_path(message):
    """Prompt the user for an output path."""
    return input(f"{message}: ").strip()

def detect_chapter_format(file_path):
    """Detect the format of chapters in a text file."""
    with open(file_path, 'r', encoding='utf-8') as file:
        first_lines = [next(file) for _ in range(20)]
    for line in first_lines:
        if "Chapter" in line:
            return "standard"
    return "non-standard"

def process_file(file_path, output_path):
    """Process the text file into chapters."""
    chapter_format = detect_chapter_format(file_path)
    if chapter_format == "non-standard":
        print("Non-standard chapter format detected. The output might not be correctly formatted.")

    with open(file_path, 'r', encoding='utf-8') as file:
        text = file.read()
    
    chapters = text.split('Chapter')[1:]  # Splitting by 'Chapter' keyword
    for i, chapter in enumerate(chapters, 1):
        chapter = f"Chapter {i}\n{chapter.strip()}"
        with open(os.path.join(output_path, f"Chapter_{i}.txt"), 'w', encoding='utf-8') as out_file:
            out_file.write(chapter)

def main():
    """Main function to run the script."""
    book_file_path = prompt_for_file_path("Enter the path to the book file")
    output_directory = prompt_for_output_path("Enter the output directory path")

    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    process_file(book_file_path, output_directory)
    print("Processing completed.")

if __name__ == "__main__":
    main()

