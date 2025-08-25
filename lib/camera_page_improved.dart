import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class CameraPageImproved extends StatefulWidget {
  const CameraPageImproved({super.key});

  @override
  State<CameraPageImproved> createState() => _CameraPageImprovedState();
}

class _CameraPageImprovedState extends State<CameraPageImproved> {
  String detectionMessage = "Connecting to camera...";
  bool isDetected = false;
  bool isCameraConnected = false;
  int detectionCount = 0;
  Timer? _detectionTimer;
  String _imageUrl = '';
  int _imageCounter = 0;
  String _lastError = '';
  
  // Use configuration for server connection
  final String piIp = AppConfig.serverIp;
  final int piPort = AppConfig.serverPort;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startDetectionPolling();
    _checkCameraStatus();
  }

  void _initializeCamera() {
    // Use single frame endpoint with optimized threaded backend
    _imageUrl = 'http://$piIp:$piPort/frame';
    
    // Refresh image every 33ms for smooth 30 FPS experience
    // Backend now uses threading so this is much more efficient
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _imageCounter++;
          // Add timestamp to prevent caching
          _imageUrl = 'http://$piIp:$piPort/frame?t=${DateTime.now().millisecondsSinceEpoch}';
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _startDetectionPolling() {
    _detectionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _fetchDetectionStatus();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _fetchDetectionStatus() async {
    if (!mounted) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://$piIp:$piPort/detection'),
      ).timeout(const Duration(seconds: 5));

      if (mounted && response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isDetected = data['detected'] ?? false;
          detectionMessage = data['message'] ?? "No data";
          detectionCount = data['detection_count'] ?? 0;
          isCameraConnected = true;
          _lastError = '';
        });
      } else {
        setState(() {
          _lastError = 'HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          detectionMessage = "Connection error: ${e.toString()}";
          _lastError = e.toString();
        });
        print('Detection fetch error: $e');
      }
    }
  }

  Future<void> _checkCameraStatus() async {
    if (!mounted) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://$piIp:$piPort/status'),
      ).timeout(const Duration(seconds: 5));

      if (mounted && response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isCameraConnected = data['camera_active'] ?? false;
          _lastError = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isCameraConnected = false;
          _lastError = e.toString();
        });
        print('Status check error: $e');
      }
    }
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                if (_lastError.isNotEmpty) _buildErrorBanner(),
                Expanded(
                  child: _buildCameraContent(),
                ),
                _buildDetectionStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error: $_lastError',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _checkCameraStatus();
              _fetchDetectionStatus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Red Weevil Camera',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCameraConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCameraConnected ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isCameraConnected ? 'Connected' : 'Disconnected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDetected ? Colors.red : Colors.green,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildCameraFeed(),
      ),
    );
  }

  Widget _buildCameraFeed() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Camera feed image
          Image.network(
            _imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Loading camera feed...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('Image loading error: $error');
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Camera Feed Error',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _imageCounter++;
                          _imageUrl = 'http://$piIp:$piPort/frame?t=${DateTime.now().millisecondsSinceEpoch}';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94560),
                      ),
                      child: const Text(
                        'Retry Connection',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Detection overlay
          if (isDetected)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'WEEVIL DETECTED!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Debug info
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'URL: $_imageUrl',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Counter: $_imageCounter',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionStatus() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDetected ? const Color(0xFFE94560) : const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDetected ? Colors.red.withOpacity(0.3) : Colors.transparent,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isDetected ? Icons.warning : Icons.check_circle,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDetected ? 'ALERT!' : 'All Clear',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      detectionMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (detectionCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Total Detections: $detectionCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
