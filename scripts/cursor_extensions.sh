#!/bin/zsh

# Path to save the extensions list in iCloud
ICLOUD_PATH="$HOME/Library/Mobile Documents/com~apple~CloudDocs/cursor-extensions.txt"

function backup_extensions() {
  cursor --list-extensions > "$ICLOUD_PATH"
  echo "Cursor extensions list saved to $ICLOUD_PATH"
}

function restore_extensions() {
  if [[ ! -f "$ICLOUD_PATH" ]]; then
    echo "No backup file found at $ICLOUD_PATH"
    exit 1
  fi
  while read -r extension; do
    if [[ -n "$extension" ]]; then
      cursor --install-extension "$extension"
    fi
  done < "$ICLOUD_PATH"
  echo "Cursor extensions restored from $ICLOUD_PATH"
}

case "$1" in
  backup)
    backup_extensions
    ;;
  restore)
    restore_extensions
    ;;
  *)
    echo "Usage: $0 {backup|restore}"
    exit 1
    ;;
esac 
