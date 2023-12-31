#!/usr/bin/env python3

import os
import sys
import json
from datetime import datetime
import logging

def valid_types():
    return ['status', 'alert', 'error', 'debug', 'user_input']

class CLI:
    valid_message_types = ['status', 'alert', 'error', 'debug', 'user_input']
    
    def __init__(self):
        logging.basicConfig(filename='CLI_LOG.json', level=logging.INFO,
                            format='{"timestamp": "%(asctime)s", "message": "%(message)s", "type": "%(levelname)s"}')
    
    def log_message(self, message, message_type):
        logging.log(level=getattr(logging, message_type.upper(), logging.INFO), msg=message)

    def print_message(self, output_message, message_type):
        self.validate_print_message_input(output_message, message_type)
        
        prefixes = {
            "alert": "Alert has been triggered & program may fail!",
            "user_input": "> {}",
            "default": "> {}"
        }
        
        prefix = prefixes.get(message_type.lower(), prefixes["default"])
        
        formatted_message = prefix.format(f"{message_type.capitalize()}: {output_message}")
        
        self.log_message(formatted_message, message_type)
        
        if message_type.lower() == "user_input":
            return input(formatted_message)
        else:
            print(formatted_message)
            return None

    def handle_exception(self, error_type, function_name):
        self.print_message(f"Function '{function_name}' encountered a {error_type.__name__}.", "debug")
        self.print_message("Manual oversight required!", "alert")
        self.graceful_exit()

    def graceful_exit(self):
        self.print_message("Cleaning up resources...", "status")
        self.print_message("Exiting the program.", "status")
        sys.exit()

    def validate_print_message_input(self, output_message, message_type):
        try:
            if not isinstance(output_message, str):
                raise TypeError("output_message must be a string.")
            if not output_message.strip():
                raise ValueError("output_message cannot be an empty string.")
            if not isinstance(message_type, str):
                raise TypeError("message_type must be a string.")
            if not message_type.strip():
                raise ValueError("message_type cannot be an empty string.")
            if message_type.lower() not in CLI.valid_message_types:
                raise ValueError(f"Invalid message_type provided. Valid types are {', '.join(CLI.valid_message_types)}")
        except (TypeError, ValueError) as e:
            self.print_message(str(e), "error")
            self.graceful_exit()


if __name__ == '__main__':
    cli = CLI()
    cli.print_message(f"DO NOT RUN THIS APPLICATION ON ITS OWN! ('{sys.argv[0]}')", "alert")
