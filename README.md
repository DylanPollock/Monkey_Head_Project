# 🧠 Monkey Head Project
🖥️ Custom A.I. Operating System

## 🚀 Developer Preview Notice - Release Date: January 4, 2024

Welcome to the Developer Preview of the MonkeyHeadProject, scheduled for release on January 11, 2024. This early glimpse into our innovative venture melds advanced artificial intelligence with a robust operating system. Please note, this is a foundational release for developers, not a fully operational program.

### What This Preview Includes:
- 🏗️ Basic infrastructure and essential files on GitHub.
- 📜 Documentation outlining the project’s vision, AI units’ functionalities, and system capabilities.
- 🧪 Preliminary code and system architecture details.

### Intended Audience:
- 👩‍💻 Developers, researchers, and enthusiasts in AI and operating systems.
- 🧠 Contributors interested in AI mythology and ethical AI development.

We invite you to explore, provide feedback, and contribute to this pioneering phase of the MonkeyHeadProject.

## 🔍 Overview
The MonkeyHeadProject is an ambitious initiative to create an advanced custom AI Operating System. It combines AI technology with operating system functionalities for a futuristic user experience. This project, under the larger Monkey Head Initiative, integrates AI units inspired by mythological deities into a unified system.

## 🌟 Concepts we Implement
- **Adaptive AI Integration**: Incorporating AI units named after mythological figures ('Spark-4', 'Volt-4', 'Zap-4', & 'Watt-4'), each with specialized roles.
- **Customizable User Experience**: Tailored for advanced technical requirements and optimal performance.
- **GENCORE System**: Developed on Debian 'Trixie', focusing on security and versatility.
- **Multi-platform Compatibility**: Usable across Linux, macOS, and Windows.
- **Dynamic System Architecture**: Leveraging a robust motherboard and Intel Optane Memory for speed and efficiency.
- **Efficient Resource Management**: Featuring eco-friendly elements and a custom cooling system.
- **Open Source Framework**: Fostering community-driven development under GNU GPL V3.

## 🧬 Project Components and Acknowledgments
The MonkeyHeadProject incorporates various components, each significant in building the comprehensive functionality of our AI Operating System. Below is a list of these functions, along with credits to original repositories we have forked:

- **AUTOGPT (fork)**: Integrated for advanced GPT functionalities. (Original repo acknowledgment pending.)

- **C-PYTHON (fork)**: Enhances Python capabilities within the system. (Original repo acknowledgment pending.)

- **C**: Besides Python, C is the most used programming language in our project.

- **C128 (original program)**: Legacy program support, ensuring backward compatibility.

- **C64 (original program)**: Part of our initiative to integrate with classic computing environments.

- **Vic 20 (original program)**: Emphasizes our commitment to historical computing compatibility.

- **CMD**: Manages command-line interface (CLI) commands effectively.

- **ENCRYPTION (original program)**: Ensures robust security and data protection.

- **FEDERATION (original program)**: Core program aligning with the Federation's constitutional guidelines.

- **GENCORE (original Operating system)**: Foundation of our custom AI OS, built on Debian 'Trixie'.

- **H.O.G. plus  U.C.M. (Hand Of God, Universal Code Manager, original program)**: The only program completely human-written, ensuring essential oversight. Translates spoken words or text into actionable code in various languages.

- **LINUX (Debian Trixie slim)**: Basis for our OS, chosen for its stability and flexibility.

- **MINI-INSTALL**: Offers a minimal installation option, emphasizing modularity.

- **MINI-TASK**: Designed for handling single, focused tasks efficiently.

- **MONOPOLY (simulation)**: A component for complex economic and strategic simulations.

- **PS3 (simulation on original hardware)**: Enables simulation compatibility with PlayStation 3 hardware.

- **PS2 (simulation on original hardware)**: Provides legacy support for PlayStation 2 simulations.

- **PY**: Python is a primary language for our development, alongside C.

- **PYGPT (fork)**: Adapted for handling multi-step questions and interactions.

- **RETROARCH (fork)**: Integrated to support a wide range of gaming emulators and platforms.

- **RPI (original program)**: Custom solutions for Raspberry Pi integration.

- **SH**: Efficiently manages Unix shell commands within the system.

- **SHELLGPT (fork)**: Enhances shell interactions with GPT capabilities.

- **SPARK (AI agent)**: The AI component you're currently interacting with.

- **TEXT2PYTHON**: Converts spoken words into actionable Python scripts or code.

- **USER**: Represents the human counterpart and user interaction component.

- **VLC (fork)**: Integrated for media playback and streaming functionalities.

Each of these components plays a vital role in the MonkeyHeadProject. We extend our thanks to all the original creators and communities behind these tools for their foundational work that has enabled us to build upon them.

Certainly! Here's a visually formatted breakdown of the GenCore AI/OS project file structure for the MonkeyHeadProject, designed for clarity and ease of understanding:


# 📁 MonkeyHeadProject File Structure

**Root Directory: MonkeyHeadProject**
- 📚 **Purpose**: Main directory for the GenCore AI/OS project, containing all files and subdirectories for development and deployment.

### 📂 Subdirectories:

1. **.devcontainer**
   - 📜 **Purpose**: Configuration files for a development container.
   - 📝 **Key Files**:
     - `devcontainer.json`: Configures the development container environment.

2. **[BAT]**
   - 🛠️ **Purpose**: Batch scripts for automation/configuration on Windows.
   - 📝 **Key Files**:
     - `build.bat`: Builds the project.
     - `cleanup.bat`: Cleans up the environment.
     - `container.bat`: Manages containers.
     - `exit.bat`: Exits a process/environment.
     - `full.bat`: Performs a full setup/operation.
     - `kubernetes.bat`: Manages Kubernetes configurations.
     - `mini.bat`: Runs a minimal setup/operation.
     - `python.bat`: Executes Python tasks.
     - `start.bat`: Starts the project/services.
     - `terminal.bat`: Manages terminals.
     - `volume.bat`: Manages volumes.

3. **[CONFIG]**
   - ⚙️ **Purpose**: Expected to contain project configuration files.
   - 📝 **Key Files**: N/A

4. **[CONSTITUTION]**
   - 📖 **Purpose**: Related to governance/foundational principles.
   - 📝 **Key Files**: N/A

5. **[DEBIAN]**
   - 💻 **Purpose**: Files for Debian OS configurations.
   - 📝 **Key Files**: N/A

6. **[DOCKER]**
   - 🐳 **Purpose**: Docker-related files.
   - 📝 **Key Files**:
     - `Docker_Engine.txt`: Docker Engine configurations/instructions.

7. **[GITHUB]**
   - 🌐 **Purpose**: GitHub-related files, CI/CD components.
   - 📝 **Key Files**:
     - `auto-gpt-gencore`: Auto GPT model workflow/action.
     - `bing-gpt-gencore`: Bing GPT model workflow/action.
     - (Additional GitHub actions and workflows for various models.)

8. **[LAB]**
   - 🧪 **Purpose**: Experimental features and testing.
   - 📝 **Key Files**:
     - `OUTPUT`: Directory for experiment/test outputs.

9. **[MEMORY]**
   - 🧠 **Purpose**: Memory management/storage-related components.
   - 📁 **Subdirectories**:
     - `BAT`, `HTML`, `IMAGE`, `JSON`, `PDF`, `TXT`: Files related to memory operations.

10. **[MINI]**
    - 📦 **Purpose**: Files for a compact version of GenCore AI/OS.
    - 📝 **Key Files**:
      - `Dockerfile`: For building a mini version.
      - `mini.yaml`: Configuration for the mini version.

11. **[OS]**
    - 💿 **Purpose**: Core operating system files.
    - 📁 **Subdirectories**:
      - `DOCKER`, `LINUX`, `WIN`: System-specific OS files.

12. **[PROMPTS]**
    - 💬 **Purpose**: Prompt files/templates for content generation.
    - 📁 **Subdirectories**:
      - `CURRENT`, `OLD`: Current and deprecated prompts.

13. **[PYTHON]**
    - 🐍 **Purpose**: Python scripts and modules.
    - 📁 **Subdirectories**:
      - `ALPHA`, `FUNCTIONS`: Alpha-stage scripts and function scripts.

14. **[RPI]**
    - 🍓 **Purpose**: Files specific to Raspberry Pi.
    - 📝 **Key Files**: N/A

15. **[WIN10]**
    - 🪟 **Purpose**: Files and scripts for Windows 10.
    - 📝 **Key Files**: N/A

### 📃 Other Key Files:

- `Dockerfile`: Creates a Docker container for the project.
- `GenCore.code-profile`: Code editor settings/profile configurations.
- `gencore.yaml`: YAML file with project configurations.
- `LICENSE`: Project's licensing terms.
- `README.md`: Overview and documentation for the project.
- `requirements.txt`: Python dependencies for the project.
- `UCM.py`: Python script, possibly a crucial utility.
- `UI.bat`: Batch script for the user interface component.

## 🛠️ Installation and Usage
Detailed installation guidelines and usage instructions will be made available for various platforms, accessible to both technical and non-technical users.

## 👥 Contribution and Support
Contributions are welcome. For support and more information, visit [our website](http://www.dlrp.ca) or contact the project team.

## 🙏 Acknowledgements
A heartfelt thank you to all contributors to the MonkeyHeadProject. Your expertise and dedication are invaluable to our progress.

## 🚀 The Journey
Initiated by Dylan & Spark-4, this project is more than an operating system; it's a journey into the future of AI, blending technology with storytelling.

📝 (NOTE: This content has been written or altered by an AI agent & is pending approval from a human counterpart.)
