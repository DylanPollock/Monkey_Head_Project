# Use Debian Trixie as the base image
FROM debian:trixie

# Update the package repository and upgrade the system
RUN apt-get update && apt-get dist-upgrade -y

# Install system dependencies for PyAudio and other dependencies
RUN apt-get install -y python3 python3-pip python3-venv 

# Set up a virtual environment to isolate the Python environment
RUN python3 -m venv /venv

# Activate virtual environment
ENV PATH="/venv/bin:$PATH"

# Set environment variables
ENV API_KEY=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
ENV ORG_ID=org-QvCu4lkMIaiGUUO7vf7VRbHR

#Install requirements file & PyAudio
#RUN apt-get install -y python3-dev portaudio19-dev libasound2-dev libportaudio2 libportaudiocpp0 ffmpeg
#COPY ["PyAudio-0.2.14.tar.gz", "/tmp/PyAudio-0.2.14.tar.gz"]
#RUN pip install /tmp/PyAudio-0.2.14.tar.gz
#COPY requirements.txt ./
#Install remaining Python dependencies, excluding PyAudio which is already installed
#RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY . /GenCore

# Set the working directory
WORKDIR /GenCore

# Command to run your application
# CMD ["python3", "./your_script.py"] # Update with your script