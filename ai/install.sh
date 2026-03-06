#!/bin/sh

echo "Setting up AI tools..."

# Install destructive_command_guard - a guard against destructive shell commands
# See: https://github.com/Dicklesworthstone/destructive_command_guard
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/main/install.sh?$(date +%s)" | bash -s -- --easy-mode

echo "AI tools setup complete!"
