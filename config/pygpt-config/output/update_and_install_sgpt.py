import subprocess

# Define the path to the Python executable within the virtual environment
python_executable = '/venv/bin/python'

# Define the commands to be run within the virtual environment
commands = [
    f'{python_executable} -m pip install --upgrade pip',
    f'{python_executable} -m pip list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 {python_executable} -m pip install -U',
    f'{python_executable} -m pip install shell-gpt',
    'echo "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" | sgpt help_me_please',
    'sgpt --help'
]

# Execute the commands and collect the outputs
outputs = []
for cmd in commands:
    process = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    outputs.append(process.stdout)

# Combine all outputs
combined_output = '\n'.join(outputs)

# Save the output to a file
with open('sgpt_output.txt', 'w') as file:
    file.write(combined_output)