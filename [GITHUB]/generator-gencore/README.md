# Crash Bandicoot Generator

Welcome to the "Crash Bandicoot Generator" repository. This project is designed to generate game passwords for the classic PS1 game "Crash Bandicoot," enhancing the gaming experience with a modern twist.

## Overview

The Crash Bandicoot Generator creates passwords based on the level progression, keys, and gems obtained in the game. It uses a unique algorithm to encode these elements into a password that can be used within the game.

## Features

- **Level Selection:** Choose any level from "Crash Bandicoot" to generate a password for.
- **Key and Gem Tracking:** Option to select keys and gems acquired throughout the game.
- **Super Password Option:** A toggle to force the generation of super passwords, catering to advanced game states.
- **Interactive Web Interface:** An easy-to-use HTML interface for generating and displaying passwords.

## How It Works

The generator uses a combination of JavaScript and HTML to create an interactive web page where users can select game levels, keys, and gems. Based on these selections, it calculates a unique password that corresponds to the chosen game state.

### Password Encoding

The password encoding algorithm takes into account:
- Levels completed
- Keys obtained
- Gems collected

This data is then processed using a modular arithmetic-based algorithm to generate a valid in-game password.

### Web Interface

The web interface allows for easy selection of game levels, keys, and gems. It dynamically updates to show the generated password in a visually appealing format, using symbols to represent different in-game elements.

## Usage Instructions

1. **Select Level:** Choose the level you have reached in the game.
2. **Select Keys and Gems:** Check the keys and gems you have collected.
3. **Generate Password:** The password will automatically generate and display.
4. **Use in Game:** Enter this password in the "Crash Bandicoot" game to load the corresponding game state.

### Additional Features

- **Force Super Password:** Option to always generate super passwords, useful for advanced game progressions.
- **Gem Selection Shortcuts:** Buttons to quickly select all or no gems.

## Contributions

This project is open for contributions. Feel free to fork the repository and submit pull requests with improvements or bug fixes.

## Acknowledgements

- Original algorithm inspiration: [dezgeg/crash-bandicoot-password-cracking](https://github.com/dezgeg/crash-bandicoot-password-cracking).
- Game assets and data based on "Crash Bandicoot" by Naughty Dog.

## Disclaimer

This project is created for educational and entertainment purposes and is not affiliated with the official "Crash Bandicoot" game or Naughty Dog.
