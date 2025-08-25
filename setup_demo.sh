#!/bin/bash

echo "🔧 Setting up Red Weevil Detection Demo..."

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
flutter pub get

# Get local IP address
echo "🌐 Getting your local IP address..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux (Raspberry Pi)
    LOCAL_IP=$(hostname -I | awk '{print $1}')
else
    LOCAL_IP="localhost"
fi

echo "📍 Your local IP address is: $LOCAL_IP"
echo "⚠️  Update the 'piIp' variable in lib/camera_page.dart to: $LOCAL_IP"

echo ""
echo "🚀 Setup complete! To run the demo:"
echo "1. Update IP address in lib/camera_page.dart"
echo "2. Run: python3 main.py"
echo "3. In another terminal, run: flutter run"
echo ""
echo "📱 The Flask server will be available at: http://$LOCAL_IP:5000"
