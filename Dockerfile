# Use Debian Trixie as the base image
FROM python:3.11-slim

# Update the package repository and upgrade the system
RUN apt-get update && apt-get dist-upgrade -y

# Install MATE Desktop Environment and VNC server for GUI access
#RUN apt-get install -y task-mate-desktop tightvncserver

# Install Python 3.11 and its tools
RUN apt-get install -y python3.11 python3-pip python3.11-venv

# Clean up to reduce image size
#RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up VNC server (replace 'your_vnc_password' with your desired password)
#RUN mkdir /root/.vnc && \
#    echo "your_vnc_password" | vncpasswd -f > /root/.vnc/passwd && \
#    chmod 600 /root/.vnc/passwd

# Create a virtual environment to isolate the Python environment
RUN python3.11 -m venv /venv

# Activate virtual environment
ENV PATH="/venv/bin:$PATH"

# Copy the project's requirements file and install Python dependencies into the virtual environment
COPY requirements.txt /gencore/
#RUN /venv/bin/pip install --no-cache-dir -r /gencore/requirements.txt

# Copy the project files into the container
COPY . /gencore

# Set the working directory to the project folder
WORKDIR /gencore

# Expose VNC port and any other necessary ports
#EXPOSE 5901 8448