# 🐛 Red Weevil Detection System

A real-time computer vision system for detecting red weevils using Flutter web frontend and Python Flask backend with OpenCV camera integration.

## 🌟 Features

- **Real-time Camera Feed**: Live video streaming at 20+ FPS
- **Weevil Detection**: AI-powered detection with visual alerts
- **Cross-platform**: Flutter web app with responsive design
- **Threaded Processing**: Optimized performance with multi-threading
- **Live Statistics**: Real-time detection counts and status monitoring
- **Modern UI**: Dark theme with gradient backgrounds and animations

## 🏗️ Architecture

```
┌─────────────────┐    HTTP/REST    ┌──────────────────┐
│   Flutter Web   │ ◄──────────────► │   Flask Server   │
│   Frontend      │                 │   (Python)       │
└─────────────────┘                 └──────────────────┘
                                             │
                                             ▼
                                    ┌──────────────────┐
                                    │   OpenCV Camera  │
                                    │   + Detection    │
                                    └──────────────────┘
```

## 📋 Prerequisites

- **Flutter SDK** (3.35.1 or later)
- **Python 3.8+** with pip
- **Camera/Webcam** access
- **Chrome Browser** (for web testing)
- **macOS/Linux/Windows** (tested on macOS)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <repository-url>
cd reddd
```

### 2. Backend Setup

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Frontend Setup

```bash
# Install Flutter dependencies
flutter pub get
```

### 4. Update Configuration

Update your IP address in the configuration:

```bash
# Get your current IP
ifconfig | grep "inet " | grep -v 127.0.0.1

# Update the IP in lib/config.dart
# Replace "10.250.124.96" with your actual IP address
```

Or use the auto-update script:

```bash
./update_ip.sh
```

## 🎯 Running the Demo

### Option 1: Quick Demo (Recommended)

```bash
# Start the Flask server
./start_demo.sh
```

In a new terminal:

```bash
# Start Flutter web app
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### Option 2: Manual Start

**Terminal 1 - Backend:**
```bash
source venv/bin/activate
python main.py
```

**Terminal 2 - Frontend:**
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## 🌐 Accessing the Application

1. **Flask Server**: http://your-ip:5000
2. **Flutter App**: Automatically opens in Chrome
3. **Navigation**: Login → Home → Device Details → Live Camera Feed

### Default Login Credentials
- **Username**: `admin`
- **Password**: `password`

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/video_feed` | GET | Streaming video feed (multipart) |
| `/frame` | GET | Single frame (JPEG) |
| `/detection` | GET | Current detection status |
| `/status` | GET | Camera and system status |

### Example API Response

```json
{
  "detected": false,
  "message": "No Weevils Detected",
  "detection_count": 42,
  "timestamp": 1756152714.65
}
```

## ⚙️ Configuration

### Camera Settings
Edit `videostream.py`:
```python
# Camera resolution
self.stream.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
self.stream.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

# Frame rate
self.stream.set(cv2.CAP_PROP_FPS, 30)
```

### Flutter Refresh Rate
Edit `lib/camera_page_improved.dart`:
```dart
// Change refresh interval (milliseconds)
Timer.periodic(const Duration(milliseconds: 50), (timer) {
  // 50ms = 20 FPS
  // 33ms = 30 FPS  
  // 16ms = 60 FPS
```

### Detection Sensitivity
Edit `main.py`:
```python
# Adjust detection probability threshold
if detection_probability > 0.8:  # 20% chance (demo mode)
    # Lower value = more detections
    # Higher value = fewer detections
```

## 🔧 Troubleshooting

### Common Issues

**1. Camera Not Working**
```bash
# Test camera access
python test_camera.py
```

**2. Port 5000 Already in Use**
```bash
# Kill processes on port 5000
lsof -ti:5000 | xargs kill -9

# Or disable AirPlay Receiver in System Preferences
```

**3. IP Address Changed**
```bash
# Update IP automatically
./update_ip.sh

# Then restart both server and Flutter app
```

**4. Flutter Web CORS Issues**
```bash
# Always use the --disable-web-security flag
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

**5. Video Feed Not Loading**
- Check if Flask server is running on correct IP
- Verify camera permissions in System Preferences
- Test video feed directly: http://your-ip:5000/frame

### Performance Optimization

**For Better Performance:**
- Use lower camera resolution (640x480)
- Reduce Flutter refresh rate to 15 FPS (67ms)
- Lower JPEG quality in main.py (60-70%)

**For Better Quality:**
- Increase camera resolution (1920x1080)
- Higher JPEG quality (90-95%)
- Faster refresh rate (30+ FPS)

## 📁 Project Structure

```
reddd/
├── lib/                          # Flutter source code
│   ├── main.dart                # App entry point
│   ├── camera_page_improved.dart # Main camera interface
│   ├── config.dart              # Configuration settings
│   └── ...                      # Other UI pages
├── main.py                      # Flask server
├── videostream.py               # Camera handling
├── requirements.txt             # Python dependencies
├── pubspec.yaml                # Flutter dependencies
├── start_demo.sh               # Quick start script
├── update_ip.sh                # IP update utility
└── README.md                   # This file
```

## 🔒 Security Notes

- **Demo Mode**: Uses basic authentication (admin/password)
- **Network**: Server runs on all interfaces (0.0.0.0)
- **CORS**: Permissive settings for development
- **Production**: Implement proper authentication and HTTPS

## 🚀 Deployment

### Local Network Deployment
1. Update IP in config.dart
2. Run `./start_demo.sh`
3. Access from any device on same network

### Production Deployment
1. Use proper WSGI server (Gunicorn, uWSGI)
2. Implement authentication system
3. Enable HTTPS/SSL
4. Use environment variables for configuration

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **OpenCV** for computer vision capabilities
- **Flutter** for cross-platform UI framework
- **Flask** for lightweight web server
- **Contributors** and testers

## 📞 Support

For issues and questions:
1. Check the troubleshooting section above
2. Review existing GitHub issues
3. Create a new issue with detailed description

---

**Happy Weevil Hunting! 🐛🔍**
