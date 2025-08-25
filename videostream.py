import cv2
from threading import Thread
import time

class VideoStream:
    def __init__(self, src=0, fps=30):
        """
        Initialize video stream
        Args:
            src: Camera source (0 for default camera)
            fps: Target FPS for camera capture
        """
        self.stream = cv2.VideoCapture(src)
        
        # Set camera properties for better performance
        self.stream.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
        self.stream.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
        self.stream.set(cv2.CAP_PROP_FPS, fps)
        self.stream.set(cv2.CAP_PROP_BUFFERSIZE, 1)  # Reduce buffer to minimize latency
        
        # Read first frame
        (self.grabbed, self.frame) = self.stream.read()
        self.stopped = False
        
        # Camera warm-up time
        time.sleep(1.0)
        
        print(f"📹 Camera initialized: {self.stream.get(cv2.CAP_PROP_FRAME_WIDTH)}x{self.stream.get(cv2.CAP_PROP_FRAME_HEIGHT)} @ {self.stream.get(cv2.CAP_PROP_FPS)} FPS")
    
    def start(self):
        """Start the video stream thread"""
        t = Thread(target=self.update, args=())
        t.daemon = True
        t.start()
        print("🎬 Video stream thread started")
        return self
    
    def update(self):
        """Continuously read frames from camera"""
        while True:
            if self.stopped:
                return
            
            # Read frame from camera
            (self.grabbed, self.frame) = self.stream.read()
            
            # Small delay to prevent excessive CPU usage
            time.sleep(0.001)  # 1ms delay
    
    def read(self):
        """Return the current frame"""
        return self.frame
    
    def stop(self):
        """Stop the video stream"""
        self.stopped = True
        if self.stream.isOpened():
            self.stream.release()
        print("🛑 Video stream stopped")
