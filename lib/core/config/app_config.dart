class AppConfig {
  static const String appName = 'Cashora';
  // Android Emulator: 10.0.2.2, iOS Simulator: 127.0.0.1, Physical Device: YOUR_LOCAL_IP
  static const String apiBaseUrl = 'http://192.168.0.150:8000';
  
  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
