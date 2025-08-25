#!/usr/bin/env python3
import requests
import cv2
import numpy as np
from io import BytesIO

def test_video_feed():
    url = "http://10.250.124.96:5000/video_feed"
    
    print(f"🔍 Testing video feed at: {url}")
    
    try:
        # Test with a timeout
        response = requests.get(url, timeout=10, stream=True)
        print(f"📡 Response status: {response.status_code}")
        print(f"📋 Response headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            # Read first chunk of data
            chunk = next(response.iter_content(chunk_size=1024))
            print(f"📦 First chunk length: {len(chunk)} bytes")
            print(f"🔤 First 100 chars: {chunk[:100]}")
            
            # Check if it looks like a multipart response
            if b'--frame' in chunk:
                print("✅ Looks like a valid multipart video stream")
            else:
                print("❌ Doesn't look like a multipart video stream")
        else:
            print(f"❌ HTTP Error: {response.status_code}")
            
    except requests.exceptions.Timeout:
        print("❌ Request timed out")
    except requests.exceptions.ConnectionError:
        print("❌ Connection error")
    except Exception as e:
        print(f"❌ Error: {e}")

def test_single_frame():
    """Test getting a single frame from the camera"""
    print("\n🎥 Testing direct camera access...")
    
    try:
        cap = cv2.VideoCapture(0)
        if not cap.isOpened():
            print("❌ Cannot open camera")
            return
            
        ret, frame = cap.read()
        if ret:
            print(f"✅ Got frame: {frame.shape}")
            # Encode as JPEG
            ret, buffer = cv2.imencode('.jpg', frame)
            if ret:
                print(f"✅ JPEG encoding successful: {len(buffer)} bytes")
            else:
                print("❌ JPEG encoding failed")
        else:
            print("❌ Cannot read frame")
            
        cap.release()
        
    except Exception as e:
        print(f"❌ Camera error: {e}")

if __name__ == "__main__":
    test_video_feed()
    test_single_frame()
