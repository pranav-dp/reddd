#!/usr/bin/env python3
"""
Test script to verify the Flask server connection
"""
import requests
import json

def test_flask_connection():
    base_url = "http://10.250.124.96:5000"
    
    print("🧪 Testing Flask Server Connection...")
    print(f"📡 Base URL: {base_url}")
    print("-" * 50)
    
    # Test 1: Status endpoint
    try:
        print("1️⃣ Testing /status endpoint...")
        response = requests.get(f"{base_url}/status", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Status: {response.status_code}")
            print(f"   📊 Camera Active: {data.get('camera_active')}")
            print(f"   🔍 Detection Active: {data.get('detection_active')}")
            print(f"   📈 Total Detections: {data.get('total_detections')}")
        else:
            print(f"   ❌ Status: {response.status_code}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print()
    
    # Test 2: Detection endpoint
    try:
        print("2️⃣ Testing /detection endpoint...")
        response = requests.get(f"{base_url}/detection", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Status: {response.status_code}")
            print(f"   🚨 Detected: {data.get('detected')}")
            print(f"   💬 Message: {data.get('message')}")
            print(f"   📊 Count: {data.get('detection_count')}")
        else:
            print(f"   ❌ Status: {response.status_code}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print()
    
    # Test 3: Video feed endpoint (just check headers)
    try:
        print("3️⃣ Testing /video_feed endpoint...")
        response = requests.head(f"{base_url}/video_feed", timeout=5)
        if response.status_code == 200:
            print(f"   ✅ Status: {response.status_code}")
            print(f"   📹 Content-Type: {response.headers.get('Content-Type')}")
            print(f"   🌐 CORS Headers: {response.headers.get('Access-Control-Allow-Origin')}")
        else:
            print(f"   ❌ Status: {response.status_code}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print()
    print("🎯 Recommendations:")
    print("   • If all tests pass, the Flask server is working correctly")
    print("   • If Flutter web app can't connect, try:")
    print("     - Run Chrome with --disable-web-security flag")
    print("     - Use Flutter mobile app instead of web")
    print("     - Check browser console for CORS errors")

if __name__ == "__main__":
    test_flask_connection()
