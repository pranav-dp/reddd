# 🎯 Red Weevil Detection - Quick Demo Guide

Get the Red Weevil Detection system running in under 2 minutes!

## 🚀 Quick Start (2 Steps)

### Step 1: Start the Backend Server

```bash
./start_demo.sh
```

This will:
- ✅ Activate the Python virtual environment
- ✅ Start the Flask server with camera feed
- ✅ Display server URL and next steps

### Step 2: Start the Flutter Web App

Open a **new terminal** and run:

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

This will:
- ✅ Launch Chrome with CORS disabled
- ✅ Open the Flutter web app
- ✅ Connect to the camera feed

## 🎮 Using the Demo

1. **Login Screen**: Use `admin` / `password`
2. **Home Screen**: Click "Device Management"
3. **Device List**: Click on any device
4. **Camera Feed**: Live video with weevil detection!

## 📱 Demo Features

- **Live Camera**: 20 FPS real-time video feed
- **Weevil Detection**: Random detection simulation (20% chance)
- **Detection Counter**: Shows total detections found
- **Status Indicators**: Connection and camera status
- **Responsive UI**: Works on different screen sizes

## 🔧 If Something Goes Wrong

### Camera Not Working?
```bash
# Test your camera
python test_camera.py
```

### Port 5000 Busy?
```bash
# Kill processes using port 5000
lsof -ti:5000 | xargs kill -9
```

### IP Address Changed?
```bash
# Update IP configuration
./update_ip.sh
```

### Flutter Not Loading?
- Make sure you used the `--disable-web-security` flag
- Check that Flask server is running (should show in terminal)
- Try refreshing the browser

## 🌐 Access URLs

- **Flask Server**: http://your-ip:5000
- **Video Feed**: http://your-ip:5000/frame
- **API Status**: http://your-ip:5000/status
- **Flutter App**: Opens automatically in Chrome

## ⚡ Performance Tips

### For Smoother Video:
Edit `lib/camera_page_improved.dart`:
```dart
// Faster refresh (30 FPS)
Timer.periodic(const Duration(milliseconds: 33), (timer) {

// Even faster (60 FPS) - might be laggy
Timer.periodic(const Duration(milliseconds: 16), (timer) {
```

### For Better Quality:
Edit `main.py`:
```python
# Higher JPEG quality
cv2.IMWRITE_JPEG_QUALITY, 95  # Instead of 80
```

## 🛑 Stopping the Demo

1. **Stop Flutter**: Press `q` in the Flutter terminal
2. **Stop Flask**: Press `Ctrl+C` in the Flask terminal

## 📊 Demo Stats

- **Video Resolution**: 1280x720
- **Frame Rate**: 30 FPS (backend) / 20 FPS (frontend)
- **Detection Rate**: 20% random simulation
- **Memory Usage**: ~300KB per frame (constant)
- **Network**: Local only (no internet required)

## 🎯 Next Steps

After the demo works:
1. **Customize Detection**: Replace random detection with real AI model
2. **Add Authentication**: Implement proper user management
3. **Deploy**: Use production WSGI server for deployment
4. **Scale**: Add multiple camera support

---

**🎉 Enjoy the Demo! Questions? Check the main README.md**
