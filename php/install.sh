#!/bin/sh

echo "Setting up PHP tools..."

# Install helper script for switching between Brew-installed PHP versions
# See: https://github.com/rhukster/sphp.sh
curl -L https://raw.githubusercontent.com/rhukster/sphp.sh/main/sphp.sh > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

echo "PHP tools setup complete!"
