#!/bin/sh

echo "Setting up AI tools..."

# Install destructive_command_guard - a guard against destructive shell commands
# See: https://github.com/Dicklesworthstone/destructive_command_guard
if ! command -v dcg > /dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/main/install.sh?$(date +%s)" | bash -s -- --easy-mode
else
  echo "destructive_command_guard already installed."
fi

# Install ultimate_bug_scanner - static analysis catching 1000+ bug patterns across popular languages
# See: https://github.com/Dicklesworthstone/ultimate_bug_scanner
if ! command -v ubs > /dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/main/install.sh?$(date +%s)" | bash -s -- --easy-mode
else
  echo "ultimate_bug_scanner already installed."
fi

# Install beads_rust (br) - local-first Rust CLI issue tracker using SQLite + JSONL, designed for AI agent workflows
# See: https://github.com/Dicklesworthstone/beads_rust
if ! command -v br > /dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_rust/main/install.sh?$(date +%s)" | bash
else
  echo "beads_rust already installed."
fi

# Install beads_viewer (bv) - graph-aware TUI for the Beads issue tracker with PageRank, kanban, and robot-mode JSON API
# See: https://github.com/Dicklesworthstone/beads_viewer
if ! command -v bv > /dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh?$(date +%s)" | bash
else
  echo "beads_viewer already installed."
fi

echo "AI tools setup complete!"
