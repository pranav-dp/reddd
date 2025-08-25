#!/usr/bin/env python3
import requests
import json
import time

def test_flutter_endpoints():
    base_url = "http://10.250.124.96:5000"
    
    print("🧪 Testing Flutter-Flask connection...")
    
    # Test status endpoint
    try:
        print("\n1. Testing /status endpoint...")
        response = requests.get(f"{base_url}/status", timeout=5)
        print(f"   Status Code: {response.status_code}")
        print(f"   Response: {response.json()}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    # Test detection endpoint
    try:
        print("\n2. Testing /detection endpoint...")
        response = requests.get(f"{base_url}/detection", timeout=5)
        print(f"   Status Code: {response.status_code}")
        print(f"   Response: {response.json()}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    # Test video feed endpoint
    try:
        print("\n3. Testing /video_feed endpoint...")
        response = requests.get(f"{base_url}/video_feed", timeout=5, stream=True)
        print(f"   Status Code: {response.status_code}")
        print(f"   Content-Type: {response.headers.get('Content-Type')}")
        print(f"   CORS Headers: {response.headers.get('Access-Control-Allow-Origin')}")
        
        # Read first few bytes to verify it's working
        chunk = next(response.iter_content(chunk_size=1024))
        print(f"   First chunk size: {len(chunk)} bytes")
        print("   ✅ Video feed is streaming!")
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
    
    print("\n✅ Connection test completed!")

if __name__ == "__main__":
    test_flutter_endpoints()
