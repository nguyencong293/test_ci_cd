import '../models/models.dart';
import 'api_service.dart';

/// Service for handling grade-related API calls
class GradeService {
  static const String _endpoint = '/grades';

  /// Get all grades
  static Future<List<Grade>> getAllGrades() async {
    try {
      final response = await ApiService.get(_endpoint);

      // Handle array response
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map((json) => Grade.fromJson(json))
            .toList();
      }

      // Handle object with data field
      if (response is Map<String, dynamic> && response['data'] is List) {
        final List data = response['data'];
        return data
            .whereType<Map<String, dynamic>>()
            .map((json) => Grade.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Không thể tải danh sách điểm: $e');
    }
  }

  /// Get grade by ID
  static Future<Grade> getGradeById(int id) async {
    try {
      final response = await ApiService.get('$_endpoint/$id');
      return Grade.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tải thông tin điểm: $e');
    }
  }

  /// Create new grade
  static Future<Grade> createGrade(Grade grade) async {
    try {
      final response = await ApiService.post(_endpoint, grade.toJson());
      return Grade.fromJson(response);
    } catch (e) {
      throw Exception('Không thể tạo điểm mới: $e');
    }
  }

  /// Update existing grade
  static Future<Grade> updateGrade(int id, Grade grade) async {
    try {
      final response = await ApiService.put('$_endpoint/$id', grade.toJson());
      return Grade.fromJson(response);
    } catch (e) {
      throw Exception('Không thể cập nhật điểm: $e');
    }
  }

  /// Delete grade
  static Future<void> deleteGrade(int id) async {
    try {
      await ApiService.delete('$_endpoint/$id');
    } catch (e) {
      throw Exception('Không thể xóa điểm: $e');
    }
  }

  /// Get grades by student ID
  static Future<List<Grade>> getGradesByStudentId(String studentId) async {
    try {
      final response = await ApiService.get('$_endpoint/student/$studentId');

      List<dynamic> gradesJson;
      if (response is List) {
        gradesJson = response;
      } else if (response.containsKey('data') && response['data'] is List) {
        gradesJson = response['data'];
      } else {
        gradesJson = [];
      }

      return gradesJson
          .whereType<Map<String, dynamic>>()
          .map((json) => Grade.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải điểm của sinh viên: $e');
    }
  }

  /// Get grades by subject ID
  static Future<List<Grade>> getGradesBySubjectId(String subjectId) async {
    try {
      final response = await ApiService.get('$_endpoint/subject/$subjectId');

      List<dynamic> gradesJson;
      if (response is List) {
        gradesJson = response;
      } else if (response.containsKey('data') && response['data'] is List) {
        gradesJson = response['data'];
      } else {
        gradesJson = [];
      }

      return gradesJson
          .whereType<Map<String, dynamic>>()
          .map((json) => Grade.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải điểm của môn học: $e');
    }
  }

  /// Get average score by student ID
  static Future<double> getAverageScoreByStudentId(String studentId) async {
    try {
      final response = await ApiService.get(
        '$_endpoint/student/$studentId/average',
      );
      return (response as num).toDouble();
    } catch (e) {
      throw Exception('Không thể tải điểm trung bình của sinh viên: $e');
    }
  }

  /// Get average score by subject ID
  static Future<double> getAverageScoreBySubjectId(String subjectId) async {
    try {
      final response = await ApiService.get(
        '$_endpoint/subject/$subjectId/average',
      );
      return (response as num).toDouble();
    } catch (e) {
      throw Exception('Không thể tải điểm trung bình của môn học: $e');
    }
  }
}
