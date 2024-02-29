# Use Debian Trixie slim as the base image
FROM debian:trixie-slim

# Metadata indicating an AI agent has been involved in the creation of this Dockerfile
LABEL maintainer="admin@monkeyheadproject.com"
LABEL description="Dockerfile for GenCore application within the Monkey Head Project."

# Update the package repository and install necessary packages
# Python3 and pip are installed for Python-based applications
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /gencore-workdir

# Copy the project's requirements file first to leverage Docker cache
COPY requirements.txt ./

# Install Python dependencies from the requirements file
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the project's files into the container
COPY . .

# Define the command to run the application when the container starts
# Updated to use 'GenCore.py' as specified
CMD ["python3", "GenCore.py"]

# Expose port 95 as per the updated configuration
EXPOSE 95
