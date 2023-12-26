# Use Debian Trixie as the base image
FROM debian:trixie

# Update the package repository and upgrade the system. Then install Python and its tools.
# Python3-venv is used for creating an isolated Python environment.
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y python3 python3-pip python3-venv

# Create a virtual environment to isolate the Python environment
RUN python3 -m venv /venv

# Activate virtual environment. All Python commands will now use this environment.
ENV PATH="/venv/bin:$PATH"

# Copy the project files into the container. Adjust the source path if necessary.
COPY . /GenCore

# Set the working directory to the project folder
WORKDIR /GenCore