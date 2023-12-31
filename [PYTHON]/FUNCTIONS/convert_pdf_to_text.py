import PyPDF2

# Open the PDF file
def convert_pdf_to_text(path):
    try:
        with open(path, 'rb') as file:
            reader = PyPDF2.PdfFileReader(file)
            text = ''
            for page_num in range(reader.numPages):
                text += reader.getPage(page_num).extractText()
            return text
    except Exception as e:
        return str(e)

# Path to the PDF file
pdf_path = '/pdf-input/Alices Adventures In Wonderland.pdf'
# Convert the PDF to text
text = convert_pdf_to_text(pdf_path)

# Save the text to a file
def save_text_to_file(text, file_path):
    try:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(text)
            return 'OK'
    except Exception as e:
        return str(e)

# Path to the output text file
output_path = '/pdf-output/Alices_Adventures_In_Wonderland.txt'
# Save the converted text
result = save_text_to_file(text, output_path)
print(result)