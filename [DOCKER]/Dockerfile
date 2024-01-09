# (NOTE: This content has been written or altered by an AI agent & is pending approval from a human counterpart.)
# Project Folder: 'C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\'
# Note: This Dockerfile will be located in the project's root folder.

# Use Debian Trixie slim as the base image
FROM debian:trixie-slim

# Update the package repository and install necessary packages
# Python3 and pip are installed for Python-based applications
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /gencore-workdir

# Copy the project's requirements file
COPY requirements.txt ./

# Install Python dependencies from the requirements file
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Define the command to run when the container starts
# Replace 'GenCoreMain.py' with the main executable file of your project
CMD ["python3", "GenCore.py"]

# Expose the necessary port(s)
# Replace '5000' with the port number your application uses, if applicable
EXPOSE 5000