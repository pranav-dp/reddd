#!/usr/bin/env python3
import subprocess
import requests
import cv2
import sys
import socket
import time

def check_system_requirements():
    print("🔍 Checking system requirements...")
    
    # Check Python version
    python_version = sys.version
    print(f"   Python version: {python_version}")
    
    # Check OpenCV
    try:
        cv_version = cv2.__version__
        print(f"   ✅ OpenCV version: {cv_version}")
    except Exception as e:
        print(f"   ❌ OpenCV error: {e}")
    
    # Check Flask
    try:
        import flask
        print(f"   ✅ Flask version: {flask.__version__}")
    except Exception as e:
        print(f"   ❌ Flask error: {e}")

def check_network():
    print("\n🌐 Checking network configuration...")
    
    # Get local IP
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        print(f"   Local IP: {local_ip}")
    except Exception as e:
        print(f"   ❌ Network error: {e}")
    
    # Check if port 5000 is available
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = s.connect_ex(('localhost', 5000))
        if result == 0:
            print("   ✅ Port 5000 is in use (Flask server running)")
        else:
            print("   ❌ Port 5000 is not in use (Flask server not running)")
        s.close()
    except Exception as e:
        print(f"   ❌ Port check error: {e}")

def check_camera():
    print("\n📷 Checking camera access...")
    
    for i in range(3):
        try:
            cap = cv2.VideoCapture(i)
            if cap.isOpened():
                ret, frame = cap.read()
                if ret and frame is not None:
                    print(f"   ✅ Camera {i}: Working - {frame.shape}")
                    cap.release()
                    return True
                else:
                    print(f"   ❌ Camera {i}: No frame")
            else:
                print(f"   ❌ Camera {i}: Cannot open")
            cap.release()
        except Exception as e:
            print(f"   ❌ Camera {i} error: {e}")
    
    return False

def check_flask_server():
    print("\n🌐 Checking Flask server...")
    
    base_url = "http://10.250.124.96:5000"
    
    endpoints = [
        "/status",
        "/detection",
        "/video_feed"
    ]
    
    for endpoint in endpoints:
        try:
            if endpoint == "/video_feed":
                response = requests.get(f"{base_url}{endpoint}", timeout=3, stream=True)
                print(f"   ✅ {endpoint}: {response.status_code} - Streaming")
                response.close()
            else:
                response = requests.get(f"{base_url}{endpoint}", timeout=3)
                print(f"   ✅ {endpoint}: {response.status_code}")
        except Exception as e:
            print(f"   ❌ {endpoint}: {e}")

def check_flutter():
    print("\n📱 Checking Flutter...")
    
    try:
        result = subprocess.run(['flutter', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            version_line = result.stdout.split('\n')[0]
            print(f"   ✅ {version_line}")
        else:
            print(f"   ❌ Flutter error: {result.stderr}")
    except Exception as e:
        print(f"   ❌ Flutter not found: {e}")

def check_chrome():
    print("\n🌐 Checking Chrome...")
    
    try:
        result = subprocess.run(['google-chrome', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"   ✅ {result.stdout.strip()}")
        else:
            # Try alternative Chrome command
            result = subprocess.run(['/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', '--version'], capture_output=True, text=True)
            if result.returncode == 0:
                print(f"   ✅ {result.stdout.strip()}")
            else:
                print(f"   ❌ Chrome not found")
    except Exception as e:
        print(f"   ❌ Chrome error: {e}")

def main():
    print("🚀 Red Weevil Detection - System Diagnostics")
    print("=" * 50)
    
    check_system_requirements()
    check_network()
    check_camera()
    check_flask_server()
    check_flutter()
    check_chrome()
    
    print("\n" + "=" * 50)
    print("📋 Diagnostic Summary:")
    print("1. If camera is working but Flask endpoints fail, restart Flask server")
    print("2. If network issues, check firewall settings")
    print("3. If Flutter issues, run 'flutter clean' and 'flutter pub get'")
    print("4. Check browser console (F12) for JavaScript errors")
    print("5. Try the improved camera page with better error handling")

if __name__ == "__main__":
    main()
