import 'dart:convert';
import 'dart:io';
import '../config/app_config.dart';

/// Base API service with common functionality
abstract class ApiService {
  static const String _baseUrl = AppConfig.baseUrl;
  static const Duration _timeout = AppConfig.apiTimeout;

  /// Common headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET request helper
  static Future<dynamic> get(String endpoint) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = _timeout;

      final request = await client.getUrl(Uri.parse('$_baseUrl$endpoint'));
      _headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      final responseBody = await _readResponse(response);
      client.close();

      return _handleResponse(response.statusCode, responseBody);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request helper
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = _timeout;

      final request = await client.postUrl(Uri.parse('$_baseUrl$endpoint'));
      _headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      request.write(jsonEncode(data));

      final response = await request.close();
      final responseBody = await _readResponse(response);
      client.close();

      return _handleResponse(response.statusCode, responseBody);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request helper
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = _timeout;

      final request = await client.putUrl(Uri.parse('$_baseUrl$endpoint'));
      _headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      request.write(jsonEncode(data));

      final response = await request.close();
      final responseBody = await _readResponse(response);
      client.close();

      return _handleResponse(response.statusCode, responseBody);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request helper
  static Future<void> delete(String endpoint) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = _timeout;

      final request = await client.deleteUrl(Uri.parse('$_baseUrl$endpoint'));
      _headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      final responseBody = await _readResponse(response);
      client.close();

      _handleResponse(response.statusCode, responseBody);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Read response body
  static Future<String> _readResponse(HttpClientResponse response) async {
    final completer = StringBuffer();
    await for (final chunk in response.transform(utf8.decoder)) {
      completer.write(chunk);
    }
    return completer.toString();
  }

  /// Handle HTTP response
  static dynamic _handleResponse(int statusCode, String body) {
    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) {
        return {};
      }
      return jsonDecode(body);
    } else {
      throw ApiException(
        'HTTP $statusCode',
        body.isNotEmpty ? body : 'Unknown error',
      );
    }
  }

  /// Handle errors
  static Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return ApiException('Network Error', 'Không thể kết nối đến server');
    } else if (error is HttpException) {
      return ApiException('HTTP Error', error.message);
    } else if (error is FormatException) {
      return ApiException('Format Error', 'Invalid response format');
    } else {
      return ApiException('Unknown Error', error.toString());
    }
  }
}

/// Custom API exception class
class ApiException implements Exception {
  final String type;
  final String message;

  ApiException(this.type, this.message);

  @override
  String toString() => '$type: $message';
}
