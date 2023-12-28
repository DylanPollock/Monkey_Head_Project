# Crash Bandicoot GenCore #

This repository, 'crash-bandicoot-gencore', is a specialized fork of the classic PS1 game "Crash Bandicoot," ported to C for use in simulated AI/OS environments, such as GenCore.

## Project Status ##

- Code Porting: 100% complete.
- Functionality: Approximately 78% operational.

Currently, the game is in a partially playable state with several identified [issues](doc/issues.md). Note that the PSX-specific code is not yet functional.

## Compilation Guide ##

The game has been tested on Ubuntu/Debian systems but should build on any platform with a proper 32-bit GNU toolchain and the necessary dependencies.

### System Requirements ###

#### For PC Builds ####
- gcc, binutils, glibc
- GNU make
- OpenGL 2.0+
- SDL 2
- FluidSynth
- Dear ImGui / cimgui (included in the project)
- g++ / libstdc++ (for compiling ImGui)

On Ubuntu/Debian:
- 64-bit systems: `sudo apt install build-essential gcc-multilib g++-multilib libstdc++6:i386 libgl1-mesa-dev:i386 libsdl2-dev:i386 libfluidsynth-dev:i386`
- 32-bit systems: `sudo apt install build-essential libstdc++6 libgl1-mesa-dev libsdl2-dev libfluidsynth-dev`

#### For PSX Builds ####
- Psy-Q SDK (Note: PSX build is currently not operational)

## How to Compile ##

To compile 'crash-bandicoot-gencore', first install the required dependencies. Then navigate to the main project directory and execute `make`.

## Running the Game ##

To run 'c1', use the following command from the project directory: `./c1`.

You'll need the original game's asset files (.NSD/.NSF) from the `/S0`, `/S1`, `/S2`, and `/S3` directories of the Crash Bandicoot game disc. These files should be copied into the `/streams` directory of this project and renamed from `S00000%%.NS[F,D]` to `s00000%%.ns[f,d]`.

The game defaults to booting into level `25` (title sequence/main menu). To change the boot level, modify `LID_BOOTLEVEL` in `common.h` and recompile.

## Game Controls ##

The controls are mapped to keyboard keys as follows:
- X - <kbd>Z</kbd>
- Square - <kbd>X</kbd>
- Circle - <kbd>C</kbd>
- Triangle - <kbd>V</kbd>
- L1 - <kbd>A</kbd>
- R1 - <kbd>S</kbd>
- L2 - <kbd>Q</kbd>
- R2 - <kbd>W</kbd>
- D-pad directions - Arrow keys
- Start - <kbd>Enter</kbd>
- Select - <kbd>Space</kbd>
- Toggle in-game GUI - <kbd>Esc</kbd>
- Toggle in-game GUI keyboard focus - <kbd>Tab</kbd>

## Project Structure ##

The project's structure includes directories for source code, documentation, game assets, and more. Each subdirectory contains specific components essential for the game's operation. Further details can be found in the `doc` folder.

## Additional Notes ##

This port is intended for research and development within AI/OS simulated environments, such as GenCore. It demonstrates the capability of such systems to handle complex tasks like game emulation and provides a platform for further experimentation in the intersection of gaming and AI technology.
