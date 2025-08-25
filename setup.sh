#!/bin/bash

echo "🐛 Red Weevil Detection System - Setup"
echo "====================================="

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter is not installed. Please install Flutter SDK first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Python 3: $(python3 --version)"
echo "✅ Flutter: $(flutter --version | head -1)"
echo ""

# Create virtual environment
echo "🔧 Setting up Python virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment and install dependencies
echo "📦 Installing Python dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "✅ Python dependencies installed"

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
flutter pub get
echo "✅ Flutter dependencies installed"

# Get current IP and update configuration
CURRENT_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
if [ ! -z "$CURRENT_IP" ]; then
    echo "🌐 Updating IP configuration to: $CURRENT_IP"
    if [ -f "lib/config.dart" ]; then
        sed -i '' "s/static const String serverIp = \".*\";/static const String serverIp = \"$CURRENT_IP\";/" lib/config.dart
        echo "✅ Configuration updated"
    fi
fi

# Test camera access
echo "📹 Testing camera access..."
python test_camera.py
if [ $? -eq 0 ]; then
    echo "✅ Camera test passed"
else
    echo "⚠️  Camera test failed - check camera permissions"
fi

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "🚀 To start the demo:"
echo "   ./start_demo.sh"
echo ""
echo "📖 For detailed instructions:"
echo "   • Quick demo: DEMO_README.md"
echo "   • Full documentation: README.md"
echo ""
echo "🔧 Configuration files:"
echo "   • Server IP: lib/config.dart"
echo "   • Camera settings: videostream.py"
echo "   • Detection logic: main.py"
echo ""
