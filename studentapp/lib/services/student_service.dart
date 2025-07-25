import '../models/models.dart';
import 'api_service.dart';

/// Service for handling student-related API calls
class StudentService {
  static const String _endpoint = '/students';

  /// Get all students
  static Future<List<Student>> getAllStudents() async {
    try {
      final response = await ApiService.get(_endpoint);

      // Handle array response
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      // Handle object with data field
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List data = response['data'];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Không thể tải danh sách sinh viên: $e');
    }
  }

  /// Get student by ID
  static Future<Student> getStudentById(String id) async {
    try {
      final response = await ApiService.get('$_endpoint/$id');
      return Student.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tải thông tin sinh viên: $e');
    }
  }

  /// Create new student
  static Future<Student> createStudent(Student student) async {
    try {
      final response = await ApiService.post(_endpoint, student.toJson());
      return Student.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tạo sinh viên mới: $e');
    }
  }

  /// Update existing student
  static Future<Student> updateStudent(String id, Student student) async {
    try {
      final response = await ApiService.put('$_endpoint/$id', student.toJson());
      return Student.fromJson(response);
    } catch (e) {
      throw Exception('Không thể cập nhật sinh viên: $e');
    }
  }

  /// Delete student by ID
  static Future<void> deleteStudent(String id) async {
    try {
      await ApiService.delete('$_endpoint/$id');
    } catch (e) {
      throw Exception('Không thể xóa sinh viên: $e');
    }
  }

  /// Search students by name
  static Future<List<Student>> searchStudentsByName(String name) async {
    try {
      final response = await ApiService.get('$_endpoint/search?name=$name');

      // Handle array response
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      // Handle object with data field
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List data = response['data'];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Không thể tìm kiếm sinh viên: $e');
    }
  }

  /// Get students by birth year
  static Future<List<Student>> getStudentsByBirthYear(int year) async {
    try {
      final response = await ApiService.get('$_endpoint/birth-year/$year');

      // Handle array response
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      // Handle object with data field
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List data = response['data'];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Student.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Không thể lấy danh sách sinh viên theo năm sinh: $e');
    }
  }
}
