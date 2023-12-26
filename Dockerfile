# Use Debian Trixie as the base image
FROM debian:trixie

# Set environment variables
ENV API_KEY=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
ENV ORG_ID=org-QvCu4lkMIaiGUUO7vf7VRbHR

# Update the package repository and upgrade the system, install system dependencies
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y python3 python3-pip python3-venv \
    python3-dev portaudio19-dev libasound2-dev libportaudio2 libportaudiocpp0 ffmpeg \
    build-essential git curl wget

# Set up a virtual environment to isolate the Python environment
RUN python3 -m venv /venv

# Activate virtual environment
ENV PATH="/venv/bin:$PATH"

# Copy the project files into the container
COPY . /GenCore

# Install Python dependencies
# Commented out because the PyAudio requirement causes failure.
# However, including a range of libraries for various functionalities
# RUN pip install --no-cache-dir -r /GenCore/requirements.txt \
#     numpy pandas scikit-learn matplotlib requests Flask Django \
#     tensorflow keras PyTorch OpenCV scapy beautifulsoup4

# Set the working directory
WORKDIR /GenCore

# Optional: Create a non-root user for running the application
# RUN groupadd -r genuser && useradd -r -g genuser -d /home/genuser -s /bin/bash -m genuser
# USER genuser

# Command to run your application (update as needed)
# CMD ["python3", "./your_script.py"]