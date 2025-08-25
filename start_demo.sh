#!/bin/bash

echo "🐛 Red Weevil Detection System - Demo Launcher"
echo "=============================================="

# Check if we're in the right directory
if [ ! -f "main.py" ]; then
    echo "❌ Error: main.py not found. Please run this script from the reddd directory."
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Error: Virtual environment not found. Please run setup first:"
    echo "   python3 -m venv venv"
    echo "   source venv/bin/activate"
    echo "   pip install -r requirements.txt"
    exit 1
fi

# Get current IP address
CURRENT_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

if [ -z "$CURRENT_IP" ]; then
    echo "⚠️  Warning: Could not detect IP address. Using localhost."
    CURRENT_IP="127.0.0.1"
else
    echo "🌐 Detected IP address: $CURRENT_IP"
fi

# Update IP in config if needed
if [ -f "lib/config.dart" ]; then
    echo "🔧 Updating IP configuration..."
    sed -i '' "s/static const String serverIp = \".*\";/static const String serverIp = \"$CURRENT_IP\";/" lib/config.dart
    echo "✅ Configuration updated"
fi

# Kill any existing processes on port 5000
echo "🧹 Cleaning up existing processes..."
lsof -ti:5000 | xargs kill -9 2>/dev/null || true
sleep 1

# Activate virtual environment and start Flask server
echo "📡 Starting Flask server..."
source venv/bin/activate

# Check if required packages are installed
python -c "import flask, cv2, numpy" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Error: Required packages not installed. Installing now..."
    pip install -r requirements.txt
fi

# Start the server in background
python main.py > flask_server.log 2>&1 &
FLASK_PID=$!

# Wait a moment for server to start
sleep 3

# Check if server started successfully
if kill -0 $FLASK_PID 2>/dev/null; then
    echo "✅ Flask server started successfully (PID: $FLASK_PID)"
    echo ""
    echo "🌐 Server URLs:"
    echo "   • Main: http://$CURRENT_IP:5000"
    echo "   • Video Feed: http://$CURRENT_IP:5000/frame"
    echo "   • API Status: http://$CURRENT_IP:5000/status"
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Open a NEW terminal window"
    echo "2. Navigate to this directory: cd $(pwd)"
    echo "3. Run Flutter: flutter run -d chrome --web-browser-flag \"--disable-web-security\""
    echo "4. Login with: admin / password"
    echo "5. Navigate: Home → Device Details → Live Camera Feed"
    echo ""
    echo "📋 Demo Features:"
    echo "   • Live camera feed at 20 FPS"
    echo "   • Random weevil detection (20% chance)"
    echo "   • Real-time detection counter"
    echo "   • Responsive web interface"
    echo ""
    echo "🛑 To stop the server: Press Ctrl+C"
    echo "📖 For help: Check DEMO_README.md"
    echo ""
else
    echo "❌ Error: Flask server failed to start. Check flask_server.log for details:"
    tail -10 flask_server.log
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping Flask server..."
    kill $FLASK_PID 2>/dev/null
    echo "✅ Server stopped. Goodbye!"
    exit 0
}

# Set up signal handlers
trap cleanup INT TERM

# Keep script running and show live logs
echo "📊 Live Server Logs (Ctrl+C to stop):"
echo "======================================"
tail -f flask_server.log &
TAIL_PID=$!

# Wait for the Flask process
wait $FLASK_PID

# Cleanup tail process
kill $TAIL_PID 2>/dev/null
cleanup
