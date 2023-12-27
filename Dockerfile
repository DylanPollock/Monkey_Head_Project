# Base image
FROM debian:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /gencore-app

# Copy requirements and install Python dependencies
COPY requirements.txt ./
#RUN pip3 install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Command to run when container starts
#CMD ["python3", "MonkeyHeadProject.py"]
