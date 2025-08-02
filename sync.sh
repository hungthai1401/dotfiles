#!/bin/bash

# Detect Mac architecture and set appropriate iCloud path
if [[ $(uname -m) == "arm64" ]]; then
    # M1/M2 Mac
    ICLOUD_PATH="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
else
    # Intel Mac
    ICLOUD_PATH="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
    # Fallback for older Intel Macs that might not have the Mobile Documents path
    if [[ ! -d "$ICLOUD_PATH" ]]; then
        ICLOUD_PATH="$HOME/iCloud Drive"
    fi
fi

# Check if iCloud path exists
if [[ ! -d "$ICLOUD_PATH" ]]; then
    echo "Error: iCloud path not found at $ICLOUD_PATH"
    echo "Please ensure iCloud Drive is enabled and synced"
    exit 1
fi

# Cursor
echo "Syncing Cursor..."
rm -rf ~/Library/Application\ Support/Cursor/User/keybindings.json
rm -rf ~/Library/Application\ Support/Cursor/User/settings.json
rm -rf ~/Library/Application\ Support/Cursor/User/snippets
ln -s "$ICLOUD_PATH/Mackup/Library/Application Support/Cursor/User/keybindings.json" ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -s "$ICLOUD_PATH/Mackup/Library/Application Support/Cursor/User/settings.json" ~/Library/Application\ Support/Cursor/User/settings.json
ln -s "$ICLOUD_PATH/Mackup/Library/Application Support/Cursor/User/snippets" ~/Library/Application\ Support/Cursor/User/snippets
echo "Cursor synced"
