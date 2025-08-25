class AppConfig {
  // Update this IP address when your Mac's IP changes
  static const String serverIp = "10.250.124.96";
  static const int serverPort = 5000;
  
  static String get baseUrl => "http://$serverIp:$serverPort";
  static String get videoFeedUrl => "$baseUrl/video_feed";
  static String get detectionUrl => "$baseUrl/detection";
  static String get statusUrl => "$baseUrl/status";
  
  // Helper method to get current Mac IP (you can run this command manually)
  static String getCurrentIpCommand() {
    return "ifconfig | grep 'inet ' | grep -v 127.0.0.1";
  }
}
