#!/usr/bin/env python3
"""
Quick test script to verify the setup is working
"""
import cv2
import requests
import json

def test_camera():
    """Test if camera is accessible"""
    print("🎥 Testing camera access...")
    try:
        cap = cv2.VideoCapture(0)
        ret, frame = cap.read()
        cap.release()
        if ret:
            print("✅ Camera is working!")
            return True
        else:
            print("❌ Camera not accessible")
            return False
    except Exception as e:
        print(f"❌ Camera error: {e}")
        return False

def test_flask_server():
    """Test if Flask server endpoints work"""
    print("🌐 Testing Flask server...")
    try:
        # Test status endpoint
        response = requests.get("http://10.250.124.96:5000/status", timeout=5)
        if response.status_code == 200:
            print("✅ Flask server is responding!")
            data = response.json()
            print(f"   Camera active: {data.get('camera_active', False)}")
            return True
        else:
            print(f"❌ Server returned status code: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to Flask server")
        print("   Make sure to run: python main.py")
        return False
    except Exception as e:
        print(f"❌ Server error: {e}")
        return False

def main():
    print("🔧 Red Weevil Detection Setup Test")
    print("=" * 40)
    
    camera_ok = test_camera()
    print()
    
    print("Note: Start Flask server with 'python main.py' before testing server")
    server_ok = test_flask_server()
    print()
    
    if camera_ok and server_ok:
        print("🎉 All tests passed! Ready for demo!")
    elif camera_ok:
        print("⚠️  Camera works, but start Flask server")
    else:
        print("❌ Setup needs attention")
    
    print("\n📱 To run Flutter app:")
    print("   flutter run")
    print("   Then navigate to: Device Details > Live Camera Feed")

if __name__ == "__main__":
    main()
