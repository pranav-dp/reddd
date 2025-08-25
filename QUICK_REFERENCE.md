# 🚀 Quick Reference - Red Weevil Detection

## 🎯 Essential Commands

### First Time Setup
```bash
./setup.sh                    # Complete setup (run once)
```

### Start Demo
```bash
./start_demo.sh              # Start Flask server
```

### Start Flutter (New Terminal)
```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

### Update IP Address
```bash
./update_ip.sh               # Auto-update IP configuration
```

## 🔧 Troubleshooting Commands

### Camera Issues
```bash
python test_camera.py        # Test camera access
```

### Port Issues
```bash
lsof -ti:5000 | xargs kill -9    # Kill processes on port 5000
```

### Check Server Status
```bash
curl http://your-ip:5000/status  # Test server connection
```

### View Server Logs
```bash
tail -f flask_server.log     # Live server logs
```

## ⚙️ Configuration Files

| File | Purpose |
|------|---------|
| `lib/config.dart` | Server IP configuration |
| `videostream.py` | Camera settings |
| `main.py` | Detection logic & server |
| `requirements.txt` | Python dependencies |

## 🎮 Demo Navigation

1. **Login**: `admin` / `password`
2. **Home** → **Device Management**
3. **Device List** → **Click any device**
4. **Live Camera Feed** → **Enjoy!**

## 📊 Performance Tuning

### Frame Rate (Flutter)
```dart
// lib/camera_page_improved.dart
Timer.periodic(const Duration(milliseconds: 50), // 20 FPS
Timer.periodic(const Duration(milliseconds: 33), // 30 FPS
Timer.periodic(const Duration(milliseconds: 16), // 60 FPS
```

### Video Quality (Python)
```python
# main.py
cv2.IMWRITE_JPEG_QUALITY, 80  # Standard quality
cv2.IMWRITE_JPEG_QUALITY, 95  # High quality
```

### Camera Resolution (Python)
```python
# videostream.py
self.stream.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)   # Width
self.stream.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)   # Height
```

## 🌐 URLs

- **Main Server**: http://your-ip:5000
- **Video Feed**: http://your-ip:5000/frame
- **Detection API**: http://your-ip:5000/detection
- **Status API**: http://your-ip:5000/status

## 🛑 Stop Everything

- **Flutter**: Press `q` in Flutter terminal
- **Flask**: Press `Ctrl+C` in Flask terminal

---

**💡 Tip**: Keep this reference handy while developing!
