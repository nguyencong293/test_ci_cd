/// App configuration constants
class AppConfig {
  static const String appName = 'Student Manager';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://192.168.1.7:8080/api';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;

  // Grade validation
  static const double minGrade = 0.0;
  static const double maxGrade = 10.0;
}
