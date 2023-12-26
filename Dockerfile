# Use Debian Trixie as the base image
FROM debian:trixie

# Set environment variables
ENV GITHUB_URL=https://github.com/DLRP1995/MonkeyHeadProject.git
ENV GITHUB_FOLDER=C:\Users\admin\OneDrive\Desktop\GenCore
SET DOCKER_CONTAINER=gencore-container
SET DOCKER_IMAGE=gencore-app
SET DOCKER_VOLUME=gencore-volume

# Update package repository & upgrade the system, then installs system dependencies
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y python3 python3-pip python3-venv

# Set up a virtual environment to isolate the Python environment
RUN python3 -m venv /venv

# Activate virtual environment
ENV PATH="/venv/bin:$PATH"

# Copy the project files into the container
COPY . /GenCore

# Set the working directory
WORKDIR /GenCore