#!/usr/bin/env python3
import cv2
import sys

def test_camera():
    print("🔍 Testing camera access...")
    
    # Try different camera indices
    for i in range(3):
        print(f"Trying camera index {i}...")
        cap = cv2.VideoCapture(i)
        
        if cap.isOpened():
            ret, frame = cap.read()
            if ret and frame is not None:
                print(f"✅ Camera {i} is working! Frame shape: {frame.shape}")
                cap.release()
                return i
            else:
                print(f"❌ Camera {i} opened but no frame received")
        else:
            print(f"❌ Camera {i} could not be opened")
        
        cap.release()
    
    print("❌ No working cameras found!")
    return None

if __name__ == "__main__":
    camera_index = test_camera()
    if camera_index is not None:
        print(f"\n🎥 Use camera index {camera_index} in your main.py")
        print("✅ Camera test completed successfully!")
    else:
        print("\n❌ Camera test failed!")
        print("💡 Try these solutions:")
        print("1. Check if another app is using the camera")
        print("2. Grant camera permissions to Terminal/Python")
        print("3. Try connecting an external USB camera")
        sys.exit(1)
