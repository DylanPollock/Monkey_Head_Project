# Use Debian Trixie as the base image
FROM debian:trixie

# Update the package repository and upgrade the system
RUN apt-get update && apt-get dist-upgrade -y

# Install Python 3 and pip
RUN apt-get install -y python3 python3-pip

# Set up a virtual environment to isolate the Python environment
RUN python3 -m venv /opt/venv

# Activate virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Set environment variables
ENV API_KEY=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
ENV ORG_ID=org-QvCu4lkMIaiGUUO7vf7VRbHR

# Copy the requirements file into the container
COPY requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY . /GenCore

# Set the working directory
WORKDIR /GenCore

# Create a user and switch to it for security
RUN groupadd -r myuser && useradd -r -g myuser myuser
USER myuser

# Command to run your application
# CMD ["python3", "./your_script.py"] # Update with your script