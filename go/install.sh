#!/bin/sh

echo "Setting up Go development environment..."

# Install Delve - a debugger for the Go programming language
# See: https://github.com/go-delve/delve
go install github.com/go-delve/delve/cmd/dlv@latest

echo "Go development environment setup complete!"
