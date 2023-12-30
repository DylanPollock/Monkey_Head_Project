# Project Folder: 'C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\'
# Note: This file will be located in root folder (or 'Project Folder').

# Use Debian Trixie as the base image
FROM debian:trixie

# Update the package repository and install necessary packages
# Python3 and pip are installed for Python-based applications
#RUN apt-get update && apt-get install -y \
#    python3 \
#    python3-pip \
#    && rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /gencore-workdir

# Copy the project's requirements file
COPY requirements.txt ./

# Install Python dependencies from the requirements file
#RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Define the command to run when the container starts
# Replace 'MonkeyHeadProject.py'with the main executable file that needs to be run
#CMD ["python3", "MonkeyHeadProject.py"]