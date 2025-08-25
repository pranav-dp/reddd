from flask import Flask, Response, render_template, jsonify
from flask_cors import CORS, cross_origin
import cv2
from threading import Thread
import time
import random
import json
from videostream import VideoStream
try:
    import psutil
    PSUTIL_AVAILABLE = True
except ImportError:
    PSUTIL_AVAILABLE = False
    print("⚠️  psutil not available - memory monitoring disabled")
import gc

class WeevileDetector:
    def __init__(self):
        self.last_detection = False
        self.detection_count = 0
        
    def detect_weevil(self, frame):
        # Placeholder detection logic - replace with your actual model
        # For demo purposes, randomly detect weevils
        detection_probability = random.random()
        
        # Simulate detection based on some criteria (for demo)
        if detection_probability > 0.8:  # 20% chance of detection
            self.last_detection = True
            self.detection_count += 1
            return True, "Red Weevil Detected!"
        else:
            self.last_detection = False
            return False, "No Weevils Detected"

app = Flask(__name__)

# More permissive CORS configuration for Flutter web
CORS(app, resources={
    r"/*": {
        "origins": ["*"],
        "methods": ["GET", "POST", "OPTIONS", "PUT", "DELETE"],
        "allow_headers": ["Content-Type", "Authorization", "Access-Control-Allow-Credentials"],
        "supports_credentials": True
    }
})

# Add CORS headers to all responses
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    response.headers.add('Access-Control-Allow-Credentials', 'true')
    return response

# Initialize video stream and detector
vs = VideoStream(src=0).start()  # start threaded camera feed
detector = WeevileDetector()

# Global variables for frame processing
current_processed_frame = None
last_frame_time = 0
frame_lock = Thread()
frame_count = 0
memory_check_interval = 100  # Check memory every 100 frames

def get_memory_usage():
    """Get current memory usage in MB"""
    if PSUTIL_AVAILABLE:
        process = psutil.Process()
        return process.memory_info().rss / 1024 / 1024
    return 0

def process_frame_continuously():
    """Continuously process frames in a separate thread"""
    global current_processed_frame, last_frame_time, frame_count
    
    while True:
        try:
            # Get frame from video stream
            frame = vs.read()
            if frame is None:
                time.sleep(0.01)  # Small delay if no frame
                continue
                
            # Run detection on frame
            detected, message = detector.detect_weevil(frame)
            
            # Add detection overlay to frame
            if detected:
                cv2.putText(frame, "WEEVIL DETECTED!", (10, 30), 
                           cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                cv2.rectangle(frame, (10, 50), (200, 100), (0, 0, 255), 2)
            else:
                cv2.putText(frame, "Monitoring...", (10, 30), 
                           cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            
            # Encode frame as JPEG with optimized settings
            ret, buffer = cv2.imencode('.jpg', frame, [
                cv2.IMWRITE_JPEG_QUALITY, 80,  # Slightly lower quality for smaller size
                cv2.IMWRITE_JPEG_OPTIMIZE, 1   # Enable optimization
            ])
            
            if ret:
                # Replace old frame (automatic cleanup)
                current_processed_frame = buffer.tobytes()
                last_frame_time = time.time()
                frame_count += 1
                
                # Periodic memory monitoring and cleanup
                if frame_count % memory_check_interval == 0:
                    if PSUTIL_AVAILABLE:
                        memory_mb = get_memory_usage()
                        if memory_mb > 500:  # If using more than 500MB
                            print(f"⚠️  High memory usage: {memory_mb:.1f}MB - Running garbage collection")
                            gc.collect()  # Force garbage collection
                        elif frame_count % (memory_check_interval * 10) == 0:  # Every 1000 frames
                            print(f"📊 Memory usage: {memory_mb:.1f}MB, Frames processed: {frame_count}")
                    else:
                        # Just run garbage collection periodically without monitoring
                        if frame_count % (memory_check_interval * 5) == 0:  # Every 500 frames
                            gc.collect()
                            print(f"🧹 Garbage collection run, Frames processed: {frame_count}")
            
            # Control frame processing rate (30 FPS max)
            time.sleep(1/30)
            
        except Exception as e:
            print(f"Frame processing error: {e}")
            time.sleep(0.1)

def generate_frames():
    """Generator for video streaming"""
    global current_processed_frame
    
    while True:
        if current_processed_frame is not None:
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + current_processed_frame + b'\r\n')
        time.sleep(1/60)  # 60 FPS streaming

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    """Streaming video feed endpoint"""
    return Response(generate_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/frame')
@cross_origin()
def get_frame():
    """Get a single frame as JPEG - optimized for Flutter web"""
    global current_processed_frame, last_frame_time
    
    # Check if we have a recent frame (within last 2 seconds)
    if current_processed_frame is None or (time.time() - last_frame_time) > 2:
        return "Camera not available", 503
    
    response = Response(current_processed_frame, mimetype='image/jpeg')
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

@app.route('/detection')
@cross_origin()
def get_detection():
    """API endpoint for Flutter app to get detection status"""
    return jsonify({
        'detected': detector.last_detection,
        'message': "Red Weevil Detected!" if detector.last_detection else "No Weevils Detected",
        'detection_count': detector.detection_count,
        'timestamp': time.time()
    })

@app.route('/status')
@cross_origin()
def get_status():
    """API endpoint to check if camera is working"""
    global current_processed_frame, last_frame_time
    
    # Check if we have recent frames
    camera_status = current_processed_frame is not None and (time.time() - last_frame_time) < 5
    
    return jsonify({
        'camera_active': camera_status,
        'detection_active': True,
        'total_detections': detector.detection_count,
        'last_frame_time': last_frame_time
    })

if __name__ == '__main__':
    try:
        # Start frame processing thread
        frame_thread = Thread(target=process_frame_continuously, daemon=True)
        frame_thread.start()
        
        print("🎥 Video stream started")
        print("🔍 Frame processing thread started")
        
        # Run Flask server on all interfaces so Flutter app can connect
        app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)
    finally:
        print("🛑 Stopping video stream...")
        vs.stop()
