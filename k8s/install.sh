#!/bin/sh

echo "Setting up kctx..."

curl -L https://raw.githubusercontent.com/hungthai1401/kctx/main/kctx > /usr/local/bin/kctx
chmod +x /usr/local/bin/kctx

echo "kctx setup complete!"
