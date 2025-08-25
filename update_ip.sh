#!/bin/bash

# Get current Mac IP address
CURRENT_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

if [ -z "$CURRENT_IP" ]; then
    echo "❌ Could not detect IP address"
    exit 1
fi

echo "🔍 Detected IP: $CURRENT_IP"

# Update the config file
sed -i '' "s/static const String serverIp = \".*\";/static const String serverIp = \"$CURRENT_IP\";/" lib/config.dart

echo "✅ Updated config.dart with IP: $CURRENT_IP"
echo "🔄 Run 'flutter hot reload' or press 'r' in your Flutter terminal"
