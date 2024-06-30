# Use Debian Trixie slim as the base image for a lightweight container
FROM debian:trixie-slim

# Define maintainer or author of the Dockerfile
LABEL maintainer="admin@dlrp.ca"

# Set environment variables to minimize issues and configure Python not to create .pyc files
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Update the package repository and install necessary packages
# Using 'apt-get install -y --no-install-recommends' to keep the installation small
# Adding '&& apt-get clean' to remove unnecessary files and free space
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    mate-desktop-environment-core \
    tightvncserver \
    && pip3 install nltk torch torchvision torchaudio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Installation completed successfully."

# Set up the working directory inside the container
WORKDIR /gencore-workdir

# Copy the project's requirements file first to leverage Docker cache
COPY requirements.txt ./

# Install Python dependencies from the requirements file
RUN pip3 install --no-cache-dir -r requirements.txt \
    && echo "Python dependencies installed successfully."

# Copy the rest of the project files into the container
COPY . .

# Non-root User:
RUN useradd -m dlrp && chown -R dlrp:dlrp /gencore-workdir
USER dlrp

# Set up VNC server
RUN mkdir /home/dlrp/.vnc \
    && echo "dlrp" | vncpasswd -f > /home/dlrp/.vnc/passwd \
    && chmod 600 /home/dlrp/.vnc/passwd \
    && echo "#!/bin/bash\nxrdb $HOME/.Xresources\nstartmate &" > /home/dlrp/.vnc/xstartup \
    && chmod +x /home/dlrp/.vnc/xstartup \
    && echo "VNC server setup completed successfully."

# Expose the necessary port(s)
EXPOSE 4488

# Health check to ensure the VNC server is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep vncserver || exit 1

# Define the command to run when the container starts
CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-localhost", "no", ":1"]

# (NOTE: This content has been written or altered by an AI agent & is pending approval from a human counterpart.)