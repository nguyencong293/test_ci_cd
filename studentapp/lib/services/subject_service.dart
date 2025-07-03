import '../models/models.dart';
import 'api_service.dart';

/// Service for handling subject-related API calls
class SubjectService {
  static const String _endpoint = '/subjects';

  /// Get all subjects
  static Future<List<Subject>> getAllSubjects() async {
    try {
      final response = await ApiService.get(_endpoint);

      // Handle array response
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Subject.fromJson(json))
            .toList();
      }

      // Handle object with data field
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List data = response['data'];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Subject.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Không thể tải danh sách môn học: $e');
    }
  }

  /// Get subject by ID
  static Future<Subject> getSubjectById(String id) async {
    try {
      final response = await ApiService.get('$_endpoint/$id');
      return Subject.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tải thông tin môn học: $e');
    }
  }

  /// Create new subject
  static Future<Subject> createSubject(Subject subject) async {
    try {
      final response = await ApiService.post(_endpoint, subject.toJson());
      return Subject.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tạo môn học mới: $e');
    }
  }

  /// Update existing subject
  static Future<Subject> updateSubject(String id, Subject subject) async {
    try {
      final response = await ApiService.put('$_endpoint/$id', subject.toJson());
      return Subject.fromJson(response);
    } catch (e) {
      throw Exception('Không thể cập nhật môn học: $e');
    }
  }

  /// Delete subject
  static Future<void> deleteSubject(String id) async {
    try {
      await ApiService.delete('$_endpoint/$id');
    } catch (e) {
      throw Exception('Không thể xóa môn học: $e');
    }
  }

  /// Search subjects by name
  static Future<List<Subject>> searchSubjectsByName(String name) async {
    try {
      final response = await ApiService.get('$_endpoint/search?name=$name');

      List<dynamic> subjectsJson;
      if (response is List) {
        subjectsJson = response;
      } else if (response.containsKey('data') && response['data'] is List) {
        subjectsJson = response['data'];
      } else {
        subjectsJson = [];
      }

      return subjectsJson
          .whereType<Map<String, dynamic>>()
          .map((json) => Subject.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Không thể tìm kiếm môn học: $e');
    }
  }
}
