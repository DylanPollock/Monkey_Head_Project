# Use Debian as the base image
FROM debian:bookworm

# Update the package repository and upgrade the system. Then install Python 3.11 and its tools.
# Python3-venv is used for creating an isolated Python environment.
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y python3.11 python3-pip python3.11-venv

# Create a virtual environment to isolate the Python environment
RUN python3.11 -m venv /venv

# Activate virtual environment. All Python commands will now use this environment.
ENV PATH="/venv/bin:$PATH"

# Install required Python packages from requirements.txt
# Note: Ensure requirements.txt is present in the context directory
COPY requirements.txt /MonkeyHeadProject/
RUN pip install -r /MonkeyHeadProject/requirements.txt

# Copy the project files into the container. Adjust the source path if necessary.
COPY . /MonkeyHeadProject

# Set the working directory to the project folder
WORKDIR /MonkeyHeadProject