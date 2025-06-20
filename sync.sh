#!/bin/bash

# Cursor
echo "Syncing Cursor..."
rm -rf ~/Library/Application\ Support/Cursor/User/keybindings.json
rm -rf ~/Library/Application\ Support/Cursor/User/settings.json
rm -rf ~/Library/Application\ Support/Cursor/User/snippets
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Mackup/Library/Application\ Support/Cursor/User/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Mackup/Library/Application\ Support/Cursor/User/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Mackup/Library/Application\ Support/Cursor/User/snippets ~/Library/Application\ Support/Cursor/User/snippets
echo "Cursor synced"
