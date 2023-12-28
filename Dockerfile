# Use Debian Trixie for compatibility with your project specifications
FROM debian:trixie

# Update the package repository and install necessary packages
# Python3-pip is used for installing Python packages
# It's good practice to remove the apt cache after installation to reduce image size
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /gencore
WORKDIR /gencore-workdir

# Copy the Python requirements file into the container
COPY requirements.txt ./

# Install Python dependencies from requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of your project files into the container
COPY . .

# Specify the command to run your application
# Replace 'MonkeyHeadProject.py' with the entry point of your application
CMD ["python3", "MonkeyHeadProject.py"]